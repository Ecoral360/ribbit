# Parlons listes réactives

Dans cet article, je tente d'inspecter le concept des listes réactives sous 
toutes ses coutures. Ainsi, j'espère de découvrir, idéalement, la meilleure 
manière de les implémenter. Le but ici est donc de présenter une grande variété 
d'approche, sans jugement, en pesant les pours et les contres de chacune.

## Pourquoi avons-nous besoin de listes réactives?

Je pense qu'il est important de commencer en répondant à cette question. 
En effet, si nous parvenons ici à la conclusion qu'elles ne sont pas utiles en 
pratique, le problème se résout par lui-même. Voilà pourquoi nous étudirons 
d'abord quelques cas pratiques pour se convaincre de leur utilité avant 
de continuer.

#### Cas pratique n°1: La fameuse Todo List

##### _Sans liste réactive_:
Voici une manière dont une **Todo List** pourrait être implémenter si nous 
n'utilisons pas les listes réactive.
Tout d'abord, on crée un composant représentant un élément de la **Todo List**.
```scheme
(define (TodoItem item-name)
 (let ((item-name (reactive item-name))
       (item-checked (reactive #f)))
    (<p> 
     (<input> '@type "checkbox" '@bind:checked item-checked)
     (<li> item-name)
    ))
 ))
```
Puis, à chaque fois que l'on ajoute un élément à la **todo list**, on injecte
cet élément dans le DOM.
```scheme
(define main
 (let ((item-value (reactive "")))
   (<div>
     (<ul> '@id "todo-list")
     (<input> '@bind:value item-value)
     (<button> 
       '@on:click (lambda () 
         (append-node 
            (element-by-id "todo-list")
            (TodoItem (item-value)))
         (item-value ""))

       "Click to add the item")
   )
 ))
```

Cette approche fonctionne parfaitement pour le moment, car nous ne faisons 
qu'afficher cette liste. Que ce passe-t-il lorsque nous voulons recueillir tous
_les éléments sélectionnés_ de la liste? Ou lorsque nous voulons _trier_ les éléments?
Ou lorsque nous voulons _rechercher un élément_ possédant un certain nom? parmis 
les tâches terminés? parmis les tâches pas terminés?

Dans tous ces cas, il faudrait traverser le DOM pour obtenir ces informations.
Il serait cependant infiniment plus pratique de pouvoir séparer les manipulations
de ma **Todo List** de sa représentation dans le DOM.

C'est à ce moment que les listes réactives entrent en jeu pour nous offrir,
hypothétiquement, le meilleur des deux mondes.

<br>

## Approche naïve: Une variable réactive contenant une liste

Dans cette approche, c'est la variable contenant la liste qui est réactive. Ce 
choix entraine plusieurs conséquences positives et négatives.

#### Avantages

1. Cette approche est plutôt simple à implémenter (d'où son nom), car elle 
s'appuie sur le même fonctionnement que le reste des variables réactives.

2. Le cas de base de cette approche est trivial et ne nécessite aucune considération
particulière dans l'implémentation.

3. Seules quelques fonctions doivent être réimplémentées afin de fonctionner 
de manière réactive. (ex: `rmap` refait un `map` à chaque fois que liste 
réactive change)



## Les fonctions ajoutées pour travailler avec les listes réactives

- #### `(rmap f reactive-list)`

    Fonctionnement actuel:

    1. Cette fonction crée une variable réactive interne dont la valeur est 
    le mapping (par `f`) de la valeur de la liste réactive. Elle retourne une 
    version _readonly_ de la variable réactive interne.
    2. Cette fonction se lie à la liste réactive et change la valeur de sa 
    variable interne en recalculant le mapping lorsque la liste réactive change. 
    3. Ainsi, tous ceux qui se sont liés au mapping sont mis à jour.
    
    <br>

    Améliorations possibles:

    1. Lorsque le mapping est recalculé, la fonction pourrait comparer la valeur
    de chaque index de la nouvelle liste à la valeur de l'ancienne liste
    à cet index et ne recalculer que si ces valeurs diffèrent.















    .

    .

    .

    .

    .








