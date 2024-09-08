---
date : 2024-08-18  
auteurs : 
  - ssawadogo  
catégories : 
  - CI/CD
  - documentation
---

# Faire son Blog avec MkDocs et github actions

Bienvenue ! Dans ce guide, tu apprendras à créer et déployer un blog en utilisant MkDocs, un outil qui facilite la création de belles documentations. Nous allons couvrir chaque étape pour t'aider à mettre ton blog en ligne.

#### Ce Dont Tu As Besoin

1. **Compte GitHub** : Tu auras besoin d’un compte GitHub pour stocker et déployer ton blog.
2. **Connaissances de Base** : Une familiarité avec GitHub, Docker et quelques bases de la ligne de commande sera utile.
<!-- more -->

#### Étape 1 : Configuration de Ton Blog

1. **Créer un Répertoire GitHub** :
   - Va sur [GitHub](https://github.com) et connecte-toi.
   - Clique sur **New** pour créer un nouveau répertoire.
   - Nomme ton répertoire, par exemple `mon-blog`.
   - Choisis **Public** ou **Private** selon ta préférence.
   - Clique sur **Create repository**.

2. **Installer MkDocs Localement** :
   - Ouvre ton terminal ou la ligne de commande.
   - Installe MkDocs avec pip :
     ```bash
     pip install mkdocs
     ```

3. **Configurer Ton Blog** :
   - Navigue jusqu’au dossier où tu souhaites créer ton blog.
   - Exécute :
     ```bash
     mkdocs new mon-blog
     ```
   - Cela crée un dossier nommé `mon-blog` avec les fichiers de base pour ton blog.

4. **Personnaliser Ton Blog** :
   - Ouvre le fichier `mkdocs.yml` dans le dossier de ton blog. C’est ici que tu définis le nom et le thème de ton blog.
   - Modifie le fichier `mkdocs.yml` pour qu’il ressemble à ceci :

     ```yaml
     site_name: Mon Blog
     theme:
       name: material
     nav:
       - Accueil: index.md
     ```

   - Ajoute du contenu en modifiant `index.md` ou en créant de nouveaux fichiers Markdown dans le dossier `docs`.

#### Étape 2 : Construire et Déployer avec Docker

1. **Créer une Image Docker** :
   - Rédige un Dockerfile pour inclure MkDocs et les outils nécessaires.
   - Voici un Dockerfile de base :

     ```Dockerfile
     # Utiliser l'image Python 3.12
     FROM python:3.12-slim

     # Définir le répertoire de travail
     WORKDIR /app

     # Installer MkDocs et les plugins
     RUN pip install mkdocs mkdocs-material ghp-import

     # Copier les fichiers du blog dans l'image Docker
     COPY . /app

     # Définir la commande pour construire MkDocs
     CMD ["mkdocs", "build", "--verbose", "--site-dir", "site"]
     ```

   - Construis l'image Docker avec :
     ```bash
     docker build -t mon-blog-image .
     ```

2. **Déployer Ton Blog** :
   - Crée un fichier workflow GitHub Actions pour automatiser le déploiement. Sauvegarde le fichier suivant sous `.github/workflows/deploy.yml` dans ton répertoire :

     ```yaml
     name: Build and Deploy MkDocs Site

     on:
       push:
         branches:
           - main
       pull_request:
         branches:
           - main
       workflow_dispatch:

     env:
       IMAGE_NAME: mon-blog-image
       IMAGE_TAG: latest

     jobs:
       build-and-deploy:
         runs-on: ubuntu-latest

         steps:
           - name: Checkout code
             uses: actions/checkout@v3

           - name: Build MkDocs site
             run: |
               docker run --rm -v ${{ github.workspace }}:/app -w /app ${{ env.IMAGE_NAME }}:${{ env.IMAGE_TAG }} mkdocs build --verbose --site-dir site

           - name: Deploy to GitHub Pages
             if: github.ref == 'refs/heads/main'
             run: |
               docker run --rm -v ${{ github.workspace }}:/app -w /app ${{ env.IMAGE_NAME }}:${{ env.IMAGE_TAG }} /bin/bash -c "
                 ghp-import -n -p -f site -r https://x-access-token:${{ secrets.GITHUB_TOKEN }}@github.com/${{ github.repository }}.git -b gh-pages"
           
           - name: Clean up Docker resources
             run: docker system prune -f
     ```

#### Étapes Finales

1. **Pousser Tes Modifications** :
   - Commit et pousse tes modifications vers GitHub :
     ```bash
     git add .
     git commit -m "Configuration du site MkDocs"
     git push origin main
     ```

2. **Assurer les Permissions Correctes pour le Déploiement** :
   - Pour éviter les problèmes de permission avec GitHub Actions, assure-toi que le `GITHUB_TOKEN` dispose des permissions nécessaires.
   - **Vérifie les Paramètres du Répertoire** :
     - Va sur ton répertoire GitHub.
     - Navigue vers **Settings** > **Actions** > **General**.
     - Sous **Workflow permissions**, assure-toi que **Read and write permissions** sont sélectionnées.

3. **Vérifier le Déploiement** :
   - Va sur ton répertoire GitHub.
   - Navigue vers **Settings** > **Pages**.
   - Assure-toi que la source est définie sur la branche `gh-pages`.

   Ton blog devrait maintenant être en ligne ! Visite l’URL fournie dans les paramètres de GitHub Pages pour voir ton site.

#### Conclusion

Félicitations ! Tu as construit et déployé un blog en utilisant MkDocs et Docker. Ce guide vise à simplifier le processus pour que tu puisses facilement partager ton contenu en ligne. Bon blogging !

Pour un exemple complet, jette un œil à mon projet : [Répertoire GitHub](https://github.com/sawadogosalif/blog).

#### MAJ
+ 08/09/2024 : Traduire en français