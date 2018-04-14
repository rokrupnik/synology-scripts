#!/bin/bash

# Preverimo, ce imamo vse argumente, potrebujemo vsaj 2
if [[ $# -lt 2 ]] ; then
     echo 'ERROR: too few arguments. Usage: ./photo-sync.sh SOURCE_FOLDER DESTINATION_FOLDER'
     exit 0
fi

# Najdemo vse xmp datoteke, katerim odstranimo prvi del poti (pot izvorne mape), da se kasneje pravilno kopirajo
find $1 -type f -name "*.xmp" | sed 's,^'"$1"',,g' > xmp_files.list

# Seznamu xmp datotek zamenjamo koncnico v nef, da dobimo seznam nef datotek, ki jih zelimo prenesti
sed 's/xmp$/nef/g' xmp_files.list > nef_files.list

# Seznama zdruzimo v eno datoteko
cat xmp_files.list nef_files.list > sync_files.list

# Premaknemo izbrane datoteke, shranimo seznam premaknjenih datotek
mkdir -p ./log/files_synced
rsync -avz --files-from=sync_files.list $1 $2 > "./log/files_synced/$(date +"%FT%H-%M-%S").log"

# Pobrisemo delovne datoteke
rm xmp_files.list nef_files.list sync_files.list