#!/bin/bash

# Dieses Script lädt alle Podcast einer RSS XML Url runter und benennt sie um

# Zum Ändern der ID3 Tags muss das Kommandozeilenprogramm eyeD3 installiert sein

# Erstellt einen neuen TEMP und einen RSS Ordner
mkdir Download_Temp
mkdir RSS

# Lädt den HTML Quelltext

curl -o Download_Temp/Freeses.html -A "Mozilla/5.0 (X11; Ubuntu; « Linux x86_64; rv:86.0) Gecko/20100101 Firefox/86.0" "https://www.ndr.de/ndr2/fruehstueck_bei_stefanie/podcast2956.xml"

# Sucht im Quelltext nach der URL
URLmp3=$(grep -E '<enclosure url=' Download_Temp/Freeses.html | cut -d= -f2 | cut -c 2- | rev | cut -c 7- | rev)


# Schreibt die URL in die Variable URLmp3 und speichert sie unter Download_Temp/URLmp3.txt ab
echo "$URLmp3"
echo -e "$URLmp3 \n" > Download_Temp/URLmp3.txt

# Sucht im Quelltext nach dem Namen der Sendung
NAMEmp3=$(grep -E '<title>' Download_Temp/Freeses.html | cut -d">" -f2 | rev | cut -c 8- | rev)

# Schreibt den Namen in die Variable NAMEmp3 und speichert sie unter Download_Temp/NAMEmp3.txt ab
echo "$NAMEmp3"
echo -e  "$NAMEmp3 \n" > Download_Temp/NAMEmp3.txt

# Sucht im Quelltext nach Informationen zu der Sendung
INFOmp3=$(grep -E '<p>' Download_Temp/Freeses.html | cut -d">" -f3 | rev | cut -c 4- | rev)

# Schreibt die Information in die Variable INFOmp3 und speichert sie unter Download_Temp/INFOmp3.txt ab
echo "$INFOmp3"
echo -e "$INFOmp3 \n" > Download_Temp/INFOmp3.txt

# Sucht im Quelltext nach dem Datum der Sendung
DATUMmp3=$(grep -E '<pubDate>' Download_Temp/Freeses.html | cut -d" " -f2,3,4 | rev | cut -c 1- | rev)
JAHRmp3=$(grep -E '<pubDate>' Download_Temp/Freeses.html | cut -d" " -f4 | rev | cut -c 1- | rev)
MONATmp3=$(grep -E '<pubDate>' Download_Temp/Freeses.html | cut -d" " -f3 | rev | cut -c 1- | rev)
TAGmp3=$(grep -E '<pubDate>' Download_Temp/Freeses.html | cut -d" " -f2 | rev | cut -c 1- | rev)

# Speichert das Datum ab
echo "$DATUMmp3"
echo -e  "$DATUMmp3 \n" > Download_Temp/DATUMmp3.txt

echo "$JAHRmp3"
echo -e  "$JAHRmp3 \n" > Download_Temp/JAHRmp3.txt

echo "$MONATmp3"
echo -e  "$MONATmp3 \n" > Download_Temp/MONATmp3.txt

echo "$TAGmp3"
echo -e  "$TAGmp3 \n" > Download_Temp/TAGmp3.txt

# Zählt die Anzahl der Sendungen, die im Quelltext gefunden worden sind und speichert sie unter $AnzahlMP3 ab
AnzahlMP3=$(wc -l < Download_Temp/URLmp3.txt)
echo "$AnzahlMP3"

# Schneidet die ersten Zeilen in bestimmten Variabeln ab, da in der RSS XML Datei ein Kopftext existiert. Kann von Podcast zu Podcast unterschiedlich sein, hier muss man experimentieren, besonders bei Zeile 62
tail -n +2 Download_Temp/DATUMmp3.txt > tmp.txt && mv tmp.txt Download_Temp/DATUMmp3.txt
tail -n +2 Download_Temp/JAHRmp3.txt > tmp.txt && mv tmp.txt Download_Temp/JAHRmp3.txt
tail -n +2 Download_Temp/MONATmp3.txt > tmp.txt && mv tmp.txt Download_Temp/MONATmp3.txt
tail -n +3 Download_Temp/NAMEmp3.txt > tmp.txt && mv tmp.txt Download_Temp/NAMEmp3.txt
tail -n +2 Download_Temp/TAGmp3.txt > tmp.txt && mv tmp.txt Download_Temp/TAGmp3.txt

# Löscht den immer gleichen Dateinamen (jeder Podcast fängt mit "Wir sind die Freeses: " an)
sed -i -e 's/Frühstück bei Stefanie: //g' Download_Temp/NAMEmp3.txt

# Wandelt den Monat von Buchstaben in Zahlen um (aus Jan wird so 01 usw.)
sed -i -e 's/Jan/01/g' Download_Temp/MONATmp3.txt
sed -i -e 's/Feb/02/g' Download_Temp/MONATmp3.txt
sed -i -e 's/Mar/02/g' Download_Temp/MONATmp3.txt
sed -i -e 's/Apr/04/g' Download_Temp/MONATmp3.txt
sed -i -e 's/May/05/g' Download_Temp/MONATmp3.txt
sed -i -e 's/Jun/06/g' Download_Temp/MONATmp3.txt
sed -i -e 's/Jul/07/g' Download_Temp/MONATmp3.txt
sed -i -e 's/Aug/08/g' Download_Temp/MONATmp3.txt
sed -i -e 's/Sep/09/g' Download_Temp/MONATmp3.txt
sed -i -e 's/Oct/10/g' Download_Temp/MONATmp3.txt
sed -i -e 's/Nov/11/g' Download_Temp/MONATmp3.txt
sed -i -e 's/Dec/12/g' Download_Temp/MONATmp3.txt


# Automatische Schleife
for ((i=1;$i<="AnzahlMP3";i++))

# Startet die Schleife
do

# Sucht sich die erste Zeile raus und speichert deren Ihnalt unter einer extra Variable ab, danach wir die aktuelle Zeile gelöscht, sodass im nächsten durchlauf auch die nächste Zeile drankommt
ZeileURL=$(awk 'FNR <= 1' Download_Temp/URLmp3.txt)
echo "$ZeileURL"
tail -n +2 Download_Temp/URLmp3.txt > tmp.txt && mv tmp.txt Download_Temp/URLmp3.txt

ZeileNAME=$(awk 'FNR <= 1' Download_Temp/NAMEmp3.txt)
echo "$ZeileNAME"
tail -n +2 Download_Temp/NAMEmp3.txt > tmp.txt && mv tmp.txt Download_Temp/NAMEmp3.txt

ZeileINFO=$(awk 'FNR <= 1' Download_Temp/INFOmp3.txt)
echo "$ZeileINFO"
tail -n +2 Download_Temp/INFOmp3.txt > tmp.txt && mv tmp.txt Download_Temp/INFOmp3.txt

ZeileDATUM=$(awk 'FNR <= 1' Download_Temp/DATUMmp3.txt)
echo "$ZeileDATUM"
tail -n +2 Download_Temp/DATUMmp3.txt > tmp.txt && mv tmp.txt Download_Temp/DATUMmp3.txt

ZeileJAHR=$(awk 'FNR <= 1' Download_Temp/JAHRmp3.txt)
echo "$ZeileJAHR"
tail -n +2 Download_Temp/JAHRmp3.txt > tmp.txt && mv tmp.txt Download_Temp/JAHRmp3.txt

ZeileMONAT=$(awk 'FNR <= 1' Download_Temp/MONATmp3.txt)
echo "$ZeileMONAT"
tail -n +2 Download_Temp/MONATmp3.txt > tmp.txt && mv tmp.txt Download_Temp/MONATmp3.txt

ZeileTAG=$(awk 'FNR <= 1' Download_Temp/TAGmp3.txt)
echo "$ZeileTAG"
tail -n +2 Download_Temp/TAGmp3.txt > tmp.txt && mv tmp.txt Download_Temp/TAGmp3.txt

# Lädt letztenendes den eigentlichen Podcast runter
curl -o RSS/"$ZeileNAME".mp3 -A "Mozilla/5.0 (X11; Ubuntu; « Linux x86_64; rv:86.0) Gecko/20100101 Firefox/86.0" "$ZeileURL"

# Passt den ID3 Tag der mp3 Datei an
eyeD3 RSS/"$ZeileNAME".mp3 --title="$ZeileNAME"
eyeD3 RSS/"$ZeileNAME".mp3 --remove-all-comments
eyeD3 RSS/"$ZeileNAME".mp3 --comment="$ZeileINFO"
eyeD3 RSS/"$ZeileNAME".mp3 -Y "$ZeileJAHR"

# Ändert das erstell und Änderungsdatum der mp3 Datei
touch -t "$ZeileJAHR""$ZeileMONAT""$ZeileTAG"0000 RSS/"$ZeileNAME".mp3

# Lässt das Programm eine Sekunde warten, kann kommentiert werden
sleep 1

# Beendet die Schleife
done

# Löscht zum Schluss, wenn alle Podcast runtergeladen sind den TEMP Ordner, kann zu Debug Zwecken kommentiert werden
rm -r Download_Temp 