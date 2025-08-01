---
date: 2025-06-30
authors:
    - ssawadogo
categories: 
    - IAGen
---

# Agentic IA ne veut pas forcément dire Agent ReAct

## Introduction

Dans le monde de l'intelligence artificielle générative, le terme "agent" est de plus en plus utilisé, notamment avec l'émergence des architectures basées sur le protocole MCP. Pourtant, une question se pose : s'agit-il d'une réelle innovation ou simplement d'un rebranding de concepts déjà existants ?

Lors d'une discussion avec un collègue, on s’est vite rendu compte qu’on n’avait pas la même définition d’un agent. D’un côté, on pensait que les agents ne sont rien de plus qu’une nouvelle manière d’organiser des abstractions classiques. De l’autre, on défendait l’idée que les agents représentent une avancée réelle, un changement de paradigme dans la façon de concevoir des systèmes intelligents.

<!-- more -->

Voyons comment on peut creuser cette question, en s’appuyant notamment sur le point de vue de Hugging Face et quelques observations personnelles.

## Une histoire d'abstractions

Les développeurs n’ont pas attendu l’apparition du mot “agent” pour structurer des systèmes autour des LLMs (Large Language Models). Depuis plusieurs années, ils conçoivent des pipelines qui incluent :

- des appels à des modèles,
- des règles de contrôle,
- des modules d’interaction avec des APIs ou des bases de données.

Ces systèmes fonctionnaient déjà avec des logiques similaires à celles des agents, mais de manière plus rigide. Un développeur pouvait définir explicitement un ensemble de règles qui guidaient le comportement du système. Ces systèmes “ressemblaient” à des agents, sauf que les décisions étaient pré-programmées.

## L’évolution avec ReAct et les architectures agentiques

L’une des vraies avancées a été l’introduction du paradigme **ReAct (Reasoning + Acting)**, qui a changé notre manière de concevoir les agents. Plutôt que de suivre un chemin fixe, les agents modernes :

- raisonnent sur la situation actuelle,
- planifient les actions à prendre,
- interagissent dynamiquement avec leur environnement,
- s’adaptent aux nouvelles informations.

Cette souplesse est rendue possible grâce à l’usage de **tools** (outils), que l’agent peut appeler selon ses besoins.

## Classification des agents

On peut classer les agents selon leur degré d’autonomie. Voici un tableau pour résumer cette gradation :

| Niveau d'agence | Description                              | Nom              | Exemple                                            |
|-----------------|------------------------------------------|------------------|----------------------------------------------------|
| ☆☆☆             | LLM output n'affecte pas le programme    | Simple processor | `process_llm_output()`                             |
| ☆☆              | LLM output détermine le flot de contrôle | Router           | `if llm_decision(): path_a() else: path_b()`       |
| ☆☆              | LLM output déclenche des fonctions       | Tool call        | `run_function(llm_chosen_args)`                    |
| ☆☆☆             | LLM output gère une boucle d'exécution   | Multi-step agent | `while llm_should_continue(): execute_next_step()` |
| ☆☆☆             | Un agent déclenche un autre agent        | Multi-agent      | `if llm_trigger(): execute_agent()`                |

Ce tableau illustre bien les deux visions :

- Si on reste aux niveaux 1 et 2, on peut dire que les agents ne sont qu’un rebranding de vieux patterns.
- Mais dès qu’on arrive aux niveaux 3 et 4, on parle d’agents **autonomes**, capables de prises de décision complexes.

Et surtout, **faire des agents ne veut pas forcément dire faire du ReAct**. En réalité, la majorité des systèmes d'agents en production(avis collectés sur la base de discussions lors du Google submit tenu à Paris le 22 Mai 2025 avec des data scientists) aujourd’hui sont plutôt de type *Router*.

Et pour cause : les agents de type ReAct sont **plus complexes à monitorer**, **plus chers à exécuter**, et beaucoup plus difficiles à intégrer dans des boucles avec des humains (Human-in-the-loop).

## Comprendre concrètement le fonctionnement d’un agent ReAct

Pour bien comprendre comment fonctionne un **agent ReAct**, on peut s’appuyer sur le guide visuel proposé par [Hugging Face Smol Agents](https://huggingface.co/docs/smolagents/conceptual_guides/react). Ces agents utilisent une boucle **Raisonnement ↔ Action**, dans laquelle le LLM ne produit pas une réponse directe, mais une suite d’actions motivées par des raisonnements intermédiaires.

Voici le **GIF explicatif** tiré de la documentation officielle de Hugginface:

![ReAct Agent Loop](https://huggingface.co/datasets/huggingface/documentation-images/resolve/main/transformers/Agent_ManimCE.gif)

Prenons un exemple :

> *"Quelle est la température actuelle à Ouagadougou ?"*

Un LLM seul ne peut pas répondre correctement à cette question, car :

- il n’a pas accès à la date du jour,
- il ne peut pas interroger une API météo en temps réel.

Un **agent ReAct**, lui, va raisonner comme suit :

1. **Observation initiale**  
   L’agent reçoit la question et constate qu’il lui manque deux informations : la **date actuelle** et la **température en temps réel**.

2. **Premier raisonnement**  
   *"Je dois connaître la date d’aujourd’hui pour interroger l’API météo."*

3. **Première action (outil)**  
   Appel de `get_today_date()` → réponse : `"13 juillet 2025"`

4. **Deuxième raisonnement**  
   *"Maintenant que j’ai la date, je peux appeler l’outil météo pour Ouagadougou."*

5. **Deuxième action (outil)**  
   Appel de `get_temperature(city="Ouagadougou", date="2025-07-13")` → réponse : `"Température actuelle : 32°C"`

6. **Raisonnement final et réponse**  
   *"La température actuelle à Ouagadougou est de 32°C."*  
   → L’agent renvoie cette réponse à l’utilisateur.

Ce qui est puissant ici, c’est que **chaque étape est motivée par une réflexion claire**, ce qui rend le comportement de l’agent transparent, traçable, et modulaire. Si demain l’API météo change, il suffit de remplacer l’outil, sans toucher à la logique globale.

## Conclusion

Alors, qui a raison ? En réalité, les deux camps ont un fond de vérité. Oui, les agents reprennent des concepts déjà connus, mais ils les élèvent à un niveau supérieur.

L’intérêt des agents modernes ne réside pas uniquement dans leur architecture, mais dans leur **capacité à planifier, raisonner, s’adapter**, et à choisir dynamiquement les bonnes actions. Et c’est cette intelligence d’orchestration qui donne du sens au mot **“agent”** aujourd’hui.

