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

La bataille du RAG se gagne sur deux fronts : la capacité à trouver l'information (**Retrieval**) et la capacité à l'utiliser sans inventer (**Génération**). Pour illustrer ce framework, prenons un exemple concret sur l'histoire du **Burkina Faso**.

<!-- more -->

## 1. Métriques de Retrieval : avons-nous les bons documents ?

### Contextual Recall (Rappel)
Le Rappel vérifie si nous avons trouvé tous les ingrédients nécessaires pour répondre.

**Exemple :**
*   **Question** : "Quels sont les faits marquants de l'indépendance du pays ?"
*   **Faits attendus (Ground Truth)** : 
    1. Proclamation de la République (11 déc 1958).
    2. Indépendance totale (5 août 1960).
    3. Maurice Yaméogo premier président.
*   **Contexte récupéré par l'IA** : Un document mentionnant le 5 août 1960 et Maurice Yaméogo, mais **aucun** document sur 1958.

**Calcul étape par étape :**
1. Nombre de faits attendus = 3
2. Nombre de faits trouvés dans le contexte = 2
3. Ratio : 

$$Recall = \frac{2}{3} = 0.66$$

---

### Contextual Precision (Précision)
La Précision vérifie si les informations utiles arrivent en tête de liste.

**Exemple :**
Si notre moteur de recherche renvoie 5 documents :
*   Rang 1 : Un texte sur la culture du coton (Non pertinent).
*   Rang 2 : Un texte sur Maurice Yaméogo et 1960 (Pertinent !).
*   Rang 3 : Un texte sur le climat (Non pertinent).

Ici, la précision est faible car l'information utile est noyée après un document hors-sujet.

$$Precision = \frac{\sum_{k=1}^{n} P@k \times \text{rel}(k)}{\text{Nombre de segments pertinents}}$$

---

## 2. Métriques de Génération : le LLM est-il fiable ?

### Faithfulness (Fidélité / Groundedness)
C'est le rempart contre l'hallucination. L'IA doit répondre **uniquement** avec ce qu'on lui a donné.

**Exemple :**
*   **Contexte fourni** : "Le Burkina Faso a obtenu son indépendance le 5 août 1960."
*   **Réponse de l'IA** : "L'indépendance a eu lieu le 5 août 1960 sous la direction de Thomas Sankara."

**Calcul étape par étape :**
1. Affirmation 1 : "Indépendance le 5 août 1960" -> Présente dans le contexte (VRAI).
2. Affirmation 2 : "Sous la direction de Thomas Sankara" -> **Absente** du contexte (Thomas Sankara est arrivé au pouvoir en 1983) (FAUX).
3. Score de fidélité : 

$$Faithfulness = \frac{1}{2} = 0.50$$

---

### Answer Relevancy (Pertinence)
L'IA a-t-elle vraiment répondu à la question ?

**Exemple :**
*   **Question** : "Qui était le premier président du Burkina Faso ?"
*   **Réponse de l'IA** : "Le Burkina Faso est un pays enclavé d'Afrique de l'Ouest dont la capitale est Ouagadougou."

La réponse est vraie (Fidèle), mais elle ne répond pas à la question. La similarité cosinus entre la question et la réponse sera très basse.

---

## Pourquoi diviser ainsi ?

Cette séparation permet d'identifier le coupable en cas d'erreur :

*   **Recall bas** (ex: On ne trouve pas 1958) : Le problème vient de votre **Indexation** (Data Engineering).
*   **Faithfulness basse** (ex: On cite Sankara en 1960) : Le problème vient de votre **Prompt** ou du **Modèle** (Génération).

![Framework d'Évaluation](https://sawallesalfo.github.io/blog/posts/rag_evaluation_framework/evaluation_layers.png)

Dans la [Partie 2](https://sawallesalfo.github.io/blog/2026/02/15/evaluer-un-syst%C3%A8me-rag-partie-2--le-pilotage-en-production/), nous verrons comment piloter ces scores en production.
