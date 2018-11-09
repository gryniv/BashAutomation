#!/bin/bash
googleDriveURL=$
gitCloneURL=
gitbranch=master
hybrisProjectName=doctors
urmysql=root
prmysql=root
#install services
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install git mysql-server mysql-client curl oracle-java8-installer unzip -y
#download rep from git
mkdir -p ~/IdeaProjects/"$hybrisProjectName"/hybris/config && cd ~/IdeaProjects/"$hybrisProjectName";git init;git remote add origin $gitCloneURL;git fetch;git checkout -t origin/$gitbranch
#download hybris gdrive
ggID=$(echo "$googleDriveURL" | egrep -o '(\w|-){26,}')
ggURL='https://drive.google.com/uc?export=download'
curl  -sc /tmp/gcokie "${ggURL}&id=${ggID}" >/dev/null
getcode="$(awk '/_warning_/ {print $NF}' /tmp/gcokie)"
cmd='curl -o ~/IdeaProjects/"$hybrisProjectName".zip --insecure -C - -LOJb /tmp/gcokie "${ggURL}&confirm=${getcode}&id=${ggID}"'
echo -e "Downloading hybris from Google Drive..."
eval $cmd
#unzip hybris 
unzip ~/IdeaProjects/"$hybrisProjectName".zip "hybris/*" -d ~/IdeaProjects/"$hybrisProjectName" 
# create config dir & copy config-local to config
cp -avr ~/IdeaProjects/"$hybrisProjectName"/hybris/config-local/* ~/IdeaProjects/"$hybrisProjectName"/hybris/config
#take from config.prop data for DB
function prop { 
    grep "^\\s*${1}" ~/IdeaProjects/"$hybrisProjectName"/hybris/config/local.properties|cut -d'=' -f2
}
#mysql create DB from config file
mysql -u$urmysql -p$prmysql <<MYSQL_SCRIPT
CREATE DATABASE $(prop 'db.name');
CREATE USER $(prop 'db.username')@'localhost' IDENTIFIED BY $(prop 'db.password');
GRANT ALL PRIVILEGES ON $(prop 'db.name').* TO $(prop 'db.username')@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT
#download mysql driver from https://mvnrepository.com/artifact/mysql/mysql-connector-java/5.1.47
wget -P ~/IdeaProjects/"$hybrisProjectName"/hybris/bin/platform/lib/dbdriver/ "http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.47/mysql-connector-java-5.1.47.jar"
#hybris generate
cd ~/IdeaProjects/"$hybrisProjectName"/hybris/bin/platform;. ./setantenv.sh;ant clean all;ant initialize
