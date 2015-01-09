rm -rf site/
mkdir site
sed 's/Docs:/Docs:'`git describe --tags --dirty`'/g' mkdocs.yml > mkdocs2.yml
cp mkdocs.yml mkdocs.yml.save
cp mkdocs2.yml mkdocs.yml
mkdocs build -use_directory_urls=false 
mv mkdocs.yml.save mkdocs.yml
rm mkdocs2.yml
cd mcr
./generate_docs.sh
cp -R docs/* ../site/
cd - >/dev/null
