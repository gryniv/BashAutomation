#!/bin/bash
gURL=$
gitURL=
gitbranch=
hproject=doctors
urmysql=root
prmysql=root
#install services
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install git mysql-server mysql-client curl oracle-java8-installer unzip -y
#download rep from git
mkdir -p ~/IdeaProjects/"$hproject"/hybris/config && cd ~/IdeaProjects/"$hproject"/hybris;git init;git remote add origin $gitURL;git fetch;git checkout -t origin/$gitbranch
#download hybris gdrive
ggID=$(echo "$gURL" | egrep -o '(\w|-){26,}')
ggURL='https://drive.google.com/uc?export=download'
curl  -sc /tmp/gcokie "${ggURL}&id=${ggID}" >/dev/null
getcode="$(awk '/_warning_/ {print $NF}' /tmp/gcokie)"
cmd='curl -o ~/IdeaProjects/"$hproject".zip --insecure -C - -LOJb /tmp/gcokie "${ggURL}&confirm=${getcode}&id=${ggID}"'
echo -e "Downloading hybris from Google Drive..."
eval $cmd
#unzip hybris 
unzip ~/IdeaProjects/"$hproject".zip "hybris/*" -d ~/IdeaProjects/"$hproject" 
# create config dir & copy config-local to config
cp -avr ~/IdeaProjects/"$hproject"/hybris/config-local/* ~/IdeaProjects/"$hproject"/hybris/config
#take from config.prop data for DB
function prop { 
    grep "^\\s*${1}" ~/IdeaProjects/"$hproject"/hybris/config/local.properties|cut -d'=' -f2
}
#mysql create DB from config file
mysql -u$urmysql -p$prmysql <<MYSQL_SCRIPT
CREATE DATABASE $(prop 'db.name');
CREATE USER $(prop 'db.username')@'localhost' IDENTIFIED BY $(prop 'db.password');
GRANT ALL PRIVILEGES ON $(prop 'db.name').* TO $(prop 'db.username')@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT
#download mysql driver from https://mvnrepository.com/artifact/mysql/mysql-connector-java/5.1.47
wget -P ~/IdeaProjects/"$hproject"/hybris/bin/platform/lib/dbdriver/ "http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.47/mysql-connector-java-5.1.47.jar"
#hybris generate
cd ~/IdeaProjects/"$hproject"/hybris/bin/platform;. ./setantenv.sh;ant clean all;ant initialize
