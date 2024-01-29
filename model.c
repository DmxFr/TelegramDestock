#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "model.h"
#include "avl_trajet.h"

Comparaison compareTrajet(Ville a, Ville b) {
    if(a.trajets_total > b.trajets_total) return PLUS_GRAND;
    else if(a.trajets_total < b.trajets_total) return PLUS_PETIT;
    else return EGAL;
}

Comparaison compareNomVille(Ville a, Ville b) {
    int result = strcmp(a.nom_ville, b.nom_ville);
    if(result > 0) return PLUS_GRAND;
    else if(result < 0) return PLUS_PETIT;
    else return EGAL;
}

void printVille(Ville ville) {
    printf("%s", ville.nom_ville);
}

Etape lireLigneEtape(FILE *fichier){
    Etape etape;
    //Eventuellement initialiser les pointeurs
    fscanf(fichier, "%d;%d;%49[^;]s;%49[^;]s;%f;%49[^;]s", &etape.route_id, &etape.step_id, etape.town_a, etape.town_b, &etape.distance, etape.driver_name);
    return etape;
}

// Etape liretoutelesEtape(FILE *fichier, AVLTrajet *avl)//


AVLTrajet* insertAVLTrajetFromFile(AVLTrajet* avl, FILE* fichier) {
    Etape etape;
    while (fscanf(fichier, "%d;%d;%49[^;]s;%49[^;]s;%f;%49[^;]s",
                  &etape.route_id, &etape.step_id, etape.town_a, etape.town_b,
                  &etape.distance, etape.driver_name) == 6) {

        Ville ville = createVilleFromEtape(etape); // Assumez que vous avez une fonction pour créer une Ville à partir d'une Etape
        avl = insertAVLTrajet(avl, ville);
    }

    return avl;
}


AVLTrajet* liretoutelesEtape(FILE* fichier, AVLTrajet* avl) {
    if (fichier == NULL) {
        perror("Erreur d'ouverture du fichier");
        exit(EXIT_FAILURE);
    }

    avl = insertAVLTrajetFromFile(avl, fichier);

    fclose(fichier);
}



    

