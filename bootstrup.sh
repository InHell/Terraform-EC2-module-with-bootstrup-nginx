this script must be located inside of APP folder.
script body : -----------------------------------
-------------------------------------------------
#! /bin/bash

#update distro start sccript

# install nginx of hardcoded version, delete default config, copy new config with redirect to local app thast listening port 3000 for example. 
sleep 30 &&
sudo apt update -y &>/dev/null ; sleep 30; sudo apt install -y nginx=1.18.0-6ubuntu14.3; sleep 20; sudo rm /etc/nginx/sites-enabled/default; sleep 1;sudo cp some-app-folder/new-ngins-confix /etc/nginx/sites-available/new-ngins-confix; sleep 1 &&


# copy file with some user credentials for JS to use it , by default .env by git ignore so we copy some txt file with it and justs copy with rename it to .env (instead in your configuration you can use global vars, etc)
#and enable new nginx config
sudo cp some-app-folder/vnetoenv /home/ubuntu/some-app-folder/.env; sleep 1; sudo ln -s /etc/nginx/sites-available/new-ngins-confix /etc/nginx/sites-enabled/new-ngins-confix; sleep 2 &&

#enable nginx as service, start nginx.
sudo systemctl enable nginx; sleep 4; sudo systemctl start nginx; sleep 4; echo "nginx started" ; sleep 1 &&
#install some debug tools if needed 
sudo apt install -y net-tools; sleep 2; sudo apt install -y mc; sleep 2; echo "DEbug tools installed" &&

#install node js + npm
cd ~
curl -sL https://deb.nodesource.com/setup_16.x | sudo bash -; sleep 2; sudo apt install nodejs -y --no-install-recommends; sleep 2; sudo apt install npm -y --no-install-recommends; sleep 2 &&
#install pnpm 7.1.3
#install app
sudo npm install pnpm@7.1.3 -g; sleep 2; cd env-status-tool/; sleep 1; sudo systemctl restart nginx; sleep 1; pnpm install; sleep 1; npm -v; pnpm -v; node -v; sleep 1 &&

# runing app at background and get information from net-stat -nltp about listening ports, if you see yours ports like 80 , 3000, thats meand ningx -ok , and APP - ok all running
setsid pnpm run APP &>/dev/null & sleep 20; netstat -nltp; sleep 1; echo "Script completted" &&

#complete script ok aftmer main step completed
exit 0


#certification
#==================================================================================
#sudo apt install -y letsencrypt &>/dev/null

#sudo systemctl status certbot.timer &>/dev/null

#sudo systemctl stop nginx
#sudo systemctl start nginx
#sudo certbot certonly --standalone --agree-tos --preferred-challenges http -d ss.drega.click -m  exwtff@gmail.com  --redirect
#certbot run -n --nginx --agree-tos -d ss.drega.click,ss.drega.click  -m  svyr@solvve.com  --redirect

#==================================================================================


