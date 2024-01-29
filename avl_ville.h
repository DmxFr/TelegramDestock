#include <stdbool.h>
#include "model.h"
#ifndef AVLNom_h
#define AVLNom_h

typedef struct _AVLNom {
    Ville value;
    struct _AVLNom* left;
    struct _AVLNom* right;
    int balance;
} AVLNom;



AVLNom* createAVLNomVille(Ville value);

void printAVLNomInfixVille(AVLNom* avl);

int heightAVLNomVille(AVLNom* avl);

int getBalanceAVLNomVille(AVLNom* avl);

AVLNom* balanceAVLNomVille(AVLNom* avl);

AVLNom* insertAVLNomVille(AVLNom* avl, Ville value);

AVLNom* rotateLeftVille(AVLNom* avl);

AVLNom* rotateRightVille(AVLNom* avl);

AVLNom* rotateDoubleLeftVille(AVLNom* avl);

AVLNom* rotateDoubleRightVille(AVLNom* avl);

#endif