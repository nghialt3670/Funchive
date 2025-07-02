# Funchive Microservices

This is the Funchive microservices application that provides function compilation and execution capabilities.

## Services

### Core Services
- **funchive-config-server**: Configuration management service
- **funchive-discovery-server**: Service discovery using Eureka
- **funchive-gateway-server**: API Gateway for routing requests
- **funchive-user-service**: User management service
- **funchive-function-service**: Function definition and management service
- **funchive-sandbox-service**: Function compilation and execution service (NEW)
- **funchive-web**: React frontend application

### Infrastructure
- **docker-dind**: Docker-in-Docker service for isolated container operations
- **funchive-function-mongodb**: MongoDB database for function service
- **funchive-sandbox-mongodb**: MongoDB database for sandbox service

## Recent Changes

### Sandbox Service Migration
The compilation and execution logic has been extracted from the `funchive-function-service` into a new dedicated `funchive-sandbox-service`. This separation provides:

- **Better scalability**: Sandbox operations can be scaled independently
- **Improved security**: Compilation and execution are isolated from function management
- **Resource optimization**: Heavy Docker operations don't impact function CRUD operations

### Migrated Components
The following components were moved from `funchive-function-service` to `funchive-sandbox-service`:

- `SandboxService` interface and implementations
- `DockerService` interface and implementations
- `ExecutableStorage` interface and implementations
- Docker sandbox strategies (Python, Java, HTTP)
- All Docker-related configuration and dependencies

## Running the Application

### Development
```bash
./run-dev.bat  # Windows
./run-dev.sh   # Linux/Mac
```

### Production
```bash
./run-prod.bat  # Windows
./run-prod.sh   # Linux/Mac
```

### QA
```bash
./run-qa.bat  # Windows
./run-qa.sh   # Linux/Mac
```

## Service Ports

- **Config Server**: 8888
- **Discovery Server**: 8761
- **User Service**: 8081
- **Function Service**: 8082
- **Sandbox Service**: 8083
- **Gateway Server**: 8080
- **Web Application**: 3000

## API Endpoints

### Sandbox Service
- `POST /api/sandbox/compile` - Compile a function
- `POST /api/sandbox/execute` - Execute a function

The function service now communicates with the sandbox service for compilation and execution operations.

## Configuration

Configuration files are managed through the config server and stored in the `funchive-config-repo` directory:

- `funchive-sandbox-service.yml` - Base configuration
- `funchive-sandbox-service-dev.yml` - Development configuration
- `funchive-sandbox-service-prod.yml` - Production configuration
- `funchive-sandbox-service-qa.yml` - QA configuration

## Dependencies

The sandbox service includes all necessary dependencies for Docker operations:
- Docker Java API
- MongoDB support for executable storage
- Spring Cloud integration
- WebSocket support for real-time logging 