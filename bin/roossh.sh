#!/bin/bash

usage(){
    echo "You need to provide a project as a parameter."
    echo -e "Available projects:\n${PROJECTS[@]}\n"
    echo -e "Usage:\n\tscript [project]\n"
    echo -e "Example:\n\tscript orderweb\n"
}

PROJECT=$1

PROJECTS=(orderweb direct-payments restaurant-payments rs-payments-rules-engine payments-ledger cashier rs-accounts)

# Colors
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'

if [ -z "$1" ]; then
    usage
    exit 1
fi

if [[ ! "${PROJECTS[@]}" =~ "${PROJECT}" ]]; then
    echo -e "🤔 I don't recognize that project, did you spell it correctly?\n"
    echo -e "Available projects: ${PROJECTS[@]}\n"
    exit 1
fi

echo -e "Which environment do you want to ssh into?\n"
echo -e "${YELLOW}s - staging\n${RED}p - production${NC}\n"
read -p "Your answer: " ANSWER

if [ "$ANSWER" == "p" ]; then
    echo -e "${RED}---------------------------------------------------${NC}"
    echo -e "🚨 You are about to ssh into $PROJECT ${RED}production${NC}.🚨"
    echo -e "${RED}---------------------------------------------------${NC}"
    ENVIRONMENT="production"
else
    echo -e "${YELLOW}-----------------------------------------------${NC}"
    echo -e "⚠ You are about to ssh into $PROJECT ${YELLOW}staging${NC}.⚠"
    echo -e "${YELLOW}-----------------------------------------------${NC}"
    ENVIRONMENT="staging"
fi

# read -p "Are you sure? Continue? [y/N]" CONTINUE

# if [ "$CONTINUE" == "y" ]; then
#     ssh-add ~/.ssh/id_rsa_deliveroo_ecs
# else
#     exit 1
# fi

if [ "$1" == "orderweb" ]; then
    HOPPER_CMD='web hopper-runner --allow-service-overrides bundle exec rails c'
elif [[ "$1" =~ ^(payments-ledger|cashier|rs-accounts)$ ]]; then
    HOPPER_CMD='web hopper-runner sh'
else
    HOPPER_CMD='web hopper-runner bundle exec rails c'
fi

ssh ecs@hopper-$ENVIRONMENT $PROJECT $HOPPER_CMD
