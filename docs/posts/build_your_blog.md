---
date: 2024-08-25
authors:
    - ssawadogo
categories: 
    - CI/CD
    - documentation
---
## Building and Deploying a Blog with MkDocs with CI

### Introduction

Welcome! In this guide, you’ll learn how to build and deploy a blog using MkDocs, a tool that makes it easy to create beautiful documentation. We’ll cover each step to help you get your blog online.

### What You Need

1. **GitHub Account**: You need a GitHub account to store and deploy your blog.
2. **Basic Knowledge**: Familiarity with GitHub, Docker, and some command line basics will be helpful.
<!-- more -->

### Step 1: Setting Up Your Blog

1. **Create a GitHub Repository**:
   - Visit [GitHub](https://github.com) and log in.
   - Click on **New** to create a repository.
   - Name your repository, for example, `my-blog`.
   - Choose **Public** or **Private** based on your preference.
   - Click **Create repository**.

2. **Install MkDocs Locally**:
   - Open your terminal or command line.
   - Install MkDocs with pip:
     ```bash
     pip install mkdocs
     ```

3. **Set Up Your Blog**:
   - Navigate to the folder where you want to create your blog.
   - Run:
     ```bash
     mkdocs new my-blog
     ```
   - This creates a folder named `my-blog` with the basic files for your blog.

4. **Customize Your Blog**:
   - Open the `mkdocs.yml` file in your blog's folder. This is where you set your blog’s name and theme.
   - Modify the `mkdocs.yml` file to look like this:

     ```yaml
     site_name: My Blog
     theme:
       name: material
     nav:
       - Home: index.md
     ```

   - Add content by editing `index.md` or creating new Markdown files in the `docs` folder.

### Step 2: Build and Deploy Using Docker

1. **Create a Docker Image**:
   - Write a Dockerfile to include MkDocs and necessary tools.
   - Here’s a basic Dockerfile:

     ```Dockerfile
     # Use Python 3.12 image
     FROM python:3.12-slim

     # Set the working directory
     WORKDIR /app

     # Install MkDocs and plugins
     RUN pip install mkdocs mkdocs-material ghp-import

     # Copy blog files into Docker image
     COPY . /app

     # Set command to build MkDocs
     CMD ["mkdocs", "build", "--verbose", "--site-dir", "site"]
     ```

   - Build the Docker image with:
     ```bash
     docker build -t my-blog-image .
     ```

2. **Deploy Your Blog**:
   - Create a GitHub Actions workflow file to automate deployment. Save the following as `.github/workflows/deploy.yml` in your repository:

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
       IMAGE_NAME: my-blog-image
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

### Final Steps

1. **Push Your Changes**:
   - Commit and push your changes to GitHub:
     ```bash
     git add .
     git commit -m "Set up MkDocs site"
     git push origin main
     ```

2. **Ensure Correct Permissions for Deployment**:
   - To avoid permission issues with GitHub Actions, ensure that the `GITHUB_TOKEN` has the necessary permissions.
   - **Check Repository Settings**:
     - Go to your repository on GitHub.
     - Navigate to **Settings** > **Actions** > **General**.
     - Under **Workflow permissions**, ensure **Read and write permissions** are selected.

3. **Verify Deployment**:
   - Go to your GitHub repository.
   - Navigate to **Settings** > **Pages**.
   - Ensure the source is set to the `gh-pages` branch.

   Your blog should now be live! Visit the URL provided in the GitHub Pages settings to see your site.

### Conclusion

Congratulations! You’ve built and deployed a blog using MkDocs and Docker. This guide aimed to simplify the process, so you can easily share your content online. Happy blogging!

For a complete example, check out my project: [GitHub Repository](https://github.com/sawadogosalif/blog).

---

This version of the guide simplifies the instructions and organizes the steps clearly to help you get started with building and deploying your blog.