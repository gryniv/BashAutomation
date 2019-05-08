#!/bin/bash
# Choice folders:
    mainProjectDir=~/IdeaProjects
# git URL
    GitURL=https://atap-gitlab.spar.local.at/ecom
######################################################
# Hybris latters
    SPAR (){
        if [ "$CLEOFF" != 1 ]; then
        clear
        fi
        echo
        echo "  ████   ████     █     ███"
        echo "  █      █   █   █ █    █  █"
        echo "  ████   ████    ███    ███"
        echo "     █   █      █   █   █  █" 
        echo "  ████   █      █   █   █   █"
        echo
        }
# functions
    ProjectSetings () {
        projectName=$1
        gitLab=$GitURL/$projectName
        ProjectDir=$mainProjectDir/$projectName
        hybrisProjectDir=$ProjectDir/hybris
        hybrisConfigDir=$hybrisProjectDir/config
        hybrisArhive=$2
        hybrisBuildPackege=$hybrisProjectDir/$3
        }
    unzipHybris () {
        unzip $1.* "hybris/*" -d $2
        }
    DevelopPropertySettings () {
        #this setting automaticly add to properties in your project
        echo "solrserver.instances.default.autostart=false" >> $1
        echo "" >> $1
        echo "### autologin in hmc ###" >> $1
        echo "hmc.default.autologin=true" >> $1
        echo "hmc.default.login=admin" >> $1
        echo "hmc.default.password=nimda" >> $1
        }
    gitSubModules () {
        echo "[submodule "hybris/bin/spar-accelerator"]" > .gitmodules
        echo "      path = hybris/bin/spar-accelerator" >> .gitmodules
        echo "      url = $Gitlab/spar-egrocery" >> .gitmodules
        echo "      ignore = all" >> .gitmodules
        }
    hybrisInstall () {
        echo "Please enter your atx Username and Personal Acces Token:"
        cd $mainProjectDir && git clone $gitLab && git checkout develop
        if ["$projectName" != "hervis"]
            then
            cd $hybrisConfigDir && $DevelopPropertySettings custom.properties
            else
            cd $hybrisProjectDir/bin/platform/lib/dbdriver && curl -o mysql-connector-java-5.1.33.jar https://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.33/mysql-connector-java-5.1.33.jar
            cd $hybrisConfigDir && $DevelopPropertySettings local.properties
        fi
        if [ "$projectName" != "spar-egrocery" && "$projectName" != "hervis"]
            then
            echo "Please enter your atx Username and Personal Acces Token:"
            cd $ProjectDir && gitSubModules && git submodule init && git submodule sync && git submodule update
        fi
        cd ~/Downloads && unzipHybris $hybrisArhive $ProjectDir || cd $mainProjectDir && unzipHybris $hybrisArhive $ProjectDir || cd ~/ && unzipHybris $hybrisArhive $ProjectDir || cd ~/Загрузки && unzipHybris $hybrisArhive $ProjectDir || cd ~/Завантаження && unzipHybris $hybrisArhive $ProjectDir
        cd $hybrisBuildPackege && . ./setantenv.sh && ant clean all initialize
        echo "Please press Enter to see more settings"
        }
    ProjectMenu () {
        SPAR
        options=("run hybris server" "run hybris server -debug" "ant all" "ant clean all" "ant initialize" "ant clean all initialize" "Install" "Quit")
            select opt in "${options[@]}"
            do
            case $opt in
                "run hybris server")
                    cd $hybrisBuildPackege && . ./setantenv.sh && . ./hybrisserver.sh
                    ;;
                "run hybris server -debug")
                    cd $hybrisBuildPackege && . ./setantenv.sh && . ./hybrisserver.sh -d
                    ;;
                "ant all")
                    cd $hybrisBuildPackege && . ./setantenv.sh && ant all
                    ;;
                "ant initialize")
                    cd $hybrisBuildPackege && . ./setantenv.sh && ant all
                    ;;
                "ant clean all")
                    cd $hybrisBuildPackege && . ./setantenv.sh && ant clean all
                    ;;
                "ant clean all initialize")
                    cd $hybrisBuildPackege && . ./setantenv.sh && ant clean all initialize
                    ;;
                "Install")
                    hybrisInstall
                    ;;
                "Quit")
                    SPAR
                    break
                    ;;
                *) echo "invalid option $REPLY";;
            esac
            done
        }
SPAR
options=("Spar-egrocery" "Spar-SI" "Spar-HU" "Spar-WWNF" "Spar-NF2" "Hervis" "Quit")
PS3='Please enter your project: '
select opt in "${options[@]}"
do
    case $opt in
        "Spar-egrocery")
            ProjectSetings spar-egrocery HYBRISCOMM6600P_0-70003031 build
            ProjectMenu
            ;;
        "Spar-SI")
            ProjectSetings spar-si HYBRISCOMM6600P_0-70003031 build
            ProjectMenu
            ;;
        "Spar-HU")
            ProjectSetings spar-hu HYBRISCOMM6600P_0-70003031 build
            ProjectMenu
            ;;
        "Spar-WWNF")
            ProjectSetings spar-wwnf HYBRISCOMM6600P_0-70003031 build
            ProjectMenu
            ;;
        "Spar-NF2")
            ProjectSetings spar-nf2 HYBRISCOMM6600P_0-70003031 build
            ProjectMenu
            ;;
        "Hervis")
            ProjectSetings hervis HYBRISCOMM6500P_9-80003045 bin/platform
            ProjectMenu
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
