./compile_local.sh
mkdir tmp
rm -rf tmp/docs
cp -R site/ tmp/docs/
F=VMXdocs_`git describe --tags --dirty`.tar
cd tmp/
rm ../$F.gz > /dev/null 2>&1
tar cf ../$F docs/
rm -rf docs/
cd -
rm -rf tmp
gzip $F

if [ "`ls $F.gz | grep dirty`" == "" ];
then
    echo 'not dirty'
    scp $F.gz root@files.vision.ai:/www/vmx/docs/
else
    echo 'dirty, not uploading'
fi
