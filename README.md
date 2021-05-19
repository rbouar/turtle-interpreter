# Projet interpréteur pour la création d'images
## Mise en route
### Dépendances
- Nous utilisons la librairie
  [Graphics](https://ocaml.github.io/graphics/graphics/Graphics/index.html) pour
  toute la partie affichage.
- dune >= 2.7
- menhir >= 2.1


### Compilation
Taper `make` pour lancer la compilation.

### Utilisation
Il faut ensuite lancer `src/main.exe` et passer via l'entrée standard son programme.

Par exemple `src/main.exe < test/TestTantQue`

Pour fermer la fenêtre après le dessin appuyez sur une touche du clavier.

## Parties réalisées
Voici la hiérarchie de notre projet :
- Analyseur syntaxique `src/lexer.mll`
- Analyser grammaticale `src/parser.mly`
- Arbre de syntaxes abstraites `src/ast.ml`
- Interpréteur `src/interp.ml`
- `src/main.ml`

### Sujet minimal
#### Instructions
- Avance **expression**
- Tourne **expression**
- BasPinceau
- HautPinceau
- L'assignation : *identificateur* = **expression**
- Si **expression** Alors **instruction** Sinon **instruction**
- Tant que **expression** Faire **instruction**

#### Erreurs
Les erreurs suivantes sont gérées :
- Dépassement du canevas
- Division par 0
- Appel d'une variable non déclarée
- Lecture d'une variable sans valeur

#### Opérateurs
- `*` multiplication
- `+` addition
- `-` soustraction et moins unaire
- `/` division entière


### Extensions
#### Nouvelles instructions
- Si **expression** Alors **instruction**
- Pour **variable** = **expression** ; **expression** ; **expression**  Faire **instruction**
    - la variable doit être déclarée comme les autres variables du programme
    - au premier tour de boucle, on assigne à la variable la première expression
    - puis à chaque tours, la variable prends la valeur de la troisième expression
    - tant que la deuxième expression est vérifiée cad différente de 0
    - à la fin de la boucle, la variable garde sa dernière valeur assignée dans la boucle
- ChangeEpaisseur **expression**
    - Change l'épaisseur du trait
- ChangeCouleur *couleur* où *couleur* est :
    - noir
    - blanc
    - bleu
    - rouge
    - vert
    - jaune
    - cyan
    - magenta

#### Opérateurs booléens
- `&&` :  *A* && *B* : Si *A* différent de 0 et *B* différent de 0 alors *A* && *B* s'évalue en 1 sinon en 0
- `||` : *A* || *B* : Si *A* égal à 0 et *B* égal à 0 alors *A* || *B* s'évalue en 0 sinon en 1
- `==`, `!=`, `<`, `<=`, `>`, `>=` : ces opérateurs sont utilisés comme usuellement et renvoient 1 si la comparaison est vérifiée 0 sinon

#### Commentaires
On peut commenter son code grâce à :
- `//` pour un commentaire sur une ligne
- `(* ... *)` pour un commentaire sur plusieurs lignes

## Organisation
### Première étape
- Tortue et Interpréteur : Luka 
- Parser et Lexer : Romain 
- AST : Luka et Romain 
- Gestion des erreurs durant l'interprétation : Luka 

### Deuxième étape
- Si Alors Sinon : Romain 
- Tant que : Romain 

### Troisième étape
- Division, multiplication : Luka 
- Moins unaire : Luka 

### Quatrième étape : Extensions
- Pour Faire : Luka 
- Si Alors : Romain 
- ChangeEpaisseur : Luka 
- ChangeCouleur : Romain 
- Opérateurs booléens : Luka 
- Commentaires : Romain 
