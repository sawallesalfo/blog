---
date: 2026-02-10
authors:
    - ssawadogo
categories: 
    - RAG
    - Évaluation
    - Python
---

# Évaluer un système RAG (Partie 1) : le framework technique

La bataille du RAG se gagne sur deux fronts : la capacité à trouver l'information (**Retrieval**) et la capacité à l'utiliser sans inventer (**Génération**). Pour évaluer ces deux piliers, j'utilise un framework basé sur des métriques probabilistes et qualitatives.

Voici le détail des métriques que j'implémente pour auditer mes pipelines.

<!-- more -->

## 1. Métriques de Retrieval : avons-nous les bons documents ?

Le but ici est de mesurer si le moteur de recherche (Vector ou Hybride) a réussi à extraire les segments nécessaires à la réponse.

### Contextual Recall (Rappel)
Il mesure si tous les faits nécessaires pour répondre à la question sont présents dans le contexte récupéré.
$$Recall = \frac{|\text{Segments récupérés} \cap \text{Segments attendus}|}{|\text{Segments attendus}|}$$
*Un score bas indique qu'il faut améliorer votre chunking ou votre recherche `top_k`.*

### Contextual Precision (Précision)
Il vérifie si les segments les plus pertinents sont classés en haut de la liste des résultats. C'est crucial pour optimiser la fenêtre de contexte du LLM.
$$Precision = \frac{\sum_{k=1}^{n} P@k \times \text{rel}(k)}{\text{Nombre de segments pertinents}}$$

---

## 2. Métriques de Génération : le LLM est-il fiable ?

Une fois le contexte fourni, nous évaluons la qualité de la synthèse produite par le modèle.

### Faithfulness (Fidélité / Groundedness)
C'est la métrique la plus importante contre les hallucinations. Elle vérifie que chaque affirmation dans la réponse de l'IA peut être directement tracée vers une phrase du contexte.
$$Faithfulness = \frac{\text{Nombre d'affirmations étayées par le contexte}}{\text{Nombre total d'affirmations dans la réponse}}$$

### Answer Relevancy (Pertinence)
Elle mesure à quel point la réponse répond directement à la question posée, sans fioritures ni hors-sujet. On la calcule souvent via la similarité cosinus entre le vecteur de la question et celui de la réponse générée.

![Framework d'Évaluation](https://sawallesalfo.github.io/blog/docs/posts/rag_evaluation_framework/evaluation_layers.png)

## Pourquoi diviser ainsi ?

Cette séparation permet d'identifier immédiatement le maillon faible :
- Si le **Recall** est bas mais la **Faithfulness** est haute : Votre base de données est mal indexée, mais votre LLM est honnête.
- Si le **Recall** est haut mais la **Faithfulness** est basse : Votre moteur de recherche est excellent, mais votre LLM hallucine.

Dans la [Partie 2](https://sawallesalfo.github.io/blog/2026/02/15/evaluer-un-syst%C3%A8me-rag-partie-2--le-pilotage-en-production/), nous verrons comment agréger ces métriques techniques pour piloter la qualité en conditions réelles.
