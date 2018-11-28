#!/bin/bash
# Color text theme
RED='\033[1;31m'
GREEN='\033[1;32m'
BLUE='\033[1;36m'
YELLOW='\033[1;33m'
NONE='\033[0m'
RED0='\033[0;31m'
GREEN0='\033[0;32m'
HYBRIS (){
echo
echo "  █  █    ██ ██    ████     ████    ███    ███"
echo "  █  █     ███     █  ██    █  █     █     █"
echo "  ████      █      ████     ████     █     ███"
echo "  █  █      █      █  ██    █ █      █       █"
echo "  █  █      █      ████     █ █     ███    ███"
echo
}
CLEOFF() { if [ "$CLEOFF" != 1 ]; then
   clear
fi }
ASK (){
echo -n "Вы хотите продолжить? Y/n "
read input
rc=${input:-y}
if [[ "${rc}" == "y" || "${rc}" == "Y" ]]; then
    echo 
else
    clear
fi
}
#Seting`s to download hybris project 

CLEOFF
HYBRIS
echo -e $GREEN"      Parameter       [default]"$NONE
echo "======================#-------#"
echo -n -e "#  Google Drive URL    ["$RED"none"$NONE"]: "
read input
googleDriveURL=${input:-"$RED"none}
echo -n -e "#  Git repository URL  ["$RED"none"$NONE"]: "
read input
gitCloneURL=${input:-"$RED"none}
echo -n -e "#  Branch            ["$YELLOW"master"$NONE"]: "
read input
gitbranch=${input:-master}
#MySql setings
echo -n -e "#  MySql Username      ["$YELLOW"root"$NONE"]: "
read input
userRootMySql=${input:-root}
echo -n -e "#  MySql Password      ["$YELLOW"root"$NONE"]: " 
read input
passRootMySql=${input:-root}
#Project directory
echo -n -e "#  Project name     ["$YELLOW"doctors"$NONE"]: "
read input
hybrisProjectName=${input:-doctors}
echo -n -e "#  Project dir ["$YELLOW"IdeaProjects"$NONE"]: "
read input
ProjectDir=${input:-"IdeaProjects"}
hybrisProjectDir=~/$ProjectDir/$hybrisProjectName

CLEOFF
HYBRIS
echo -e $GREEN"      Parameter       [default]"$NONE
echo "======================#-------#"
echo -e $BLUE"#  Google Drive URL:    $GREEN0"$googleDriveURL"$NONE"
echo -e $BLUE"#  Git repository URL:  $GREEN0"$gitCloneURL"$NONE"
echo -e $BLUE"#  Branch:              $GREEN0"$gitbranch"$NONE"
echo -e $BLUE"#  MySql Username:      $GREEN0"$userRootMySql"$NONE"
echo -e $BLUE"#  MySql Password:      $GREEN0"$passRootMySql"$NONE"
echo -e $BLUE"#  Project name:        $GREEN0"$hybrisProjectName"$NONE"
echo -e $BLUE"#  Project dir:         $GREEN0"$hybrisProjectDir"$NONE"

ASK

#install services
CLEOFF
HYBRIS
echo install services
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install git mysql-server mysql-client curl oracle-java8-installer unzip -y
#download rep from git
CLEOFF
HYBRIS
echo download rep from git
mkdir -p $hybrisProjectDir/hybris/config && cd $hybrisProjectDir;git init;git remote add origin $gitCloneURL;git fetch;git checkout -t origin/$gitbranch
#download hybris gdrive
CLEOFF
HYBRIS
echo download hybris gdrive
ggID=$(echo "$googleDriveURL" | egrep -o '(\w|-){26,}')
ggURL='https://drive.google.com/uc?export=download'
curl  -sc /tmp/gcokie "${ggURL}&id=${ggID}" >/dev/null
getcode="$(awk '/_warning_/ {print $NF}' /tmp/gcokie)"
cmd='curl -o $hybrisProjectDir.zip --insecure -C - -LOJb /tmp/gcokie "${ggURL}&confirm=${getcode}&id=${ggID}"'
echo -e "Downloading hybris from Google Drive..."
eval $cmd
#unzip hybris 
CLEOFF
HYBRIS
echo unzip hybris 
unzip $hybrisProjectDir.zip "hybris/*" -d $hybrisProjectDir 
# create config dir & copy config-local to config
CLEOFF
HYBRIS
echo create config dir & copy config-local to config
cp -avr $hybrisProjectDir/hybris/config-local/* $hybrisProjectDir/hybris/config
#take from config.prop data for DB
CLEOFF
HYBRIS
echo "take from config.prop data for DB"
function prop { 
    grep "^\\s*${1}" $hybrisProjectDir/hybris/config/local.properties|cut -d'=' -f2
}
#mysql create DB from config file
CLEOFF
HYBRIS
echo mysql create DB from config file
mysql -u$userRootMySql -p$passRootMySql <<MYSQL_SCRIPT
CREATE DATABASE $(prop 'db.name');
CREATE USER $(prop 'db.username')@'localhost' IDENTIFIED BY $(prop 'db.password');
GRANT ALL PRIVILEGES ON $(prop 'db.name').* TO $(prop 'db.username')@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT
#download mysql driver from https://mvnrepository.com/artifact/mysql/mysql-connector-java/5.1.47
CLEOFF
HYBRIS
echo download mysql driver from https://mvnrepository.com/artifact/mysql/mysql-connector-java/5.1.47
wget -P $hybrisProjectDir/hybris/bin/platform/lib/dbdriver/ "http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.47/mysql-connector-java-5.1.47.jar"
#hybris generate
CLEOFF
HYBRIS
echo hybris generate
cd $hybrisProjectDir/hybris/bin/platform;. ./setantenv.sh;ant clean all;ant initialize
