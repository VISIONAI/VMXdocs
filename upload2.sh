./compile_local.sh
mkdir tmp
rm -rf tmp/docs
cp -R site/ tmp/docs/
F=VMXdocs_`git describe --tags --dirty`.tar
cd tmp/
rm ../$F.gz
tar cf ../$F docs/
rm -rf docs/
cd -
rm -rf tmp
gzip $F

if [ "`ls $F.gz | grep dirty`" == "" ];
then

    echo 'not dirty'
else
    echo 'dirty'
fi
