#!/bin/bash
source script.sh

if [[ $# -eq 0 ]]; then
echo "disque: [-h] [-j] [-s] [-p] [-l] [-v] [-m] [-g] chemin..  "
exit
fi


while getopts "scp:ljmgvh" option
do
echo "getopts a trouvé l'option $option"
case $option in
h)
echo "afficher le help détaillé à partir d un fichier texte"
helpp
;;
g)
interface_graphique
echo "afficher un menu textuel et gérer les fonctionnalités de façon graphique (Utilisation de YAD)."
;;
v)
echo "afficher le nom des auteurs et la version du code"
version
;;
j)
echo "créer le fichier journal des fichiers supprimés"
trash-list > journal_supp
;;
c)
compresser 
;;
s)
remove 
;;
p)
read args
removeOrCompress $args
;;
l)
echo "lister des fichiers de taille supérieur à 100ko"
lister
;;
m)
echo "pour afficher un menu textuel (en boucle) qui permet d accéder à chaque fonction"
menu
;;
esac
done
echo "Analyse des options terminée"
exit 0
