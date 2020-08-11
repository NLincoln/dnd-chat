source .secrets;

ssh $SERVER_URL <<EOSSH
sudo apt update;
sudo apt install software-properties-common;
sudo add-apt-repository universe;
sudo add-apt-repository ppa:certbot/certbot;
sudo apt update;

sudo apt install certbot;
EOSSH;
