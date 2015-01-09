#!/bin/sh

cp custom_theme/base.html base.html.save
cp custom_theme/base2.html custom_theme/base.html

./compile.sh
mv base.html.save custom_theme/base.html
