#!/bin/bash

# Production Deployment Script for Ticket Management System
# Usage: ./scripts/deploy.sh [environment]
# Environment: staging, production (default: production)

set -e  # Exit on any error

# Configuration
ENVIRONMENT=${1:-production}
PROJECT_NAME="ticket-management"
BACKUP_DIR="./backups"
LOG_FILE="./deploy-$(date +%Y%m%d-%H%M%S).log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}" | tee -a "$LOG_FILE"
    exit 1
}

warning() {
    echo -e "${YELLOW}[WARNING] $1${NC}" | tee -a "$LOG_FILE"
}

success() {
    echo -e "${GREEN}[SUCCESS] $1${NC}" | tee -a "$LOG_FILE"
}

# Check prerequisites
check_prerequisites() {
    log "Checking prerequisites..."
    
    # Check if Docker is installed and running
    if ! command -v docker &> /dev/null; then
        error "Docker is not installed or not in PATH"
    fi
    
    if ! docker info &> /dev/null; then
        error "Docker daemon is not running"
    fi
    
    # Check if Docker Compose is available
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        error "Docker Compose is not installed"
    fi
    
    # Check if pnpm is installed
    if ! command -v pnpm &> /dev/null; then
        error "pnpm is not installed"
    fi
    
    # Check if environment file exists
    if [ ! -f ".env.${ENVIRONMENT}" ]; then
        warning "Environment file .env.${ENVIRONMENT} not found. Please create it from env.production.example"
    fi
    
    success "Prerequisites check completed"
}

# Create backup
create_backup() {
    log "Creating backup of current deployment..."
    
    mkdir -p "$BACKUP_DIR"
    BACKUP_NAME="${PROJECT_NAME}-backup-$(date +%Y%m%d-%H%M%S)"
    
    # Backup database if running
    if docker ps | grep -q "${PROJECT_NAME}-mongodb"; then
        log "Backing up database..."
        docker exec "${PROJECT_NAME}-mongodb-prod" mongodump --archive="/tmp/${BACKUP_NAME}-db.archive" || warning "Database backup failed"
        docker cp "${PROJECT_NAME}-mongodb-prod:/tmp/${BACKUP_NAME}-db.archive" "${BACKUP_DIR}/" || warning "Failed to copy database backup"
    fi
    
    # Backup environment files
    cp -r . "${BACKUP_DIR}/${BACKUP_NAME}-code" 2>/dev/null || warning "Code backup failed"
    
    success "Backup created: ${BACKUP_DIR}/${BACKUP_NAME}"
}

# Pre-deployment checks
pre_deployment_checks() {
    log "Running pre-deployment checks..."
    
    # Check if Git repository is clean
    if [ -d ".git" ]; then
        if [ -n "$(git status --porcelain)" ]; then
            warning "Git repository has uncommitted changes"
            read -p "Continue anyway? (y/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                error "Deployment cancelled"
            fi
        fi
    fi
    
    # Install dependencies
    log "Installing dependencies..."
    pnpm install --frozen-lockfile || error "Failed to install dependencies"
    
    # Run linting (if possible)
    log "Running code quality checks..."
    pnpm run lint --if-present || warning "Linting failed or not configured"
    
    # Run type checking
    pnpm run type-check --if-present || warning "Type checking failed or not configured"
    
    # Build applications to verify they compile
    log "Testing build process..."
    pnpm run build || error "Build process failed"
    
    success "Pre-deployment checks completed"
}

# Deploy application
deploy() {
    log "Starting deployment for environment: ${ENVIRONMENT}..."
    
    # Source environment variables
    if [ -f ".env.${ENVIRONMENT}" ]; then
        export $(cat ".env.${ENVIRONMENT}" | grep -v '^#' | xargs)
        log "Loaded environment variables from .env.${ENVIRONMENT}"
    fi
    
    # Stop existing services
    log "Stopping existing services..."
    docker-compose -f docker-compose.prod.yml down || warning "Failed to stop some services"
    
    # Remove old images (optional)
    log "Cleaning up old Docker images..."
    docker image prune -f || warning "Failed to clean up images"
    
    # Build new images
    log "Building new Docker images..."
    docker-compose -f docker-compose.prod.yml build --no-cache || error "Failed to build Docker images"
    
    # Start services
    log "Starting new services..."
    docker-compose -f docker-compose.prod.yml up -d || error "Failed to start services"
    
    success "Deployment completed"
}

# Post-deployment verification
post_deployment_verification() {
    log "Running post-deployment verification..."
    
    # Wait for services to start
    log "Waiting for services to start..."
    sleep 30
    
    # Check if all containers are running
    log "Checking container status..."
    if ! docker-compose -f docker-compose.prod.yml ps | grep -q "Up"; then
        error "Some containers are not running"
    fi
    
    # Health check for backend
    log "Checking backend health..."
    for i in {1..10}; do
        if curl -f http://localhost:5000/health &> /dev/null; then
            success "Backend is healthy"
            break
        fi
        if [ $i -eq 10 ]; then
            error "Backend health check failed after 10 attempts"
        fi
        log "Attempt $i/10: Backend not ready, waiting..."
        sleep 10
    done
    
    # Health check for frontend (if accessible)
    log "Checking frontend availability..."
    for i in {1..5}; do
        if curl -f http://localhost:3000 &> /dev/null; then
            success "Frontend is accessible"
            break
        fi
        if [ $i -eq 5 ]; then
            warning "Frontend accessibility check failed"
        fi
        log "Attempt $i/5: Frontend not ready, waiting..."
        sleep 10
    done
    
    # Check database connectivity
    log "Checking database connectivity..."
    if docker exec "${PROJECT_NAME}-mongodb-prod" mongosh --eval "db.adminCommand('ping')" &> /dev/null; then
        success "Database is accessible"
    else
        error "Database connectivity check failed"
    fi
    
    success "Post-deployment verification completed"
}

# Cleanup function
cleanup() {
    log "Cleaning up temporary files..."
    # Remove temporary files if any
    rm -f /tmp/deploy-*.tmp 2>/dev/null || true
    
    # Keep only last 5 backups
    if [ -d "$BACKUP_DIR" ]; then
        ls -t "$BACKUP_DIR" | tail -n +6 | xargs -I {} rm -rf "$BACKUP_DIR/{}" 2>/dev/null || true
    fi
    
    success "Cleanup completed"
}

# Main deployment function
main() {
    log "🚀 Starting ${PROJECT_NAME} deployment to ${ENVIRONMENT}..."
    
    # Trap to ensure cleanup on exit
    trap cleanup EXIT
    
    check_prerequisites
    create_backup
    pre_deployment_checks
    deploy
    post_deployment_verification
    
    success "🎉 Deployment completed successfully!"
    log "📊 Deployment summary:"
    log "  - Environment: ${ENVIRONMENT}"
    log "  - Log file: ${LOG_FILE}"
    log "  - Frontend: http://localhost:3000"
    log "  - Backend API: http://localhost:5000"
    log "  - Health Check: http://localhost:5000/health"
    
    # Show running containers
    log "📋 Running containers:"
    docker-compose -f docker-compose.prod.yml ps
}

# Help function
show_help() {
    echo "Usage: $0 [environment]"
    echo ""
    echo "Deploy the Ticket Management System to the specified environment."
    echo ""
    echo "Arguments:"
    echo "  environment    Target environment (staging, production). Default: production"
    echo ""
    echo "Examples:"
    echo "  $0              # Deploy to production"
    echo "  $0 staging      # Deploy to staging"
    echo "  $0 production   # Deploy to production"
    echo ""
    echo "Prerequisites:"
    echo "  - Docker and Docker Compose installed"
    echo "  - pnpm installed"
    echo "  - Environment file (.env.production or .env.staging)"
    echo ""
}

# Check if help is requested
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
    exit 0
fi

# Run main function
main 