#!/bin/sh

cp custom_theme/base.html custom_theme/base.html.save
cp custom_theme/base2.html custom_theme/base.html

./compile.sh
mv custom_theme/base.html.save custom_theme/base.html
