#include <stdio.h>
#include <stdlib.h>
#include "model.h"

int main() {
    FILE* fichier = fopen("data.csv", "r");

    if (fichier == NULL) {
        perror("Erreur d'ouverture du fichier");
        return EXIT_FAILURE;
    }

    AVLTrajet* avl = createAVLTrajet(NULL); // Créer un AVL vide

    avl = liretoutelesEtape(fichier, avl);

    // Utilisez l'AVL comme nécessaire

    // Affichage de l'AVL (juste un exemple)
    printAVLInfixTrajet(avl);

    // Libération de la mémoire
    // ...

    return EXIT_SUCCESS;
}


