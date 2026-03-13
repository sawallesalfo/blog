---
date: 2026-02-15
authors:
    - ssawadogo
categories: 
    - RAG
    - Évaluation
    - Business
---

# Évaluer un système RAG (Partie 2) : le pilotage en production

Dans la [Partie 1](https://sawallesalfo.github.io/blog/2026/02/10/evaluer-un-syst%C3%A8me-rag-partie-1--le-framework-technique/), nous avons exploré les métriques de base. En production, le défi change : nous devons transformer ces calculs mathématiques en indicateurs de pilotage (**Business KPIs**) pour garantir la sécurité et la valeur du service.

Voici comment j'organise le monitoring de la qualité pour mes utilisateurs finaux.

<!-- more -->

## Du Technique au Business : Les KPIs de confiance

Pour un décideur, un score de 0.85 en "Faithfulness" ne veut rien dire. Je traduis donc mes métriques techniques en indicateurs métier clairs :

1. **Accuracy Rate** : Le pourcentage de réponses validées comme exactes par un juge (Humain ou IA forte).
2. **Hallucination Rate** : La fréquence d'échec critique (quand Faithfulness < 0.5). C'est notre indicateur de sécurité.
3. **Knowledge Gap** : Le taux de "Je ne sais pas". Un score élevé ici indique que notre base de documents est incomplète pour les besoins réels des utilisateurs.

![Pilotage RAG](https://sawallesalfo.github.io/blog/docs/posts/rag_production_evaluation/rag_eval_mindmap.png)

## Le Système "Feu Tricolore"

Pour rendre l'analyse actionnable immédiatement, je convertis chaque résultat en un statut visuel simple :
-   🟢 **PASS (Score > 0.8)** : Précis et sourcé. Prêt pour l'utilisateur.
-   🟡 **REVIEW (Score 0.5 - 0.8)** : La réponse est correcte mais le style ou la précision des sources peut être amélioré.
-   🔴 **FAIL (Score < 0.5)** : Erreur factuelle ou hors-sujet. Nécessite une intervention immédiate sur le pipeline.

## L'importance de la trace

Le pilotage ne s'arrête pas à un instant T. Il est crucial de conserver l'historique des évaluations pour détecter le "Drift" (dérive) de qualité. Si le **Contextual Recall** chute soudainement après l'ajout d'un nouveau volume de documents, cela signifie que votre index vectoriel commence à souffrir du bruit.

## Conclusion de la série

L'évaluation est le système nerveux de tout projet d'IA générative. En combinant un framework technique rigoureux (Partie 1) et un pilotage métier (Partie 2), vous transformez une IA expérimentale en un service de production robuste et auditable.

J'espère que ce partage d'expérience vous aidera à bâtir des systèmes qui apportent une réelle valeur ajoutée à vos métiers.
