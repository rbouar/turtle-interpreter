# Projet interpréteur pour la création d'images
## Mis en route
### Dépendances
- Nous utilisons la librairie
  [Graphics](https://ocaml.github.io/graphics/graphics/Graphics/index.html) pour
  toute la partie affichage.
- dune >= 2.7
- menhir >= 2.1


### Compilation
Taper `make` pour lancer la compilation.

### Utilisation
Il faut ensuite lancer `src/main.exe` et passer via l'entrée standard son 
programme.

Par exemple `src/main.exe < test/TestTantQue`

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
- ChangeEpaisseur **expression**
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
- `&&` :  *A* && *B* : Si *A* et *B* sont différents de 0 alors *A* && *B* s'évalue en 1 sinon en 0
- `||`
- `==`, `!=`, `<`, `<=`, `>`, `>=`

#### Commentaires
On peut commenter son code grâce à :
- `//` pour un commentaire sur une ligne
- `(* ... *)` pour un commentaire sur plusieurs lignes
