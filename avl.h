#include <stdbool.h>
#ifndef avl_h
#define avl_h

typedef struct _AVL {
    int value;
    struct _AVL* left;
    struct _AVL* right;
    int balance;
} AVL;

AVL* createAVL(int value);

void printAVLInfix(AVL* avl);

int heightAVL(AVL* avl);

int getBalanceAVL(AVL* avl);

AVL* balanceAVL(AVL* avl);

AVL* insertAVL(AVL* avl, int value);

AVL* rotateLeft(AVL* avl);

AVL* rotateRight(AVL* avl);

AVL* rotateDoubleLeft(AVL* avl);

AVL* rotateDoubleRight(AVL* avl);

#endif