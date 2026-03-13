---
date: 2025-12-15
authors:
    - ssawadogo
categories: 
    - RAG
    - Data-Engineering
    - Python
---

# Du PDF au Markdown : mon pipeline pour une ingestion RAG de qualité

On dit souvent que la qualité d'un système RAG dépend de son modèle d'embedding ou de son LLM. Mais mon expérience m'a montré qu'en réalité, la bataille se gagne bien plus tôt : au moment du parsing des documents. Un agent IA ne peut pas naviguer intelligemment dans un document s'il reçoit un bloc de texte brut sans structure.

Aujourd'hui, je partage avec vous mon approche pour transformer des PDF complexes en **Markdown structuré**, le langage universel des LLMs.

<!-- more -->

## Pourquoi le Markdown est le format roi pour le RAG

Le texte brut issu d'un PDF est souvent pollué par des headers, des footers, des numéros de page ou des sauts de ligne intempestifs. En convertissant vers le Markdown, on conserve :
1. **La Hiérarchie** : Les titres (`#`, `##`, `###`) permettent de segmenter logiquement le document.
2. **Les Tableaux** : Un tableau Markdown est infiniment plus lisible pour un LLM qu'une suite de mots désordonnés.
3. **Le Contexte** : En chunkant par header plutôt que par nombre de caractères, on s'assure que chaque morceau de texte garde son unité sémantique.

## Mon duo d'outils : PyMuPDF et Docling

Pour construire ce pipeline, j'utilise deux bibliothèques complémentaires :

### 1. PyMuPDF (fitz) : La rapidité brute
J'utilise **PyMuPDF** pour les opérations rapides : extraire le texte par page, identifier les métadonnées de base ou supprimer les zones de "bruit" connues (comme les bas de page répétitifs).

### 2. Docling : L'intelligence structurelle
Pour les documents vraiment complexes (plusieurs colonnes, tableaux imbriqués), j'ai intégré **Docling** (développé par IBM). Sa capacité à comprendre la mise en page et à exporter un Markdown "propre" est impressionnante. Il gère l'OCR si nécessaire et reconstruit les structures de tables avec une grande fidélité.

![Pipeline d'Ingestion](pdf_to_markdown/ingestion_pipeline.png)

## Comment je gère les Headers et le Chunking

Plutôt que de faire un chunking aveugle (ex: tous les 1000 caractères), mon pipeline suit la structure du Markdown :

```python
from docling.document_converter import DocumentConverter

def process_pdf_to_md(source):
    converter = DocumentConverter()
    result = converter.convert(source)
    markdown_output = result.document.export_to_markdown()
    
    # Stratégie de chunking intelligente :
    # On découpe le document à chaque changement de titre (Header)
    chunks = split_by_headers(markdown_output)
    return chunks
```

En faisant cela, si un agent cherche des informations sur la "Gestion des Risques", il recevra le bloc de texte complet situé sous ce header, et non un morceau tronqué au milieu d'une phrase.

## Conclusion

L'ingestion n'est pas une simple formalité technique ; c'est la fondation de votre intelligence artificielle. En passant du PDF au Markdown de manière structurée, vous donnez à vos agents une "vision" claire du document.

C'est mon retour d'expérience sur la partie amont du RAG. Dans le [prochain article](https://sawallesalfo.github.io/blog/2025/12/30/le-rag-ne-se-limite-pas-aux-embeddings--limportance-de-la-recherche-hybride/), nous verrons comment exploiter cette structure pour faire de la recherche hybride performante.
