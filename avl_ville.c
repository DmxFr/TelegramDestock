#include <stdlib.h>
#include "avl_ville.h"
#include "model.h"
#include "util.h"

AVLNom* createAVLVille(Ville value) {
    AVLNom* avl = safeMalloc(sizeof(AVLNom));
    avl->value = value;
    avl->left = NULL;
    avl->right = NULL;
    avl->balance = 0;
    return avl;
}

void printAVLInfixRecVille(AVLNom* avl) {
    if(avl != NULL) {
        printAVLInfixRecVille(avl->left);
        printVille(avl->value);
        printAVLInfixRecVille(avl->right);
    }
}

void printAVLInfixVille(AVLNom* avl) {
    printAVLInfixRecVille(avl);
    printf("\n");
}

int heightAVLVille(AVLNom* avl) {
    if(avl == NULL) return 0;
    else {
        int leftHeight = heightAVLVille(avl->left);
        int rightHeight = heightAVLVille(avl->right);
        return 1 + leftHeight > rightHeight ? leftHeight : rightHeight;
    }
}

AVLNom* balanceAVLVille(AVLNom* avl) {
    if(avl->balance >= -1 && avl->balance <= 1) return avl;
    else if(avl->balance == 2) return avl->right->balance == 1 ? rotateLeftVille(avl) : rotateDoubleLeftVille(avl);
    else return avl->left->balance == -1 ? rotateRightVille(avl) : rotateDoubleRightVille(avl);
}

AVLNom* insertAVLRecVille(AVLNom* avl, Ville value, int* h) {
    if(avl == NULL) { //Création d'un AVL -> équilibre +- 1
        *h = 1;
        return createAVLVille(value);
    } else if(compareNomVille(value, avl->value) == EGAL) { //Noeud déjà présent
        *h = 0;
        return avl;
    } else {
        if(compareNomVille(value, avl->value) == PLUS_PETIT) { //Ajouter à gauche
            avl->left = insertAVLRecVille(avl->left, value, h);
            *h = -*h;
        } else { //Ajouter à droite
            avl->right = insertAVLRecVille(avl->right, value, h);
        }

        if(*h != 0) { //Si il y a eu ajout
            avl->balance += *h;
            avl = balanceAVLVille(avl);
            *h = avl->balance == 0 ? 0 : 1; //Valeur absolue pour éviter la double négation avec l'ajout à gauche
        }
        return avl;
    }
}

AVLNom* insertAVLVille(AVLNom* avl, Ville value) {
    int* h = safeMalloc(sizeof(int));
    *h = 0;
    return insertAVLRecVille(avl, value, h);
}

int maxVille(int a, int b) {
    return a > b ? a : b;
}

int minVille(int a, int b) {
    return a <= b ? a : b;
}

AVLNom* rotateLeftVille(AVLNom* avl) { //Rotate the tree to the left
    AVLNom* root = avl->right;
    avl->right = root->left;
    root->left = avl;
    int eq_a = avl->balance;
    int eq_root = root->balance;
    avl->balance = eq_a - maxVille(eq_root, 0) - 1;
    root->balance = minVille(eq_a-2, minVille(eq_a+eq_root-2, eq_root-1));
    return root;
}

AVLNom* rotateRightVille(AVLNom* avl) { //Rotate the tree to the right
    AVLNom* root = avl->left;
    avl->left = root->right;
    root->right = avl;
    int eq_a = avl->balance;
    int eq_root = root->balance;
    avl->balance = eq_a - minVille(eq_root, 0) + 1;
    root->balance = maxVille(eq_a+2, maxVille(eq_a+eq_root+2, eq_root+1));
    return root;
}

AVLNom* rotateDoubleLeftVille(AVLNom* avl) {
    avl->right = rotateRightVille(avl->right);
    return rotateLeftVille(avl);
}

AVLNom* rotateDoubleRightVille(AVLNom* avl) {
    avl->left = rotateLeftVille(avl->left);
    return rotateRightVille(avl);
}

