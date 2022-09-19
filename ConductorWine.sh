#!/bin/bash
#----------------------------------------------------------
# Author: Airvikar <http://ubuntu-wine.ru>
# Modified and translated by: Demontager  
#----------------------------------------------------------

if ! [ -f /usr/bin/zenity ]
 then
  AHT="Warning! Script requires zenity. You may install it from \"Ubuntu Sofware Center\" or with sudo apt-get install zenity."
  echo "Warning!"
  echo "Script requires zenity!"
  echo "You may install it from \"Ubuntu Software Center\""
  echo "or with sudo apt-get install zenity"
  gnome-terminal -x bash -i -c "echo -en $AHT; sleep 3"
  read
  exit
 else
  echo "Zenity package installed!"
fi
if ! [ -f /usr/bin/wine ]
 then
  WV="Wine not installed"
 else
  WV=`wine --version`
fi
dW=`zenity --width "640" --height "200"  --list --radiolist \
       --title="Choose folder to install Wine" \
       --text="What Wine version are you going to use?\n System has $WV! as default" \
       --column="Check" --column="N"  --column="Current Wine" --column="Path" \
       FALSE "1" "Install additional Wine version" " Define installation folder" \
       TRUE "2" "Choose already installed Wine versions" " Define path..." \
       --print-column="2"`
       case $? in
        0) echo "" ;;
        1) exit ;;
       -1) exit ;;
      esac
if ! [ $dW = 1 ]
 then
  WINEPATH="$HOME"
  while [ "$WINEPATH" = "$HOME" ]; do
     WINEPATH=`zenity --width "600" --height "600" --file-selection \
     --filename="$HOME"\/ \
     --directory \
     --title="Locate folder with Wine installed"`
     case $? in
      0)
         if ! [ -f "$WINEPATH/bin/wine" ]
           then
              zenity --info \
              --title="$WINEPATH" \
              --text="\nWarning!!! \nFolder does not contain Wine. \nProbably you are wrong. \nStart from beginning."
              case $? in
                  0)
                    WINEPATH="$HOME" ;;
                  *) 
                     exit ;;
              esac
           fi ;;
      *) exit ;;
     esac
   done
 WINEPATH="$WINEPATH"
 else
echo ""
     while [ "$dirW" = "" ]; do
        hp="$HOME"
        dirW=`zenity --width "480" --height "200" --entry \
        --title="Install your Wine to $hp" \
        --text="Enter name for Wine folder"`
         case $? in
           0) 
                 if [ -d "$hp/$dirW" ]
                   then
                      zenity --question --title="Warning: folder $dirW already exist" \
                      --text="Are you sure to install Wine in that folder? \nDestination folder: $hp/$dirW"
                      case $? in
                         0) if [ -f "$hp/$dirW/bin/wine" ]
                               then
                                   zenity --info --title="Unable to proceed!" \
                                   --text="Folder $dirW has already Wine installed! \nFile found: $hp/$dirW/bin/wine \nDefine another..."
                                   case $? in
                                     0) 
                                         dirW="" ;;
                                     *) exit ;;
                                   esac
                              fi ;;
                         1) 
                           dirW="" ;;
                        -1)
                            exit ;;
                      esac
                   fi ;;

           *) exit ;;
         esac
      done
WINEPATH="$HOME/$dirW"
echo "стоп WINEPATH=$WINEPATH"
mkdir -p "$WINEPATH"
zen() {
tee >( zenity --progress --title="$tl" --text="$tx" --pulsate --auto-close --auto-kill)
}
cd "$WINEPATH"
while ! [ -f "$vW" ]; do
tl="List of Wine versions"
tx="Downloading versions list"
wget -c --progress=dot http://www.playonlinux.com/wine/binaries/linux-x86/ --limit-rate=20k 2>&1 | zen
POL=$(cat index.html | grep PlayOnLinux-wine- | sed 's/<[^>]\+>/\n/g' | grep pol | sed s/.sha1//g | sort | uniq)
vW=`zenity --width "380" --height "600" --list \
--title="Choose Wine version" \
--radiolist \
--column="№" --column="Wine versions" \
$POL`
 case $? in
   0)
     tl="$vW"
     tx="Downloading $vW"
     wget -c --progress=dot http://www.playonlinux.com/wine/binaries/linux-x86/$vW 2>&1 | zen ;;
   1) exit ;;
  -1) exit ;;
 esac
done
tl="$vW"
tx="Unpacking $vW"
   if [ -f "$vW" ]
    then
      tar xvf "$vW" | zen
      rm -rf files
      rm -rf playonlinux
      cd wineversion
      Vers=`ls`
      cd -
      mv wineversion/$Vers/* "$WINEPATH"
      wget -c -P "$WINEPATH/bin" http://winetricks.org/winetricks
      chmod +x "$WINEPATH/bin/winetricks"
      rm -rf wineversion
      rm -rf idex.html
      rm -rf "$vW"
    else
      zenity --error \
      --title="Error" \
      --text="\nWarning!!! \nWine not selected."
      case $? in
        0)
          exit ;;
        1)
          exit;;
       -1) 
          exit;;
      esac
    fi
  fi
export PATH="$WINEPATH/bin:${PATH}"
export LD_LIBRARY_PATH="$WINEPATH/lib/:/usr/lib:${LD_LIBRARY_PATH}"
export WINESERVER="$WINEPATH/bin/wineserver"
export WINELOADER="$WINEPATH/bin/wine"
#export WINEDLLPATH="$WINEPATH/lib/wine/fakedlls:$WINEPATH/lib/i386-linux-gnu/wine"
export WINEDLLPATH="$WINEPATH/lib/wine:$WINEPATH/lib/wine/fakedlls:$WINEPATH/lib/i386-linux-gnu/wine"
export WINEARCH="win32"
dirP=`zenity --width "640" --height "200"  --list --radiolist \
       --title="Select Wine prefix" \
       --text="Which Wine prefix are you going to use?\n" \
       --column="Select" --column="N"  --column="Current prefix" --column="Path" \
       TRUE "1" "Configure new prefix" "Define prefix folder" \
       FALSE "2" "Add existent prefix to Wine" "Define prefix path" \
       --print-column="2"`
       case $? in
        0) echo "" ;;
        1) exit ;;
       -1) exit ;;
      esac
if ! [ $dirP = 1 ]
 then
    WINEPREFIX="$HOME"
    while [ "$WINEPREFIX" = "$HOME" ]; do
    WINEPREFIX=`zenity --width "480" --height "600" --file-selection \
    --filename="$HOME"\/ \
    --directory \
    --title="Select prefix for Wine (default is .wine)"`
    case $? in
     0) WP=${WINEPREFIX##*/}
          if ! [ -d "$WINEPREFIX/drive_c/Program Files/" ]; then
            zenity --info --title="Unable to continue!" \
             --text="Folder $WP has no configured prefix! \nPath not found: $WINEPREFIX/drive_c/Program\ Files/ \nTry again..."
             case $? in 
                0) 
                   WINEPREFIX="$HOME" ;;
             esac
          fi ;;
     1) exit ;;
    -1) exit ;;
     esac
     done
  export WINEPREFIX="$WINEPREFIX"
 else
      while [ "$WP" = "" ]; do
        hp="$HOME"
        WP=`zenity --width "480" --height "200" --entry \
        --title="Configure Wine prefix in $hp" \
        --text="Enter folder name to configure Wine prefix in it"`
         case $? in
           0)
               dubP="$HOME/$WP"
               if [ -d "$dubP" ]
                 then 
                  zenity --info --title="Unable to continue!" \
                  --text="Folder $WP already exist! \nDefine another one."
                   case $? in
                   0)
                      WP="" ;;
                   esac
               fi ;;
            *) exit ;;
          esac
         WINEPREFIX="$HOME/$WP"
      done
  WINEPREFIX="$HOME/$WP"
fi
export WINEPREFIX=$WINEPREFIX
env WINEPREFIX="$WINEPREFIX" "$WINELOADER" "$WINEPATH/bin/winecfg"
verW=`"$WINELOADER" --version`
Control="Control($verW)"
mkdir -p "$WINEPREFIX/$Control"
echo "#!/bin/bash" > "$WINEPREFIX/$Control/environmen.sh"
echo "export LD_LIBRARY_PATH=\"$WINEPATH/lib:\$LD_LIBRARY_PATH\"" >> "$WINEPREFIX/$Control/environmen.sh"
echo "export WINEPREFIX=\"$WINEPREFIX\"" >> "$WINEPREFIX/$Control/environmen.sh"
echo "WINEPATH=\"$WINEPATH\"" >> "$WINEPREFIX/$Control/environmen.sh"
echo "export WINESERVER=\"$WINEPATH/bin/wineserver\"" >> "$WINEPREFIX/$Control/environmen.sh"
echo "export WINELOADER=\"$WINEPATH/bin/wine\"" >> "$WINEPREFIX/$Control/environmen.sh"
echo "export WINEDLLPATH=\"$WINEPATH/lib/wine/fakedlls:$WINEPATH/lib/i386-linux-gnu/wine:$WINEPATH/lib/wine\"" >> "$WINEPREFIX/$Control/environmen.sh"
echo "export PATH="\"$WINEPATH/bin\":\$PATH"" >> "$WINEPREFIX/$Control/environmen.sh"
echo "export WINEARCH=win32" >> "$WINEPREFIX/$Control/environmen.sh"
cp "$WINEPREFIX/$Control/environmen.sh" "$WINEPREFIX/$Control/winecfg.sh"
echo "env WINEPREFIX=\"$WINEPREFIX\" sh "\"$WINEPATH/bin/winecfg\""" >> "$WINEPREFIX/$Control/winecfg.sh"
chmod u+x "$WINEPREFIX/$Control/winecfg.sh"
cp "$WINEPREFIX/$Control/environmen.sh" "$WINEPREFIX/$Control/winetricks.sh"
echo "env WINEPREFIX=\"$WINEPREFIX\" sh "\"$WINEPATH/bin/winetricks\""" >> "$WINEPREFIX/$Control/winetricks.sh"
chmod u+x "$WINEPREFIX/$Control/winetricks.sh"
cp "$WINEPREFIX/$Control/environmen.sh" "$WINEPREFIX/$Control/regedit.sh"
echo "env WINEPREFIX=\"$WINEPREFIX\" sh "\"$WINEPATH/bin/regedit\""" >> "$WINEPREFIX/$Control/regedit.sh"
chmod u+x "$WINEPREFIX/$Control/regedit.sh"
cp "$WINEPREFIX/$Control/environmen.sh" "$WINEPREFIX/$Control/loader.sh"
echo "EXE=\`zenity --file-filter=\"All file|*.*\" --file-filter=\"Win32|*.bat *.exe *.msi\" --filename=\"$WINEPREFIX\"\/ --file-selection --title=\"Choose installation/launch file (for example: Game.exe)\"\`" >> "$WINEPREFIX/$Control/loader.sh"
echo "case \$? in" >> "$WINEPREFIX/$Control/loader.sh"
echo "0)" >> "$WINEPREFIX/$Control/loader.sh"
echo "env WINEPREFIX=\"$WINEPREFIX\" "\"$WINELOADER\"" start /unix \"\$EXE\" ;;" >> "$WINEPREFIX/$Control/loader.sh"
echo "1) exit ;;" >> "$WINEPREFIX/$Control/loader.sh"
echo "-1) exit ;;" >> "$WINEPREFIX/$Control/loader.sh"
echo "esac" >> "$WINEPREFIX/$Control/loader.sh"
chmod u+x "$WINEPREFIX/$Control/loader.sh"
##### Launcher code ####
cat > "$WINEPREFIX/$Control/createLauncher.sh" <<EOF
#!/bin/bash
USER=\$(whoami)
FOLDER="\$WINEPREFIX/$Control/loader.sh"
PREFIXPATH=\$(cat \$FOLDER |grep export\ WINEPREFIX|awk -F \" '{print \$2}')
WINELOADERPATH=\$(cat \$FOLDER|grep export\ WINELOADER|awk -F \" '{print \$2}')
EXE=\$(zenity --file-filter="All file|*.*" --file-filter="Win32|*.bat *.exe *.msi" --filename="/home/\$USER"\/ --file-selection --title="Choose executable file (for example: Game.exe)")
EXEPATH="\$(dirname "\$EXE")"
EXENAME="\$(basename "\$EXE")"
cat \$FOLDER |sed -ne '/#/,/WINEARCH/p' > "\$EXEPATH"/"\$EXENAME".sh
echo "env WINEPREFIX=\""\$PREFIXPATH"\" \""\$WINELOADERPATH"\" start /unix \""\$EXE"\"" >> "\$EXEPATH"/"\$EXENAME".sh
chmod +x "\$EXEPATH"/"\$EXENAME".sh
if [ -n "\$EXE" ]; then
  zenity --info --text="Launcher created: \$EXE.sh"
else
  exit 0
fi
EOF
chmod u+x "$WINEPREFIX/$Control/createLauncher.sh"
#####END################
zenity --width=800 --height=240 \
--question \
--title="Choose additional components to install in $WINEPREFIX" \
--text="\nTo install additional software/libs with \"Winetricks\" - press YES.\n \nInternet connection required.\n \nClose \"Winetricks\" when installation finished.\n \nIf installation not required - press NO."
case $? in
        0)
          env WINEPREFIX="$WINEPREFIX" sh "$WINEPATH/bin/winetricks";;
        1)
          echo "";;
       -1) 
          exit;;
esac
zenity --width=300 --height=140 \
--question \
--title="Make a choice" \
--text="Do you want to run your application now ?"
case $? in
        0)
           EXE=`zenity --file-selection \
           --filename="$HOME"\/ \
           --title="Choose installation/launch file (for example: Game.exe)" \
           --file-filter="All file|*.*" \
           --file-filter="Win32|*.bat *.exe *.msi"`
             case $? in
                     0)
                       echo "" ;;
                     1)         
                       exit;;
                     -1)          
                       exit;;
             esac
           env WINEPREFIX="$WINEPREFIX" "$WINELOADER" start /unix "$EXE"
           echo "exe = $EXE"
           sleep 1
           exit ;;
        1)
          zenity --width=300 --height=140 \
          --question \
          --title="Create launcher" \
          --text="Do you want to create Launcher for your application ?"
            case $? in
                    0)
                      sh "$WINEPREFIX/$Control/createLauncher.sh";;                    
                    1)
                      exit ;;
                    -1)
                      exit ;;
            esac       
esac


