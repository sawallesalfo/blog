---
date: 2025-05-30
authors:
    - ssawadogo
categories: 
    - IAGEN
---


## Trop de SDK pour les LLMs ? Passe à une `LLMFactory`  ou `Adapters` avec LiteLLM

Dans l’univers des LLMs, chaque provider a son propre dialecte.
Tu veux utiliser **OpenAI** ? Tu installes `openai`.
Tu veux **Claude** (Anthropic) ? C’est `anthropic`.
Et pour tester **Groq**, **Mistral**, **Fireworks**, ou même **AWS Bedrock** ? Chacun vient avec son propre SDK, ses headers custom, sa manière de formuler les prompts, et son format de sortie.

C’est vite le **chaos**. 😤

<!-- more -->

Et quand tu construis une app sérieuse — un backend ou un agent LLM — tu ne veux surtout pas que **toute la logique de ton app dépende d’un SDK spécifique**.

C’est pour ça qu’il faut penser **abstraction**, dès le départ. Et c’est là qu’on sort le pattern **`LLMFactory`**.

Perso, dans mes projets, j’ai toujours un petit submodule `llm_factory` qui traîne.

---

### Pourquoi une `LLMFactory` ?

Une `LLMFactory`, c’est comme un **adaptateur intelligent** qui te permet de **changer de fournisseur LLM comme de chemise**, sans toucher au reste de ton code.

Ton app appelle `llm.predict("ma question")`, et la factory se débrouille — que tu sois en local avec Mistral, sur AWS avec Claude 3, ou en API avec GPT-4o.

> **Objectif : découpler ton application de la façon dont tu interagis avec le LLM.**
> Tu choisis le provider au runtime, tu injectes les bonnes clés, et basta.

---

### 🔌 LiteLLM à la rescousse

**[LiteLLM](https://github.com/BerriAI/litellm)** te donne une **API unique façon OpenAI** pour accéder à **plus de 100 modèles différents**.

Et quand tu combines LiteLLM avec une `LLMFactory`, tu obtiens un design propre, modulaire et **future-proof**.

#### **LiteLLM** en un clin d’œil

**LiteLLM** est une brique open-source (librairie Python + proxy server) qui :

* **Expose une API identique à OpenAI** (`completion`, `chat`, `embedding`, `image_generation`)
* **Supporte 100+ modèles** (OpenAI, Azure, Claude, Mistral, Groq, Bedrock, Cohere…)
* **Traduit automatiquement** ton payload “OpenAI-style” vers chaque provider
* **Uniformise les réponses** en JSON façon OpenAI
* **Gère** retry, circuit breaker, fallback (ex. : si OpenAI est down, bascule sur Mistral)
* **Intègre** la surveillance (OpenTelemetry, Langfuse, Langsmith) et la gestion des coûts
* **S’installe** en deux clics :

  * `pip install litellm`
  * ou en proxy : `litellm --proxy-server --default-model openai/gpt-4o --otel-endpoint ...`

> 🛑 Cette fois-ci, **on ne rentre pas dans le monitoring** avec Langfuse, Langsmith et autres — on garde ça pour une autre fois !

---

### À quoi ressemble une réponse LiteLLM ?

```python
from litellm import completion
import os

os.environ["OPENAI_API_KEY"] = "your-api-key"

response = completion(
  model="openai/gpt-4o",
  messages=[{ "content": "Hello, how do you feel today?", "role": "user" }],
)
```

```json
{
  "id": "chatcmpl-565d891b-a42e-4c39-8d14-82a1f5208885",
  "created": 1734366691,
  "model": "claude-3-sonnet-20240229",
  "object": "chat.completion",
  "choices": [
    {
      "index": 0,
      "finish_reason": "stop",
      "message": {
        "role": "assistant",
        "content": "Hello! As an AI language model, I don't have feelings, but I'm operating properly and ready to assist you..."
      }
    }
  ],
  "usage": {
    "prompt_tokens": 13,
    "completion_tokens": 43,
    "total_tokens": 56
  }
}
```

> 📝 **Note** : que tu appelles GPT-4 via OpenAI, Claude via AWS Bedrock ou Mistral en local, la structure reste **la même** :
>
> * `choices[0].message.content` → ta réponse
> * `usage` → les tokens consommés
> * `model` → le modèle utilisé

---

### Exemple de `LLMFactory` (OpenAI, Claude via AWS, etc.)

```python
from typing import Optional, Dict, Any
import litellm
import boto3

class BaseLLMClient:
    def __init__(self, api_key: Optional[str] = None, model_name: str = "", model_params: Optional[Dict[str, Any]] = None):
        self.api_key = api_key
        self.model_name = model_name
        self.model_params = model_params or {}

    def predict(self, query: str, system_prompt: Optional[str] = None) -> str:
        raise NotImplementedError

class OpenAIClient(BaseLLMClient):
    def predict(self, query: str, system_prompt: Optional[str] = None) -> str:
        messages = [{"role": "system", "content": system_prompt}] if system_prompt else []
        messages.append({"role": "user", "content": query})

        response = litellm.completion(
            model=self.model_name,
            messages=messages,
            api_key=self.api_key,
            **self.model_params
        )
        return response["choices"][0]["message"]["content"]

class ClaudeAWSClient(BaseLLMClient):
    def __init__(self, model_name="anthropic.claude-3-sonnet-20240229-v1:0", model_params: Optional[Dict[str, Any]] = None):
        super().__init__(model_name=model_name, model_params=model_params)
        session = boto3.Session()
        credentials = session.get_credentials()
        self.aws_region = "eu-west-1"
        self.aws_access_key = credentials.access_key
        self.aws_secret_key = credentials.secret_key

    def predict(self, query: str, system_prompt: Optional[str] = None) -> str:
        messages = [{"role": "system", "content": system_prompt}] if system_prompt else []
        messages.append({"role": "user", "content": query})

        response = litellm.completion(
            model=self.model_name,
            messages=messages,
            aws_region_name=self.aws_region,
            aws_secret_access_key=self.aws_secret_key,
            aws_access_key_id=self.aws_access_key,
            **self.model_params
        )
        return response["choices"][0]["message"]["content"]

class LLMFactory:
    def __init__(self, config: dict):
        self.config = config

    def get_client(self):
        provider = self.config.get("provider")
        model_name = self.config.get("model_name")
        params = self.config.get("model_params", {})

        if provider == "openai":
            return OpenAIClient(api_key=self.config["api_key"], model_name=model_name, model_params=params)
        elif provider == "aws_claude":
            return ClaudeAWSClient(model_name=model_name, model_params=params)
        else:
            raise ValueError(f"Provider {provider} non supporté.")
```

Et dans ton code principal :

```python
config = {
    "provider": "openai",
    "api_key": os.getenv("OPENAI_KEY"),
    "model_name": "gpt-4o",
    "model_params": {"temperature": 0.3}
}

llm_client = LLMFactory(config).get_client()
query = "Explique-moi le haki de l'observation."
system_prompt = "Tu es expert One Piece et tu ne réponds qu'à des questions sur One Piece. Sois jovial comme Luffy."
print(llm_client.predict(query, system_prompt))
```

---

### Conclusion

En 2025, tu ne codes plus ton app autour d’un seul SDK. Tu construis ton backend comme une vraie plateforme :

+ **Indépendante du fournisseur LLM**
+ **Facile à faire évoluer (changer de modèle, ajouter un fallback, etc.)**
+ **Modulaire et testable**

Et la `LLMFactory` ou les `ADAPTERS`, c’est ta clef pour y arriver — surtout si tu t’appuies sur une brique comme **LiteLLM** qui fait le sale boulot d’unifier les appels.


 Je t’invite à lire la [📚 documentation officielle de LiteLLM](https://github.com/BerriAI/litellm) pour :

* déployer ton propre serveur LiteLLM (proxy),
* gérer tes coûts,
* monitorer les appels,
* et centraliser l’usage de tes clés API en toute sécurité.
