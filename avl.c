#include <stdlib.h>
#include "avl.h"
#include "util.h"

AVL* createAVL(int value) {
    AVL* avl = safeMalloc(sizeof(AVL));
    avl->value = value;
    avl->left = NULL;
    avl->right = NULL;
    avl->balance = 0;
    return avl;
}

void printAVLInfixRec(AVL* avl) {
    if(avl != NULL) {
        printAVLInfixRec(avl->left);
        printf("%d(%d) ", avl->value, avl->balance);
        printAVLInfixRec(avl->right);
    }
}

void printAVLInfix(AVL* avl) {
    printAVLInfixRec(avl);
    printf("\n");
}

int heightAVL(AVL* avl) {
    if(avl == NULL) return 0;
    else {
        int leftHeight = heightAVL(avl->left);
        int rightHeight = heightAVL(avl->right);
        return 1 + leftHeight > rightHeight ? leftHeight : rightHeight;
    }
}

AVL* balanceAVL(AVL* avl) {
    if(avl->balance >= -1 && avl->balance <= 1) return avl;
    else if(avl->balance == 2) return avl->right->balance == 1 ? rotateLeft(avl) : rotateDoubleLeft(avl);
    else return avl->left->balance == -1 ? rotateRight(avl) : rotateDoubleRight(avl);
}

AVL* insertAVLRec(AVL* avl, int value, int* h) {
    if(avl == NULL) { //Création d'un AVL -> équilibre +- 1
        *h = 1;
        return createAVL(value);
    } else if(value == avl->value) { //Noeud déjà présent
        *h = 0;
        return avl;
    } else {
        if(value < avl->value) { //Ajouter à gauche
            avl->left = insertAVLRec(avl->left, value, h);
            *h = -*h;
        } else { //Ajouter à droite
            avl->right = insertAVLRec(avl->right, value, h);
        }

        if(*h != 0) { //Si il y a eu ajout
            avl->balance += *h;
            avl = balanceAVL(avl);
            *h = avl->balance == 0 ? 0 : 1; //Valeur absolue pour éviter la double négation avec l'ajout à gauche
        }
        return avl;
    }
}

AVL* insertAVL(AVL* avl, int value) {
    int* h = safeMalloc(sizeof(int));
    *h = 0;
    return insertAVLRec(avl, value, h);
}

int max(int a, int b) {
    return a > b ? a : b;
}

int min(int a, int b) {
    return a <= b ? a : b;
}

AVL* rotateLeft(AVL* avl) { //Rotate the tree to the left
    AVL* root = avl->right;
    avl->right = root->left;
    root->left = avl;
    int eq_a = avl->balance;
    int eq_root = root->balance;
    avl->balance = eq_a - max(eq_root, 0) - 1;
    root->balance = min(eq_a-2, min(eq_a+eq_root-2, eq_root-1));
    return root;
}

AVL* rotateRight(AVL* avl) { //Rotate the tree to the right
    AVL* root = avl->left;
    avl->left = root->right;
    root->right = avl;
    int eq_a = avl->balance;
    int eq_root = root->balance;
    avl->balance = eq_a - min(eq_root, 0) + 1;
    root->balance = max(eq_a+2, max(eq_a+eq_root+2, eq_root+1));
    return root;
}

AVL* rotateDoubleLeft(AVL* avl) {
    avl->right = rotateRight(avl->right);
    return rotateLeft(avl);
}

AVL* rotateDoubleRight(AVL* avl) {
    avl->left = rotateLeft(avl->left);
    return rotateRight(avl);
}

