---

date: 2024-11-04  
authors:  
- ssawadogo  
categories:  
- MLOps  

---
# Le Jour Où Git m’a Sauvé

On a tous une anecdote avec Git, non ? Celle où on se dit que ce petit outil, discret mais essentiel, nous a évité une catastrophe. Eh bien, laisse-moi te raconter la mienne.  

C’était une journée normale de boulot. Après avoir bossé sur un package sur de l'IAGen que je développais depuis un bon moment, j’ai fait mon commit du jour juste avant de plier bagage et de rentrer chez moi. Rien d’anormal jusque-là. Mais le lendemain matin, pris d’une envie soudaine de *nettoyage*, j’ai décidé de faire du tri dans mon workspace. Le zèle, c’est bien… jusqu’à ce que tu réalises que tu viens de **supprimer par mégarde tout le répertoire de ton package IAGen en développement**. Oui, tout.  
<!-- more -->

### Panique Matinale  
Mon premier réflexe : *"Oh non, tout est foutu !"*. Mais après une seconde (ou une dizaine de minutes) à regarder mon écran comme si un miracle allait se produire, j’ai réalisé une chose : **Git est mon ami**. C’est là que j’ai décidé d’utiliser les outils de Git pour remonter dans le temps et récupérer mon précieux travail.  

### Git Reflog à la Rescousse  
La première commande magique, c’est `git reflog`. Si tu ne la connais pas, dis-toi qu’elle enregistre tous les mouvements de ton `HEAD`, même ceux que tu ne vois pas dans l’historique habituel des commits.  

Voici comment ça marche :  

```bash
git reflog
```  

Cette commande m’a affiché une liste de tout ce que j’avais fait récemment sur la branche :  

```
6 (HEAD -> main) HEAD@{0}: reset: moving to HEAD~1
75914b7 HEAD@{1}: commit: :rocket: Test de reformulation/full_text_search
4212ce6 HEAD@{2}: commit: :see_no_evil: Ignorer pickle
...  
```  

Le commit que je cherchais s’appelait `:rocket: Test de reformulation/full_text_search`, et il était à `HEAD@{1}`. Sauvé, non ? Pas encore.  

### Restaurer le Commit  
Une fois que j’ai trouvé le commit, il fallait revenir à cet état. Voici les trois options que Git offre pour *reset* :  

1. Si tu veux garder les modifications en attente (staged) :  
   ```bash
   git reset --soft 75914b7
   ```  

2. Si tu veux garder les fichiers modifiés sans les préparer (unstaged) :  
   ```bash
   git reset 75914b7
   ```  

3. Si tu veux carrément tout écraser et revenir à cet état précis :  
   ```bash
   git reset --hard 75914b7
   ```  

Moi, dans ma panique, j’ai joué la carte de la sécurité avec `--soft`. On ne sait jamais !  

### Une Leçon Apprise  
Après avoir tout récupéré et vérifié que tout fonctionnait bien, j’ai poussé les changements avec un petit `git push --force`. C’était comme si rien ne s’était passé.  

Morale de l’histoire : **Git n’oublie jamais**. Même quand toi, tu fais des bêtises. Depuis ce jour, je fais toujours des commits réguliers et je vérifie deux fois avant de supprimer quoi que ce soit. Et toi, quelle est ta *success story* avec Git ?  


### Mes Conseils pour Éviter le Stress
1. **Commite souvent** : Plus il y a de checkpoints, mieux c’est.  
2. **Apprends à utiliser `git reflog` et `git reset`** : Ces outils te sauveront la mise un jour.  
3. **Fais une sauvegarde locale régulière** : Si Git ne te suffit pas, un petit script de sauvegarde ne fait jamais de mal.  

Git, c’est un peu comme un ami fidèle : il te couvre toujours, même quand tu fais n’importe quoi. 😉  