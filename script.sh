#!/bin/bash
#    $# : nombre des args
#export yad.sh

#fonction qui affiche le help
function helpp()
{
cat help.txt

}

#lister les fichier >100 ko
function lister()
{

sudo find /home/$USER -type f -printf '%f\n' -size +100k
}

#fonction qui affiche la version
function version(){
echo "LES AUTEURS:
Imtinen abrougui
Zeineb benkhalifa"
echo "VERSION 2.0"
}

#tester le nmbr des argument 
function testt()
{ 
if [[ $# -eq 0 ]]; then
erreurs="veuillez entrer au moins un argument"
echo $erreurs
return `echo $erreurs >>erreur`
fi
}

#compresser ou supprimer un fichier
function comsup()
{
if [ $# -ge 1 ];then
	j=0
	for i in $@ -size +100K
	do
		let j++
		read -p "Boucle $j"

		while [[ $choix != "s" && $choix != "c" ]]
		do
		read -p "Votre Choix : s/c : supprimer ou compresser $1" choix
		done

		if [ $choix = "s" ];then
			echo "suppression de $i ...."
			rm -f $i
		elif [ $choix = "c" ];then
			echo "compression de $i ...."
			gzip -f $i
		fi
	done
else echo "Il faut specifier aux moins un seul paramêtre"
fi

}

function compresser(){

# Take the filename
read -p 'Enter the filename to compresse: ' filename

# Check the file is exists or not
if [ -f $filename ]; then
   # compresser the file with permission
   gzip "$filename"
   # Check the file is removed or not
   if [ -f $filename ]; then
      echo "$filename is not compressed"
   else
      echo "$filename is compressed"
   fi
else
   echo "File does not exist"
fi
}

function remove(){

# Take the filename
read -p 'Enter the filename to delete: ' filename

# Check the file is exists or not
if [ -f $filename ]; then
   # Remove  the file with permission
   rm -i "$filename"
   # Check the file is removed or not
   if [ -f $filename ]; then
      echo "$filename is not removed"
   else
      echo "$filename is removed"
   fi
else
   echo "File does not exist"
fi
}

removeOrCompress(){
	for i in $* 
	do
		echo "file $i : 1)remove or 2)Compress ?"
		read choix
		if [[ $choix -eq 1 ]]; then
			remove $i
		elif [[ $choix -eq 2 ]]; then
			compresser $i
		else 
			echo "choix incorrect"
	fi
	done
}

interface_graphique(){
choix=$(yad --title=$TITBOX --text=" Veuillez entrer votre choix." \
	--window-icon="$MENU" --image="$MENU" --image-on-top \
--height=500 --list --radiolist --no-headers \
	--column 1 --column 2 --print-column=2 \
		 true "afficher la sortie standard du message" false  "tester la presence de moins un argument" \
		 false "afficher le help" false "lister tous les fichiers faisant plus de 100ko" \ false "supprimer un fichier" false "compresser un fichier" \ false "supprimer ou compresser" false "ecrire un journal avec le nom de tous les fichiers supprimes et lheure de leur suppression"
)

echo $choix
# Programme #



	case $choix in
	afficher?la?sortie?standard?du?message*)
		show_usage	
	;;
	tester?la?presence?de?moins?un?argument*)
		read a
		testt $a
	;;
	supprimer?ou?compresser*)
	echo "donnez les noms des fichiers (separés par des espaces)"
read args
removeOrCompress $args
	echo helpp
	;;
	afficher?le?help*)
		helpp
        ;;
supprimer?un?fichier*)
                remove
        ;;
compresser?un?fichier*)
		compresser 
        ;;
lister?tous?les?fichiers?faisant?plus?de?100ko*)
		lister
        ;;
ecrire?un?journal?avec?le?nom?de?tous?les?fichiers?supprimes?et?lheure?de?leur?suppression*)
trash-list >> journal_supp
        ;;
	esac


}
function menu()
{
PS3="votre choix : "
select item in "-show_usage-" "-test-" "-help-" "-lister-" "-supprimer-" "-compresser-" "-suppcomp-" "-ecrire-" "-graphique-"
do
echo "vous avez choisi l'item $REPLAY : $item"
case $REPLY in 
1)
echo "afficher la sortie standard du message"
show_usage
;;
2)
echo "tester la presence de moins un argument"
read a
testt $a
;;
3)
echo "afficher le help"
helpp
;;
4)
echo "lister tous les fichiers faisant plus de 100ko"
lister
;;
5)
remove
echo "supprimer un fichier si la taille dépasse 100ko"
;;
6)
echo "compresser un fichier si la taille depasse 100ko"
compresser 
;;
7)
echo "supprimer ou compresser"
echo "donnez les noms des fichiers (separés par des espaces)"
read args
removeOrCompress $args
;;
8)
echo "ecrire un journal avec le nom de tous les fichiers supprimes et l'heure de leur suppression"
trash-list > journal_supp
exit 0
;;
9)
interface_graphique
;;
*)
echo "choix incorrect"
;;
esac
done
}

show_usage()
{
echo "disque: [-h] [-j] [-s] [-p] [-l] [-v] [-m] [-g] chemin..  "
case $option in
h)
echo "afficher le help détaillé à partir d un fichier texte"
helpp
;;
g)
echo "afficher un menu textuel et gérer les fonctionnalités de façon graphique (Utilisation de YAD)."
interface_graphique
;;
v)
echo "afficher le nom des auteurs et la version du code"
version
;;
j)
echo "créer le fichier journal des fichiers supprimés"
;;
c)
compresser 
;;
s)
remove
;;
p)
echo "parcourir des fichiers pour supprimer ou compresser"
comsup $@
;;
l)
echo "lister des fichiers de taille supérieur à 100ko"
lister
;;
m)
echo "pour afficher un menu textuel (en boucle) qui permet d accéder à chaque fonction"
menu
;;
*)
echo "erreur"
;;
esac

echo "analyse des options terminée"
}


