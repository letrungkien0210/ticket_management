#!/bin/bash

# Development Environment Setup Script for Ticket Management System
# Usage: ./scripts/dev-setup.sh [mode]
# Mode: docker, manual (default: docker)

set -e  # Exit on any error

# Configuration
MODE=${1:-docker}
PROJECT_NAME="ticket-management"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log() {
    echo -e "${BLUE}[$(date +'%H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}"
    exit 1
}

warning() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

success() {
    echo -e "${GREEN}[SUCCESS] $1${NC}"
}

# Check prerequisites
check_prerequisites() {
    log "Checking development prerequisites..."
    
    # Check Node.js version
    if ! command -v node &> /dev/null; then
        error "Node.js is not installed"
    fi
    
    NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VERSION" -lt 18 ]; then
        error "Node.js version 18 or higher is required. Current version: $(node --version)"
    fi
    
    # Check pnpm
    if ! command -v pnpm &> /dev/null; then
        error "pnpm is not installed. Install with: npm install -g pnpm"
    fi
    
    # Check Docker if using docker mode
    if [ "$MODE" = "docker" ]; then
        if ! command -v docker &> /dev/null; then
            error "Docker is not installed"
        fi
        
        if ! docker info &> /dev/null; then
            error "Docker daemon is not running"
        fi
        
        if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
            error "Docker Compose is not installed"
        fi
    fi
    
    success "Prerequisites check completed"
}

# Setup environment files
setup_environment() {
    log "Setting up environment files..."
    
    # Backend environment
    if [ ! -f "packages/backend/.env" ]; then
        log "Creating backend environment file..."
        cp packages/backend/env.example packages/backend/.env
        
        # Update with development settings
        sed -i '' 's/JWT_SECRET=nosecret/JWT_SECRET=development-secret-key-please-change-in-production/' packages/backend/.env
        sed -i '' 's/MONGODB_URI=mongodb:\/\/localhost:27017\/ticket_management/MONGODB_URI=mongodb:\/\/localhost:27017\/ticket_management_dev/' packages/backend/.env
        
        success "Backend environment file created"
    else
        log "Backend environment file already exists"
    fi
    
    # Frontend environment
    if [ ! -f "packages/frontend/.env.local" ]; then
        log "Creating frontend environment file..."
        cat > packages/frontend/.env.local << EOF
# Frontend Development Environment
NEXT_PUBLIC_API_URL=http://localhost:5000
NEXT_PUBLIC_ENV=development
EOF
        success "Frontend environment file created"
    else
        log "Frontend environment file already exists"
    fi
}

# Install dependencies
install_dependencies() {
    log "Installing project dependencies..."
    
    # Install root dependencies
    pnpm install || error "Failed to install root dependencies"
    
    success "Dependencies installed successfully"
}

# Setup Docker development
setup_docker_dev() {
    log "Setting up Docker development environment..."
    
    # Stop any existing containers
    docker-compose down 2>/dev/null || true
    
    # Start development services
    log "Starting development services with Docker..."
    pnpm run docker:up || error "Failed to start Docker services"
    
    # Wait for services to be ready
    log "Waiting for services to start..."
    sleep 15
    
    # Check if services are running
    if ! docker ps | grep -q "${PROJECT_NAME}"; then
        error "Docker services failed to start"
    fi
    
    success "Docker development environment is ready!"
    log "🚀 Services running:"
    log "  - Frontend: http://localhost:3000"
    log "  - Backend API: http://localhost:5000"
    log "  - Health Check: http://localhost:5000/health"
    log "  - MongoDB: localhost:27017"
}

# Setup manual development
setup_manual_dev() {
    log "Setting up manual development environment..."
    
    # Check if MongoDB is available
    if ! command -v mongod &> /dev/null && ! docker ps | grep -q mongo; then
        log "MongoDB not found. Starting MongoDB with Docker..."
        docker run -d -p 27017:27017 --name mongodb-dev mongo:7.0 || warning "Failed to start MongoDB container"
    fi
    
    # Build backend
    log "Building backend..."
    pnpm run build:backend || error "Backend build failed"
    
    success "Manual development environment is ready!"
    log "🚀 To start development:"
    log "  1. Terminal 1: pnpm run dev:backend"
    log "  2. Terminal 2: pnpm run dev:frontend"
    log ""
    log "📋 Services will be available at:"
    log "  - Frontend: http://localhost:3000"
    log "  - Backend API: http://localhost:5000"
    log "  - Health Check: http://localhost:5000/health"
}

# Run initial verification
verify_setup() {
    log "Verifying development setup..."
    
    if [ "$MODE" = "docker" ]; then
        # Check Docker services
        if curl -f http://localhost:5000/health &> /dev/null; then
            success "Backend is healthy"
        else
            warning "Backend health check failed"
        fi
        
        if curl -f http://localhost:3000 &> /dev/null; then
            success "Frontend is accessible"
        else
            warning "Frontend not accessible yet (may still be starting)"
        fi
    else
        # For manual setup, just check if MongoDB is reachable
        if docker ps | grep -q mongo || netstat -an | grep -q :27017; then
            success "MongoDB is accessible"
        else
            warning "MongoDB may not be running"
        fi
    fi
    
    success "Setup verification completed"
}

# Show development tips
show_dev_tips() {
    log "📝 Development Tips:"
    echo ""
    echo "🔧 Useful Commands:"
    echo "  pnpm run dev                 # Start both backend and frontend"
    echo "  pnpm run dev:backend         # Start only backend"
    echo "  pnpm run dev:frontend        # Start only frontend"
    echo "  pnpm run lint                # Run linting"
    echo "  pnpm run lint:fix            # Fix linting issues"
    echo "  pnpm run type-check          # TypeScript type checking"
    echo "  pnpm run build               # Build both packages"
    echo ""
    echo "🐳 Docker Commands:"
    echo "  pnpm run docker:up           # Start all services"
    echo "  pnpm run docker:down         # Stop all services"
    echo "  pnpm run docker:logs         # View service logs"
    echo ""
    echo "🗄️ Database Commands:"
    echo "  docker exec -it ticket-management-mongodb mongosh"
    echo "  # Access MongoDB shell"
    echo ""
    echo "🔍 Monitoring:"
    echo "  docker ps                    # Check running containers"
    echo "  docker logs <container>      # View container logs"
    echo ""
    echo "📚 Documentation:"
    echo "  - API Health: http://localhost:5000/health"
    echo "  - API Info: http://localhost:5000/api"
    echo ""
}

# Help function
show_help() {
    echo "Usage: $0 [mode]"
    echo ""
    echo "Set up the development environment for Ticket Management System."
    echo ""
    echo "Arguments:"
    echo "  mode    Development mode (docker, manual). Default: docker"
    echo ""
    echo "Examples:"
    echo "  $0          # Setup with Docker (recommended)"
    echo "  $0 docker   # Setup with Docker"
    echo "  $0 manual   # Setup for manual development"
    echo ""
    echo "Prerequisites:"
    echo "  - Node.js 18+"
    echo "  - pnpm"
    echo "  - Docker (for docker mode)"
    echo ""
}

# Main function
main() {
    echo "🚀 Setting up ${PROJECT_NAME} development environment..."
    echo "Mode: ${MODE}"
    echo ""
    
    check_prerequisites
    setup_environment
    install_dependencies
    
    if [ "$MODE" = "docker" ]; then
        setup_docker_dev
    else
        setup_manual_dev
    fi
    
    verify_setup
    show_dev_tips
    
    success "🎉 Development environment setup completed!"
}

# Check if help is requested
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
    exit 0
fi

# Validate mode
if [ "$MODE" != "docker" ] && [ "$MODE" != "manual" ]; then
    error "Invalid mode: $MODE. Use 'docker' or 'manual'"
fi

# Run main function
main 