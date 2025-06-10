#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

ACTION=${1:-start}
COMPOSE_FILES="-f docker-compose.yml -f docker-compose.dev.yml"

echo -e "${GREEN}Funchive Development Environment${NC}"
echo -e "${GREEN}================================${NC}"
echo ""

case $ACTION in
    "stop")
        echo -e "${YELLOW}Stopping development services...${NC}"
        docker-compose $COMPOSE_FILES down
        ;;
    "logs")
        echo -e "${CYAN}Showing logs for development services...${NC}"
        docker-compose $COMPOSE_FILES logs -f
        ;;
    "status")
        echo -e "${CYAN}Checking status of development services...${NC}"
        docker-compose $COMPOSE_FILES ps
        ;;
    "build")
        echo -e "${YELLOW}Building and starting development services...${NC}"
        docker-compose $COMPOSE_FILES up --build -d
        ;;
    "restart")
        echo -e "${YELLOW}Restarting development services...${NC}"
        docker-compose $COMPOSE_FILES restart
        ;;
    "start"|*)
        echo -e "${YELLOW}Starting development services...${NC}"
        docker-compose $COMPOSE_FILES up -d
        ;;
esac

if [ "$ACTION" != "logs" ]; then
    echo ""
    echo -e "${GREEN}Available commands:${NC}"
    echo -e "  ${WHITE}./run-dev.sh start    - Start services (default)${NC}"
    echo -e "  ${WHITE}./run-dev.sh stop     - Stop services${NC}"
    echo -e "  ${WHITE}./run-dev.sh logs     - Show logs${NC}"
    echo -e "  ${WHITE}./run-dev.sh status   - Show status${NC}"
    echo -e "  ${WHITE}./run-dev.sh build    - Build and start services${NC}"
    echo -e "  ${WHITE}./run-dev.sh restart  - Restart services${NC}"
    echo ""
    echo -e "${GREEN}Development services will be available at:${NC}"
    echo -e "  ${CYAN}- Config Server: http://localhost:8888${NC}"
    echo -e "  ${CYAN}- Discovery Server: http://localhost:8761${NC}"
    echo -e "  ${CYAN}- User Service: http://localhost:8081${NC}"
    echo -e "  ${CYAN}- Function Service: http://localhost:8082${NC}"
    echo -e "  ${CYAN}- Gateway: http://localhost:8080${NC}"
    echo -e "  ${CYAN}- Web App: http://localhost:3000${NC}"
fi 