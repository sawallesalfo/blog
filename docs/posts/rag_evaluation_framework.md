---
date: 2026-02-10
authors:
    - ssawadogo
categories: 
    - RAG
    - Évaluation
    - MLOps
    - Python
---

# Évaluer un système RAG (Partie 1) : le framework technique

Construire un système RAG (Retrieval-Augmented Generation) est aujourd'hui à la portée de n'importe quel développeur. Mais construire un système RAG **fiable** est un défi d'une toute autre nature. Avant même de parler de mise en production, il faut savoir mesurer la qualité de ce que l'on construit "en laboratoire".

Dans ce premier volet, je partage avec vous la boîte à outils technique que j'utilise pour évaluer la mécanique interne d'un pipeline RAG.

<!-- more -->

## Pourquoi l'évaluation est-elle si complexe ?

Contrairement au Machine Learning classique où l'on dispose de métriques simples (Précision, Rappel), le RAG produit du texte libre. Un échec peut provenir de deux sources distinctes :
1.  **Le Retrieval** : Le système n'a pas trouvé les bons documents.
2.  **La Génération** : Le LLM a mal interprété les documents (hallucination).

## Le Framework en 4 Couches

Pour débugger efficacement, j'ai structuré mon pipeline d'évaluation en quatre couches :

![Framework d'Évaluation](https://sawallesalfo.github.io/blog/2026/02/10/evaluer-un-syst%C3%A8me-rag-partie-1--le-framework-technique/rag_evaluation_framework/evaluation_layers.png)

### Layer 1 : Observabilité brute
J'utilise des outils comme **Langfuse** pour suivre les métriques techniques :
-   **Latence** : Temps de réponse par étape.
-   **Coût** : Consommation de tokens.

### Layer 2 : Qualité Structurelle
Vérification via code Python simple (Heuristiques) :
$$Completeness = \frac{\sum SectionsPresentes}{\sum SectionsRequises}$$

### Layer 3 : Qualité du Contenu (LLM-as-a-Judge)
Le LLM évalue des critères comme la cohérence ou le ton via une moyenne pondérée :
$$FinalScore = \frac{\sum (Score_i \times Weight_i)}{\sum Weight_i}$$

### Layer 4 : Précision Factuelle
Comparaison avec un document de référence (*Ground Truth*) :
$$FactualAccuracy = \frac{N_{correct} + N_{plausible}}{N_{total\_facts}}$$

## Conclusion de la Partie 1

Ce framework "Offline" permet de comparer deux versions d'un prompt ou d'un modèle d'embedding avec rigueur. Mais une fois que le système est entre les mains des utilisateurs, les problématiques changent.

Dans la [Partie 2](https://sawallesalfo.github.io/blog/2026/02/15/evaluer-un-syst%C3%A8me-rag-partie-2--le-pilotage-en-production/), nous verrons comment transformer ces outils techniques en un véritable tableau de bord de pilotage pour l'entreprise.
