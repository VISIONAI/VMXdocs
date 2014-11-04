rm -rf site/
mkdir site
mkdocs build -use_directory_urls=false 
cd mcr
./generate_docs.sh
cp -R docs/* ../site/
cd - >/dev/null
