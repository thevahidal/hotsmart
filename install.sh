#!/bin/bash

base_url=https://raw.githubusercontent.com/
repo=thevahidal/hotsmart/
branch=main/
file_base_url=${base_url}${repo}${branch}

hotsmart_file=hotsmart.sh
completion_file=hotsmart-completion.bash

home_dir=~
installation_dir=${home_dir}/.hotsmart/

echo Installation directory: $installation_dir

mkdir -p $installation_dir >/dev/null 2>&1

echo Downloading files...
curl ${file_base_url}${hotsmart_file} -o ${installation_dir}${hotsmart_file} >/dev/null 2>&1
curl ${file_base_url}${completion_file} -o ${installation_dir}${completion_file} >/dev/null 2>&1

echo Installing Hotsmart...
sudo install ${installation_dir}${hotsmart_file} /bin/hotsmart


echo Installation completed.
echo