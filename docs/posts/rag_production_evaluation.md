---
date: 2026-03-25
authors:
    - ssawadogo
categories: 
    - RAG
    - Évaluation
    - MLOps
    - Business
---

# Évaluer un système RAG (Partie 2) : le pilotage en production

Dans la [Partie 1](https://sawallesalfo.github.io/blog/2026/03/15/evaluer-un-syst%C3%A8me-rag-partie-1--le-framework-technique/), nous avons exploré la "boîte à outils" technique pour débugger un pipeline RAG. Aujourd'hui, nous passons du laboratoire au terrain. Comment s'assurer que le système apporte réellement de la valeur aux utilisateurs finaux et reste sûr dans le temps ?

Le défi n'est plus seulement technique, il devient opérationnel. Voici comment je transforme des métriques brutes en un système de pilotage par les données.

<!-- more -->

## Du Technique au Business

L'évaluation en production ne s'adresse plus seulement aux développeurs, mais aussi aux décideurs (Stakeholders). Pour cela, je traduis les scores complexes en **Business KPIs** clairs :

-   **Accuracy Rate** : Est-ce que la réponse est correcte ?
-   **Hallucination Rate** : L'IA invente-t-elle des faits ?
-   **Knowledge Gap** : Avons-nous les documents nécessaires pour répondre ?

![Pilotage RAG](https://sawallesalfo.github.io/blog/2026/03/25/evaluer-un-syst%C3%A8me-rag-partie-2--le-pilotage-en-production/rag_production_evaluation/rag_eval_mindmap.png)

## Le Système "Feu Tricolore"

Pour rendre l'analyse actionnable immédiatement, je convertis chaque résultat en un statut visuel simple :
-   🟢 **PASS (Score > 0.8)** : Précis et sourcé.
-   🟡 **REVIEW (Score 0.5 - 0.8)** : Acceptable mais perfectible (besoin d'ajuster le prompt).
-   🔴 **FAIL (Score < 0.5)** : Erreur factuelle ou hors-sujet (besoin d'ajouter des données).

## Monitoring continu avec MLflow

Le pilotage ne s'arrête pas à un instant T. En traçant chaque exécution dans **MLflow**, je peux détecter le "Drift" (dérive) de qualité. Si le taux d'hallucination augmente soudainement après l'ajout d'une nouvelle source de données, je le vois immédiatement sur mes graphiques radar.

## Les métriques de génération

Pour les ingénieurs qui surveillent le système, deux formules restent essentielles en production :

**Faithfulness (Fidélité)** :
$$Faithfulness = \frac{\text{Nombre d'affirmations étayées par le contexte}}{\text{Nombre total d'affirmations dans la réponse}}$$

**Contextual Recall** :
$$Recall = \frac{|\text{Faits attendus} \cap \text{Faits présents dans le contexte}|}{|\text{Faits attendus}|}$$

## Conclusion de la série

L'évaluation est le système nerveux de tout projet d'IA générative. En combinant un framework technique rigoureux (Partie 1) et un pilotage métier par les données (Partie 2), vous transformez une IA expérimentale en un service de production robuste et auditable.

J'espère que ce partage d'expérience vous aidera à bâtir des systèmes qui apportent une réelle valeur ajoutée à vos métiers.
