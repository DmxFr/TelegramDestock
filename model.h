#include <stdio.h>
#ifndef TRAITEMENTS_H
#define TRAITEMENTS_H

typedef struct {
    int route_id;
    int step_id;
    char town_a[50];
    char town_b[50];
    double distance;
    char driver_name[50];
} Etape;

typedef struct Ville {
    char nom_ville[50];
    int trajets_total;
} Ville;

typedef enum {
  PLUS_GRAND,
  EGAL,
  PLUS_PETIT
} Comparaison;

Comparaison compareTrajet(Ville a, Ville b);

Comparaison compareNomVille(Ville a, Ville b);

void printVille(Ville ville);

Etape lireLigneEtape(FILE *fichier); 

Etape liretoutelesEtape(FILE *fichier, int nbEtape);

#endif