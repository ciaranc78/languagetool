#!/bin/sh

CURRENT_DIR=`pwd`
CURRENT_BASE=`basename $CURRENT_DIR`
if [ "$(basename $CURRENT_DIR)" != 'scripts' ]; then
    echo "Error: Please start this script from inside the 'scripts' directory";
    exit 1;
fi

echo ""
echo "###"
echo "### Admin only - you will need the server password to deploy the code ###"
echo "### This will deploy the code for e.g. https://languagetool.org:8081/?text=foo&language=en-US ###"
echo "###"
echo ""
sleep 1

cd ../.. &&
  mvn clean package -DskipTests &&
  cd languagetool-standalone &&
  scp target/LanguageTool-[1-9].[0-9]*.zip languagetool@languagetool.org: &&
  ssh languagetool@languagetool.org "unzip -d /home/languagetool/api ~/LanguageTool-[1-9].[0-9]*.zip && cp -r /home/languagetool/api/LanguageTool-[1-9].[0-9]*/* /home/languagetool/api/ && rm -rf /home/languagetool/api/LanguageTool-[1-9].[0-9]*/ && cd /home/languagetool/ && ./restart-api-server.sh && rm ~/LanguageTool-[1-9].[0-9]*.zip"
