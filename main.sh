#!/bin/bash

# Vérifier si l'argument -h est présent
if [ "$1" == "-h" ]; then
    echo "Usage: $0 <chemin_fichier_CSV> <choix_traitement>"
    echo "Options:"
    echo "  -h                 Afficher ce message d'aide"
    echo "  -d1                Effectuer le traitement d1"
    echo "  -d2                Effectuer le traitement d2"
    echo "  -l                 Effectuer le traitement l"
    echo "  -t                 Effectuer le traitement t"
    echo "  -s                 Effectuer le traitement s"
    exit 0
fi

# Vérifier si le fichier CSV est spécifié
if [ -z "$1" ]; then
    echo "Erreur: Veuillez spécifier le chemin du fichier CSV en tant que premier argument."
    exit 1
fi

# Vérifier la présence de l'exécutable C
if [ "$2" == "-t" ] || [ "$2" == "-s" ] && ! [ -e "main" ]; then
    echo "Compilation en cours..."
    make

    # Vérifier que la compilation s'est bien déroulée
    if [ $? -ne 0 ]; then
        echo "Erreur: La compilation a échoué."
        exit 1
    fi
fi

# Vérifier et créer les dossiers temp et images si nécessaire
if [ ! -d temp ]; then
    mkdir temp
else
    rm -vf temp/*
fi

if [ ! -d images ]; then
    mkdir images
else
    rm -vf images/*
fi

# Vérification du nombre d'arguments
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <chemin_fichier_CSV> <choix_traitement>"
    exit 1
fi

# Récupération des arguments
fichier_csv="$1"
choix_traitement="$2"

# Vérification de l'existence du fichier CSV
if [ ! -f "$fichier_csv" ]; then
    echo "Le fichier CSV spécifié n'existe pas."
    exit 1
fi


function traitement_d1()
{
    #Voici un script Shell qui réalise le traitement [D1] en utilisant uniquement des commandes Unix. Assurez-vous que le fichier d'entrée est correctement formaté avec les informations des trajets. Ce script suppose que chaque ligne du fichier d'entrée représente un trajet avec le nom du conducteur.

    # Extraction et comptage des trajets par conducteur
    trajets_par_conducteur=$(awk -F',' '{print $1}' "$fichier_csv" | sort | uniq -c | sort -nr)

    # Récupération des 10 premiers conducteurs avec le plus grand nombre de trajets
    top_10_conducteurs=$(echo "$trajets_par_conducteur" | head -n 10)

    # Création du fichier de données pour le graphique
    echo "$top_10_conducteurs" | awk '{print $2 " " $1}' > data.txt

    # Création du fichier de script pour GnuPlot
    echo "set term png" > script.gp
    echo "set output 'graphique_d1.png'" >> script.gp
    echo "set style fill solid" >> script.gp
    echo "set boxwidth 0.5" >> script.gp
    echo "set xlabel 'Nombre de trajets'" >> script.gp
    echo "set ylabel 'Conducteurs'" >> script.gp
    echo "set title 'Top 10 conducteurs avec le plus de trajets'" >> script.gp
    echo "set ytics rotate by -45" >> script.gp
    echo "plot 'data.txt' using 2:xtic(1) with boxes notitle" >> script.gp

    # Exécution de GnuPlot avec le fichier de script
    gnuplot script.gp

    # Nettoyage des fichiers temporaires
    rm data.txt script.gp

    echo "Le graphique a été généré avec succès."

    #Ce script utilise les commandes Unix telles que awk, sort, et uniq pour effectuer le traitement, puis génère un graphique avec GnuPlot. N'oubliez pas de rendre le script exécutable avec la commande chmod +x nom_du_script.sh et de l'appeler avec le chemin du fichier CSV en argument (./nom_du_script.sh chemin_fichier_CSV).

}


function traitement_d2()
{
    #Pour ce traitement, nous allons extraire les distances totales parcourues par chaque conducteur à partir du fichier CSV, puis nous sélectionnerons les 10 conducteurs avec les distances les plus grandes pour créer un histogramme horizontal.*/


    # Extraction et calcul des distances totales par conducteur
    distances_par_conducteur=$(awk -F',' '{total[$1]+=$3} END {for (i in total) print total[i], i}' "$fichier_csv" | sort -nr)

    # Récupération des 10 premiers conducteurs avec les distances les plus grandes
    top_10_conducteurs=$(echo "$distances_par_conducteur" | head -n 10)

    # Création du fichier de données pour le graphique
    echo "$top_10_conducteurs" | awk '{print $2 " " $1}' > data_d2.txt

    # Création du fichier de script pour GnuPlot
    echo "set term png" > script_d2.gp
    echo "set output 'graphique_d2.png'" >> script_d2.gp
    echo "set style fill solid" >> script_d2.gp
    echo "set boxwidth 0.5" >> script_d2.gp
    echo "set xlabel 'Distance totale parcourue'" >> script_d2.gp
    echo "set ylabel 'Conducteurs'" >> script_d2.gp
    echo "set title 'Top 10 conducteurs avec la plus grande distance totale parcourue'" >> script_d2.gp
    echo "set ytics rotate by -45" >> script_d2.gp
    echo "plot 'data_d2.txt' using 2:xtic(1) with boxes notitle" >> script_d2.gp

    # Exécution de GnuPlot avec le fichier de script
    gnuplot script_d2.gp

    # Nettoyage des fichiers temporaires
    rm data_d2.txt script_d2.gp

    echo "Le graphique D2 a été généré avec succès."

    # Ce script récupère les distances totales par conducteur à partir du fichier CSV, sélectionne les 10 conducteurs avec les distances les plus grandes, crée un fichier de données pour GnuPlot, génère le graphique horizontal, puis nettoie les fichiers temporaires. Assurez-vous d'adapter la colonne correspondant à la distance dans votre fichier CSV (ici, c'est la colonne 3 avec l'option -F',' '{total[$1]+=$3}).

}


function traitement_l()
{
    # Calcul des distances totales par trajet
    distances_par_trajet=$(awk -F',' '{total[$2]+=$3} END {for (i in total) print total[i], i}' "$fichier_csv" | sort -nr)

    # Récupération des 10 trajets avec les distances les plus grandes
    top_10_trajets=$(echo "$distances_par_trajet" | head -n 10)

    # Création du fichier de données pour le graphique
    echo "$top_10_trajets" | awk '{print $2 " " $1}' > data_l.txt

    # Création du fichier de script pour GnuPlot
    echo "set term png" > script_l.gp
    echo "set output 'graphique_l.png'" >> script_l.gp
    echo "set style fill solid" >> script_l.gp
    echo "set boxwidth 0.5" >> script_l.gp
    echo "set xlabel 'Identifiant du trajet'" >> script_l.gp
    echo "set ylabel 'Distance en km'" >> script_l.gp
    echo "set title 'Top 10 des trajets les plus longs'" >> script_l.gp
    echo "set xtics rotate by -45" >> script_l.gp
    echo "plot 'data_l.txt' using 2:xtic(1) with boxes notitle" >> script_l.gp

    # Exécution de GnuPlot avec le fichier de script
    gnuplot script_l.gp

    # Nettoyage des fichiers temporaires
    #rm data_l.txt script_l.gp

    echo "Le graphique L a été généré avec succès."


    #Ce script prend en compte un fichier CSV contenant les données des trajets routiers. Il calcule la distance totale pour chaque trajet, sélectionne les 10 trajets avec les distances les plus grandes, puis crée un graphique d'histogramme vertical montrant l'identifiant du trajet en abscisse et la distance en kilomètres en ordonnée.

}

function traitement_t()
{
    # UTILISER SSI LE CODE EN C NE FONCTIONNE PAS (VOIR SUITE)

    # le traitement des 10 villes les plus traversées, le script devra compter le nombre de trajets qui passent par chaque ville et le nombre de fois où ces villes sont des villes de départ de trajets.*/


    # Comptage des villes traversées et villes de départ
    villes_traversees=$(awk -F',' '{traversees[$4]++} {depart[$5]++} END {for (ville in traversees) print ville, traversees[ville], depart[ville]}' "$fichier_csv" | sort -k1,1)

    # Sélection des 10 villes avec le plus de trajets, par ordre alphabétique
    top_10_villes=$(echo "$villes_traversees" | sort -k2,2nr -k1,1 | head -n 10)

    # Création du fichier de données pour le graphique
    echo "$top_10_villes" | awk '{print $1 " " $2 " " $3}' > data_t.txt

    # Création du fichier de script pour GnuPlot
    echo "set term png" > script_t.gp
    echo "set output 'graphique_t.png'" >> script_t.gp
    echo "set style data histograms" >> script_t.gp
    echo "set style histogram cluster gap 1" >> script_t.gp
    echo "set style fill solid" >> script_t.gp
    echo "set boxwidth 0.5" >> script_t.gp
    echo "set xlabel 'Villes'" >> script_t.gp
    echo "set ylabel 'Nombre de trajets'" >> script_t.gp
    echo "set title 'Top 10 des villes les plus traversées'" >> script_t.gp
    echo "set xtics rotate by -45" >> script_t.gp
    echo "plot 'data_t.txt' using 2:xtic(1) title 'Total traversées', '' using 3 title 'Villes de départ'" >> script_t.gp

    # Exécution de GnuPlot avec le fichier de script
    gnuplot script_t.gp

    # Nettoyage des fichiers temporaires
    rm data_t.txt script_t.gp

    echo "Le graphique T a été généré avec succès."


    #script extrait les informations nécessaires du fichier CSV, comptabilise les trajets traversant chaque ville et les départs de chaque ville, puis sélectionne les 10 villes les plus traversées. Enfin, il génère un graphique d'histogramme regroupé pour représenter ces données.

}


function traitement_s()
{
    # EN C

    # Pour un traitement aussi spécifique, une connaissance précise de la structure du fichier CSV est nécessaire. Pour simplifier, supposons que le fichier CSV a trois colonnes : ID_trajet, Ville_depart, Ville_arrivee.

    # Voici un exemple simplifié de code en C pour traiter ce cas, en utilisant des structures pour stocker les données des trajets et des villes, ainsi qu'un arbre AVL pour le tri :

    #UTILISER SSI LE CODE EN C NE FONCTIONNE PAS (VOIR SUITE)


    # Création d'un fichier temporaire pour stocker les statistiques
    fichier_temp=$(mktemp)
    trap 'rm -f $fichier_temp' EXIT

    # Boucle pour parcourir chaque trajet et calculer les statistiques
    awk -F',' 'BEGIN {OFS=","} {trajet[$2]["distance"]+=$3; trajet[$2]["count"]+=1} END {for (t in trajet) print t, trajet[t]["distance"]/trajet[t]["count"], trajet[t]["distance"], trajet[t]["count"]}' "$fichier_csv" | sort -k1,1n > "$fichier_temp"

    # Création du fichier de données pour le graphique
    echo "ID_trajet,Moyenne,Max,Min" > data_s.txt
    awk -F',' '{print $1 "," $2 "," $3 "," $4}' "$fichier_temp" >> data_s.txt

    # Création du fichier de script pour GnuPlot
    echo "set term png" > script_s.gp
    echo "set output 'graphique_s.png'" >> script_s.gp
    echo "set style data lines" >> script_s.gp
    echo "set xlabel 'Identifiant du trajet'" >> script_s.gp
    echo "set ylabel 'Distances en km'" >> script_s.gp
    echo "set title 'Statistiques sur les étapes'" >> script_s.gp
    echo "plot 'data_s.txt' using 1:2 title 'Moyenne' with lines, '' using 1:3 title 'Max' with lines, '' using 1:4 title 'Min' with lines" >> script_s.gp

    # Exécution de GnuPlot avec le fichier de script
    gnuplot script_s.gp

    echo "Le graphique S a été généré avec succès."
}



# Enregistrer le temps de début
start_time=$(date +%s)


# script Shell prend en paramètre le chemin du fichier CSV d'entrée et d'autres paramètres pour choisir les traitements, vous pouvez le concevoir de la manière suivante


# Vérification et exécution des traitements en fonction des choix
case "$choix_traitement" in
    -d1)
        echo "Traitement D1 sélectionné."
        # Appel du programme C pour le traitement D1 avec le fichier CSV en argument
        #./main "$fichier_csv" conducteursAvecPlusDeTrajets
        traitement_d1
        ;;
    -d2)
        echo "Traitement D2 sélectionné."
        # Appel du programme C pour le traitement D2 avec le fichier CSV en argument
        #./main "$fichier_csv" DistanceParConducteur
        traitement_d2
        ;;
    -l)
        echo "Traitement L sélectionné."
        # Appel du programme C pour le traitement L avec le fichier CSV en argument
        #./main "$fichier_csv" TrajetsLesPlusLongs
        traitement_l
        ;;
    -t)
        echo "Traitement T sélectionné."
        # Appel du programme C pour le traitement L avec le fichier CSV en argument
        ./progc/main "$fichier_csv" -t
        ;;
    -s)
        echo "Traitement S sélectionné."
        # Appel du programme C pour le traitement L avec le fichier CSV en argument
        ./progc/main "$fichier_csv" -s
        ;;
    *)
        echo "Choix de traitement non reconnu."
        exit 1
        ;;
           
esac

# Enregistrer le temps de fin
end_time=$(date +%s)

# Calculer la durée totale
duration=$((end_time - start_time))

# Afficher la durée totale
echo "Durée totale: $duration secondes"
