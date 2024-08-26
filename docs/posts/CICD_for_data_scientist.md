---
date: 2024-08-25
authors:
    - ssawadogo
categories: 
    - CI/CD
    - MlOps
---

### CI/CD pour les Data Scientists : Quand le Code Se Met à Danser

La collaboration entre data scientists et développeurs peut parfois ressembler à une partie de ping-pong chaotique : chacun fait rebondir des idées et des bouts de code, mais rien ne semble vraiment s'assembler correctement. Heureusement, il existe une solution pour rendre cette danse collaborative plus harmonieuse : la CI/CD (Continuous Integration/Continuous Deployment). Oui, même pour les data scientists ! Alors, prenez vos notebooks, ajustez vos lunettes, et découvrons comment transformer cette pagaille en une symphonie bien orchestrée :)

<!-- more -->


#### Qu'est-ce que la CI/CD ?

Avant de plonger dans les détails, clarifions ce que signifie CI/CD, surtout pour ceux qui, parmi nous, passent plus de temps à jongler des notebooks qu’à jongler avec des pipelines. Ou travaillent :
generalement en nombre reduits au près des metiers:

-  **Continuous Integration (CI)**: une pratique qui consiste à intégrer régulièrement les modifications du code dans un dépôt central, où elles sont automatiquement testées. Imaginez un petit robot qui vérifie si chaque ligne de code que vous ajoutez fonctionne bien avec le reste du code, comme un danseur de tango qui s'assure que chaque pas est en harmonie avec le rythme. L'idée est de détecter rapidement les erreurs afin qu'elles ne s'accumulent pas comme une pile de vaisselle sale (vous savez, celle qu’on promet de faire plus tard, mais qui finit par devenir un Everest inébranlable).

- **Continuous Deployment (CD)**: c' est comme la cerise sur le gâteau. Ici, chaque modification validée (après les tests de CI) est automatiquement déployée en production. Oui, vous avez bien entendu : plus besoin d'appuyer sur un bouton pour déployer, c'est comme si votre code se déployait tout seul, un peu comme une machine à café qui se prépare elle-même une nouvelle tasse de café dès que vous avez terminé la précédente. Le rêve, non ?

#### CI/CD pour les Data Scientists : Pourquoi ?
Pendant longtemps, la cicd etait propre aux developpeurs : Bonne pratique de developpement (devops). Avec le developpement de la data science et la volonté de maturer les projets data, on a donc commencer à entendre parler de MLOPS. Disons que la CICD est une composante pour faire du MlOps.

En tant que data scientist, vous pourriez vous demander : "Pourquoi devrais-je me préoccuper de tout ce bazar ? Mes notebooks fonctionnent très bien tels quels !" Certes, mais imaginez la scène : vous travaillez sur un modèle hyper complexe, vous l’entraînez pendant des heures (ou des jours), et puis… Oups, un autre membre de l'équipe modifie le code d'importation des données, et votre magnifique modèle ne fonctionne plus. Catastrophe.
Ou plus simplement, vous voudriez suivre l'historique d'un code. Le code marchait -il avant? Difficilement de repondre à ces questions à priori sans CICD

##### Les Enjeux de la Collaboration

La collaboration entre plusieurs data scientists (et développeurs) sur un même projet peut vite devenir compliquée. Chacun a son style, ses méthodes, et son code. Comme une recette de cuisine où chaque cuisinier ajoute ses propres ingrédients sans se concerter avec les autres, le résultat peut être… surprenant, pour ne pas dire immangeable. 

##### La Solution : CI/CD pour Data Scientists

Implémenter une chaîne CI/CD dans vos projets de data science permet d'assurer que :

1. **Tous les changements sont testés** : Vous évitez le fameux "ça marche sur ma machine !" en vous assurant que chaque modification est testée dans un environnement standardisé.

2. **Le code est toujours prêt pour la production** : Vous pouvez déployer vos modèles en production rapidement et en toute confiance, sans avoir à passer des jours à les vérifier manuellement.

3. **La documentation et le versionning sont automatiques** : Chaque modification est documentée, et vous pouvez facilement revenir en arrière en cas de problème (comme une machine à remonter le temps pour votre code).

4. Tout developpeur ou data scientist pourrait reprendre vos travaux sans perdre les cheveux.

C'est quoi git , gitlab ou github dans tout ça?
Je vous invite à faire un tour sur cet article au cas où vous n'etes pas tres familier avec des trois mots: [github vs gitlab vs git](/All_things_start_git.md)



#### Exemple de CI/CD pour un Projet Data Science

Dans ce guide, nous allons créer un pipeline CI/CD pour un projet de data science sur GitLab. Nous aborderons la structure du projet, la configuration du pipeline avec GitLab CI/CD, les tests, le déploiement d'une application Dash, et un bonus sur l'utilisation des “git hooks” pour tester localement avant de pousser les changements.
Avant tout parlons de 

##### Structure du Projet

Voici une structure typique pour un projet de data science utilisant GitLab CI/CD :

```
mon_projet_data_science/
│
├── .gitlab-ci.yml        # Fichier de configuration pour le pipeline CI/CD
├── requirements.txt      # Fichier listant les dépendances Python
├── README.md             # Documentation du projet
├── setup.py              # Script d'installation pour le projet
│
├── data/                 # Répertoire contenant les données
│   ├── raw/              # Données brutes non traitées
│   └── processed/        # Données pré-traitées
│
├── src/                  # Répertoire du code source principal
│   ├── __init__.py       # Fichier d'initialisation du package Python
│   ├── data_loader.py    # Script pour charger et traiter les données
│   ├── model.py          # Définition du modèle de machine learning
│   └── train_model.py    # Script pour l'entraînement du modèle
│
├── tests/                # Répertoire contenant les tests
│   ├── __init__.py       # Fichier d'initialisation du package de tests
│   ├── test_data_loader.py  # Tests pour le chargement des données
│   └── test_model.py     # Tests pour le modèle de machine learning
│
└── notebooks/            # Répertoire pour les notebooks Jupyter
    ├── exploration.ipynb # Notebook pour l'exploration des données
    └── analysis.ipynb    # Notebook pour l'analyse des résultats
```

##### exemple avec gitlab

Cela revient à configurer le fichier `.gitlab-ci.yml`
Voici un exemple de configuration pour le pipeline CI/CD :

```yaml
stages:
  - install
  - test
  - lint
  - train
  - deploy

variables:
  VENV_PATH: .venv

before_script:
  - python3 -m venv $VENV_PATH
  - source $VENV_PATH/bin/activate
  - pip install --upgrade pip
  - pip install -r requirements.txt

install:
  stage: install
  script:
    - pip install -r requirements.txt
  cache:
    paths:
      - $VENV_PATH

test:
  stage: test
  script:
    - pytest tests/

lint:
  stage: lint
  script:
    - flake8 .

train:
  stage: train
  script:
    - python src/train_model.py

deploy:
  stage: deploy
  script:
    - echo "Déploiement de l'application Dash sur le serveur de production..."
    - scp -r * user@server:/path/to/deployment
  only:
    - main
```

Explications des Étapes du Pipeline :

1. **Install Stage** : Installe les dépendances Python définies dans `requirements.txt`.
2. **Test Stage** : Exécute les tests unitaires avec `pytest` pour s'assurer que chaque composant fonctionne correctement.
3. **Lint Stage** : Utilise `flake8` pour vérifier la qualité du code et s'assurer qu'il respecte les bonnes pratiques de codage.
4. **Train Stage** : Lance l'entraînement du modèle de machine learning en exécutant le script `train_model.py`.
5. **Deploy Stage** : Déploie l'application Dash sur un serveur distant. Cette étape est déclenchée uniquement pour la branche `main`.

#### Utiliser des Git Hooks

Dans le cas où vous ne disposer pas de serveur distant pour lancer vos codes, vous pourriez utiliser  **git hooks** pour exécuter les tests locaux. Par exemple, un hook `pre-push` peut être utilisé pour exécuter les tests avant chaque `git push`.

1. **Créer un Hook `pre-push` :**

   Dans le répertoire `.git/hooks`, créez un fichier nommé `pre-push` :

   ```bash
   touch .git/hooks/pre-push
   ```
2. **Rendre le Hook Exécutable :**
3. **Ajouter le Script pour Exécuter les Tests :**

   Ouvrez le fichier `pre-push` et ajoutez le script suivant :

```bash  
#!/bin/bash

echo "Exécution des tests locaux avant le push..."
source .venv/bin/activate
pytest tests/

if [ $? -ne 0 ]; then
    echo "Échec des tests. Annulation du push."
    exit 1
fi

echo "Tests réussis. Push en cours..."
```
Avec ce hook en place, chaque tentative de git push exécutera les tests locaux. Si les tests échouent, le push sera annulé, garantissant ainsi que seul le code valide est poussé vers le dépôt distant.

#### Conclusion
En somme, intégrer la CI/CD dans vos projets de data science est comme apprendre à danser le tango avec vos collègues : c'est au début un peu maladroit, mais une fois que vous avez le rythme, vous ne pouvez plus vous en passer. Cela transforme votre façon de travailler, rend vos collaborations plus fluides, et garantit que vos modèles sont toujours au top de leur forme.

Alors, chers data scientists, prêts à chausser vos chaussures de danse et à adopter la CI/CD ? Parce qu’une fois que vous y aurez goûté, vous ne reviendrez jamais en arrière. Promis, juré.

References:
- https://martinfowler.com/articles/continuousIntegration.html

- https://martinfowler.com/books/duvall.html
