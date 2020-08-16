#! /usr/bin/env bash

CONTAINER_NAME="dnd_chat"
SECRET_KEY_BASE=$(cat .secret-key-base)
source .secrets;

ssh $SERVER_URL <<EOSSH
docker stop $CONTAINER_NAME;
docker rm $CONTAINER_NAME;
docker pull nlincoln/dnd-chat:master;
docker run -d \
  --name $CONTAINER_NAME \
  -p 443:443 \
  -p 80:80 \
  -v /etc/letsencrypt/:/cert/ \
  -e DATABASE_URL=$DATABASE_URL \
  -e SECRET_KEY_BASE=$SECRET_KEY_BASE \
  -e SSL_CERT_FILE=/cert/live/dnd-chat.natelincoln.com/fullchain.pem \
  -e SSL_KEY_FILE=/cert/live/dnd-chat.natelincoln.com/privkey.pem \
  -e ADMIN_USER=$ADMIN_USER \
  -e ADMIN_PASSWORD=$ADMIN_PASSWORD \
  nlincoln/dnd-chat:master;
EOSSH;
