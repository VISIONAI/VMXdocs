#!/bin/bash 
# Here is a short documentation genration script

# file=docs/VMXserver.html
# echo '' > $file
# cat header.html >> $file
# cat ~/projects/VMXserver/README.md >> $file
# echo '' >> $file
# echo 'Last modified: **' `date` '**'>> $file
# echo '' >> $file
# echo 'VMX version: **' `cat ~/projects/VMXserver/build/VMXserver.app/version` '**'>> $file
# cat footer.html >> $file

file=docs/MCR.html
echo '' > $file
cat header.html >> $file
cat MCR.md >> $file
echo '' >> $file
#echo 'Last modified: **' `date` '**'>> $file
#echo '' >> $file
#echo 'VMX version: **' `cat ~/projects/VMXserver/build/VMXserver.app/version` '**'>> $file
cat footer.html >> $file

# file=docs/VMX.html
# echo '' > $file
# cat header.html >> $file
# cat ~/projects/vmxmiddle/README.md >> $file
# echo '' >> $file
# echo 'Last modified: **' `date` '**'>> $file
# echo '' >> $file
# echo 'VMX version: **' `cat /Users/tomasz/projects/vmxmiddle/dist/VMX.app/version` '**'>> $file
# cat footer.html >> $file

# version='VMXAppBuilder-v'`jq -r .version ~/projects/vmxmiddle/static/package.json`

# file=docs/VMXAppBuilder.html
# echo '' > $file
# cat header.html >> $file
# cat ~/projects/vmxmiddle/static/README2.md >> $file
# echo '' >> $file
# echo 'Last modified: **' `date` '**'>> $file
# echo '' >> $file
# echo 'VMX version: **' $version '**'>> $file
# cat footer.html >> $file
