#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

ACTION=${1:-start}
COMPOSE_FILES="-f docker-compose.yml -f docker-compose.qa.yml"

echo -e "${MAGENTA}Funchive QA Environment${NC}"
echo -e "${MAGENTA}=======================${NC}"
echo ""

case $ACTION in
    "stop")
        echo -e "${YELLOW}Stopping QA services...${NC}"
        docker-compose $COMPOSE_FILES down
        ;;
    "logs")
        echo -e "${CYAN}Showing logs for QA services...${NC}"
        docker-compose $COMPOSE_FILES logs -f
        ;;
    "status")
        echo -e "${CYAN}Checking status of QA services...${NC}"
        docker-compose $COMPOSE_FILES ps
        ;;
    "build")
        echo -e "${YELLOW}Building and starting QA services...${NC}"
        docker-compose $COMPOSE_FILES up --build -d
        ;;
    "restart")
        echo -e "${YELLOW}Restarting QA services...${NC}"
        docker-compose $COMPOSE_FILES restart
        ;;
    "start"|*)
        echo -e "${YELLOW}Starting QA services...${NC}"
        docker-compose $COMPOSE_FILES up -d
        ;;
esac

if [ "$ACTION" != "logs" ]; then
    echo ""
    echo -e "${MAGENTA}Available commands:${NC}"
    echo -e "  ${WHITE}./run-qa.sh start    - Start services (default)${NC}"
    echo -e "  ${WHITE}./run-qa.sh stop     - Stop services${NC}"
    echo -e "  ${WHITE}./run-qa.sh logs     - Show logs${NC}"
    echo -e "  ${WHITE}./run-qa.sh status   - Show status${NC}"
    echo -e "  ${WHITE}./run-qa.sh build    - Build and start services${NC}"
    echo -e "  ${WHITE}./run-qa.sh restart  - Restart services${NC}"
    echo ""
    echo -e "${MAGENTA}QA services will be available at:${NC}"
    echo -e "  ${CYAN}- Gateway: http://localhost:8080${NC}"
    echo -e "  ${CYAN}- Web App: http://localhost:3000${NC}"
fi 