# Comment est construit les assistants conversationnels? GPT3.5, Claude3, Mistral

**Salut à tous mes passionnés de l'IA et du machine learning !**  
Aujourd'hui, on plonge dans les coulisses des grands modèles de langage (LLM) comme GPT-3.5. Vous êtes-vous déjà demandé **comment ces modèles arrivent à répondre avec autant de fluidité ?** La réponse tient en trois étapes-clés :  

1. Le **pré-entraînement** sur des montagnes de données,  
2. Le **fine-tuning** pour spécialiser le modèle, et  
3. L’**apprentissage par renforcement avec feedback humain** (RLHF).  
Quand on parle de chatgpt, techniquement c'est le produit du dernier modèle openai apèrs avoir fait une serie d'entrainement.

Dans cet article, je retrace les principales étapes avec vous . Un petit billet de blog pour clore l'année 2024. On ne fera pas de MLOPS aujourdh'ui , promis :)

---

### 1. Pré-entraînement : construire son modèle de fondation

Imaginez qu'on veuille apprendre à un enfant à parler. Quelle est la première étape ? Exactement, on lui expose **énormément de mots et phrases** : conversations, livres, histoires. C’est exactement ce qu’on fait avec un LLM, mais à une échelle gigantesque.

**Comment ça marche ?**  
On nourrit le modèle avec un énorme corpus de données : sites web, livres, forums, articles scientifiques… Le modèle doit prédire **le mot suivant** dans une phrase. Par exemple : si je dis _"Les oiseaux volent dans le ciel…"_, à votre avis, quel sera le mot suivant ? Voilà, c’est ce que le modèle apprend à faire.

> **Exemple concret : Le dataset utilisé pour LLaMA**
>
> Voici un aperçu des données qui ont servi pour LLaMA (un modèle open-source) :

| **Source**        | **Proportion utilisée** | **Époques (Passages)** | **Taille** |
|-------------------|-------------------------|------------------------|------------|
| CommonCrawl       | 67 %                   | 1.10                   | 3,3 To     |
| C4                | 15 %                   | 1.06                   | 783 Go     |
| GitHub            | 4,5 %                  | 0.64                   | 328 Go     |
| Wikipedia         | 4,5 %                  | 2.45                   | 83 Go      |
| Livres            | 4,5 %                  | 2.23                   | 85 Go      |
| ArXiv             | 2,5 %                  | 1.06                   | 92 Go      |
| StackExchange     | 2 %                    | 1.03                   | 78 Go      |

Ces données brutes (non étiquetées) permettent au modèle d'apprendre **la grammaire, les relations entre les mots et le contexte**. Mais attention, cette étape n’est qu’une fondation. Construire les modèles de fondation n'est pas du ressort de pétites entrepises ou startup.  Néanmoins à partir de modèles de fondations OpenSource on peut créeer d'autre d'autre modèles de fondations comme ce qu'on actuellement autour LLama( le modèle open source par excelleence)
Les LLMS comme GPT-3 nécessitent d’énormes ressources de calcul. Par exemple, l’entraînement de GPT-3 a été estimé par des chercheurs comme **Tim Dettmers** et d’autres experts en IA :

- **Nombre de paramètres** : 175 milliards (*Source : OpenAI, *Language Models are Few-Shot Learners*).  
- **Corpus de données** : Environ 570 Go de texte filtré (*Source : OpenAI, même article*).  
- **Infrastructure** : Utilisation de clusters de GPU, notamment des **NVIDIA V100** (*Source : blog de Tim Dettmers*).  
- **Durée estimée** : Entre **10 000 et 50 000 heures GPU**, d’après des calculs indépendants de la communauté, bien que les données exactes ne soient pas publiées.

---

Cela permet de garantir une transparence totale, en citant explicitement les sources ou les auteurs d’estimations lorsque les données officielles manquent. 😊


Il faut gardant en tete que les modèles de fondations n sont pas des assistants, ils savent juste completer des phrases. D'autres couches sont ajoutées pour arriver aux agents conversationnelles. J'ai troué un arbre sur github qui illustre bien cela 
Il faut gardant en tete que les modèles de fondations n sont pas des assistants, ils savent juste completer des phrases. D'autres couches sont ajoutées pour arriver aux agents conversationnelles. J'ai troué un arbre sur github qui illustre bien cela 

![alt text](https://raw.githubusercontent.com/Mooler0410/LLMsPracticalGuide/main/imgs/tree.jpg)

source:  https://github.com/Mooler0410/LLMsPracticalGuide/


Vous verrez que la plus part des asistants conversiationnellem comme Bard, Chattgpt ouu Claude sont aux extremeits de l'arbres car ce sont des LLM mais pas de modèles de fondations.

La preuve que cene sont pas  des assistants est bien dans les examples apres

Le modèle de fondations  ne répond pas aux questions
- Il veut seulement compléter les documents Internet
- Répond souvent aux questions par d'autres questions

![image](./how_to_build_your_gpt/fondation_output.PNG)

---

### 2. Fine-Tuning : Spécialiser le Modèle

Ici, on fait un peu comme avec un apprenti : après lui avoir montré plein de concepts généraux, on l’entraîne pour des tâches spécifiques. Pour un modèle conversationnel, on lui montre des dialogues bien construits, où la question est claire et la réponse pertinente.

**Pourquoi c’est important ?**  
Un modèle brut sait parler, mais pas toujours de manière cohérente. Le fine-tuning lui apprend à répondre de façon précise dans un contexte spécifique. **Vous imaginez un modèle qui parle mooré sans confondre les tons ni les contextes ?** C’est ici que la magie opère.

> **Note pratique** : Vous pouvez utiliser des modèles open-source déjà pré-entraînés, comme LLaMA ou GPT-J, pour gagner du temps. Ajoutez vos propres données annotées pour un fine-tuning personnalisé.

---

### 3. RLHF : Le Dernier Coup de Pinceau

Voici l’étape la plus fascinante, mais aussi la plus complexe : le **Reinforcement Learning from Human Feedback*** (RLHF). Pourquoi cette étape ? Pour que le modèle ne soit pas seulement performant, mais qu’il soit aussi **aligné sur vos attentes**.  

En gros, ça marche comment ?

1. **On forme un modèle de récompense :** Les annotateurs humains évaluent les réponses du modèle. Par exemple, si le modèle répond à côté, ça vaut 0. Si c’est parfait, ça vaut 1.
2. **Le modèle s’améliore :** Il apprend à maximiser son score en générant des réponses qui plaisent.
3. **Résultat :** Vous obtenez un agent qui sait être poli, précis et surtout **utile**.

> **Question pour vous :** Si vous formiez un modèle pour une communauté locale, comment définiriez-vous les "bonnes réponses" ? Politesse ? Contexte culturel ?

---

### Petit Récap avec un Visuel

Voici un schéma tiré de la présentation d’Andrej Karpathy. Il résume bien les étapes :

![Pipeline GPT](./how_to_build_your_gpt/gpt_training_pipeline.PNG)

---

### Alors, prêts à passer à l'action ? 

Créer un assistant comme chatgopt conversationnel peut sembler complexe, mais en suivant ces trois étapes, on peut transformer un modèle de fondation en un assistant puissant. Et vous, qu'en pensez-vous des modèles de fondations open source et comment faites vous du RHLF,

Pour aller plus loin :  
- **Conférence d’Andrej Karpathy sur GPT** : [Regarder ici](https://www.youtube.com/watch?v=bZQun8Y4L2A).  
- **Blog de Hugging Face sur RLHF** : [Lire ici](https://huggingface.co/blog/rlhf).  
- **Ressources sur les LLM** : [Explorer ici](https://dsp-routine.ppd-datascience.analytics.safran/concepts/modeling/llms_101/#a-brief-history).

