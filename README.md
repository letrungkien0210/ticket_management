# Ticket Management System

Customer Information Management + QR Code Check-in Demo Software

## 🎯 Project Overview

This is a comprehensive full-stack web application for managing customer information and event check-ins using QR codes. The system provides two independent modules with separate authentication systems:

- **Admin Module**: Event and customer management with QR code check-in functionality
- **Customer Module**: Event browsing, ticket purchasing, and personal account management

## 🏗️ Architecture

- **Frontend**: Next.js with TypeScript and Material-UI (MUI)
- **Backend**: Node.js with Express.js and TypeScript
- **Database**: MongoDB with Mongoose ODM
- **Containerization**: Docker and Docker Compose
- **Package Management**: pnpm with Monorepo structure

## 📁 Project Structure

```
ticket-management/
├── packages/
│   ├── backend/                # Node.js API server
│   │   ├── src/
│   │   │   └── index.ts       # Express server entry point
│   │   ├── package.json
│   │   ├── tsconfig.json
│   │   ├── Dockerfile
│   │   └── env.example
│   └── frontend/              # Next.js application
│       └── package.json
├── scripts/
│   └── mongo-init.js         # MongoDB initialization
├── documents/
│   └── ticket_management.md  # Project specification
├── docker-compose.yml        # Container orchestration
├── pnpm-workspace.yaml      # Monorepo configuration
├── package.json             # Root package configuration
├── .eslintrc.json          # ESLint configuration
├── .prettierrc             # Prettier configuration
├── .gitignore
└── README.md
```

## 🚀 Quick Start

### Prerequisites

Before you begin, ensure you have the following installed on your system:

#### 1. Node.js (>= 18.0.0)

**macOS:**
```bash
# Using Homebrew
brew install node

# Or download from official website
# https://nodejs.org/
```

**Windows:**
```bash
# Using Chocolatey
choco install nodejs

# Using Winget
winget install OpenJS.NodeJS

# Or download from official website
# https://nodejs.org/
```

**Linux (Ubuntu/Debian):**
```bash
# Using NodeSource repository
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Or using snap
sudo snap install node --classic
```

**Verify installation:**
```bash
node --version
npm --version
```

#### 2. pnpm (>= 8.0.0)

**Method 1 - Using npm (Recommended):**
```bash
npm install -g pnpm
```

**Method 2 - Using corepack (Node.js 16.13+):**
```bash
corepack enable
corepack prepare pnpm@latest --activate
```

**Method 3 - Using Homebrew (macOS):**
```bash
brew install pnpm
```

**Method 4 - Using PowerShell (Windows):**
```powershell
iwr https://get.pnpm.io/install.ps1 -useb | iex
```

**Method 5 - Using curl (Linux/macOS):**
```bash
curl -fsSL https://get.pnpm.io/install.sh | sh -
```

**Verify installation:**
```bash
pnpm --version
```

#### 3. Docker and Docker Compose (Optional but Recommended)

**macOS:**
```bash
# Install Docker Desktop
brew install --cask docker

# Or download from: https://docs.docker.com/desktop/mac/install/
```

**Windows:**
```bash
# Install Docker Desktop
winget install Docker.DockerDesktop

# Or download from: https://docs.docker.com/desktop/windows/install/
```

**Linux (Ubuntu/Debian):**
```bash
# Install Docker
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker
```

**Verify installation:**
```bash
docker --version
docker compose version
```

#### 4. Git
```bash
# macOS
brew install git

# Windows
winget install Git.Git

# Linux (Ubuntu/Debian)
sudo apt-get install git
```

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/letrungkien0210/ticket-management.git
   cd ticket-management
   ```

2. **Install dependencies**
   ```bash
   # Install all dependencies for both backend and frontend
   pnpm install
   
   # Alternative: Install each package separately
   # pnpm install --filter @ticket-management/backend
   # pnpm install --filter @ticket-management/frontend
   ```

3. **Set up environment variables**
   ```bash
   # Copy the example environment file
   cp packages/backend/env.example packages/backend/.env
   
   # Edit the .env file with your configuration
   # You can use any text editor, for example:
   nano packages/backend/.env
   # or
   code packages/backend/.env
   ```

   **Environment Variables Explanation:**
   ```env
   # Server Configuration
   PORT=5000                    # Backend server port
   NODE_ENV=development         # Environment (development/production)
   
   # Database
   MONGODB_URI=mongodb://localhost:27017/ticket_management  # MongoDB connection string
   
   # Frontend URL for CORS
   FRONTEND_URL=http://localhost:3000  # Frontend application URL
   
   # JWT Configuration
   JWT_SECRET=your-super-secret-jwt-key-change-this  # Change this to a secure secret
   JWT_EXPIRES_IN=7d            # Token expiration time
   
   # Admin Default Credentials (for seeding)
   ADMIN_USERNAME=admin
   ADMIN_PASSWORD=admin123
   ADMIN_EMAIL=letrungkien0210@gmail.com
   ```

4. **Choose your startup method:**

   **Option A: Start with Docker (Recommended for beginners)**
   ```bash
   # Start all services (MongoDB, Backend, Frontend)
   pnpm run docker:up
   
   # View logs in real-time
   pnpm run docker:logs
   
   # Stop all services when done
   pnpm run docker:down
   ```

   **Option B: Start manually for development**
   ```bash
   # Method 1: Start all services simultaneously
   pnpm run dev
   
   # Method 2: Start services individually (in separate terminals)
   # Terminal 1: Start backend
   pnpm run dev:backend
   
   # Terminal 2: Start frontend
   pnpm run dev:frontend
   
   # Note: You'll need MongoDB running locally for this method
   # Install MongoDB: https://docs.mongodb.com/manual/installation/
   ```

### Access the Application

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:5001
- **Health Check**: http://localhost:5001/health
- **API Documentation**: http://localhost:5001/api
- **MongoDB**: localhost:27017 (if running locally)

### Default Admin Credentials

- **Username**: `admin`
- **Password**: `admin123`
- **Email**: `letrungkien0210@gmail.com`

## 🛠️ Development Environment Setup

### Development Workflow

For active development, follow these steps to set up your development environment:

#### Option 1: Docker Development (Recommended)

```bash
# 1. Start development services
pnpm run docker:up

# 2. View logs (optional)
pnpm run docker:logs

# 3. Develop with hot reload
# Both backend and frontend will automatically reload on file changes

# 4. Access services
# Frontend: http://localhost:3000 (hot reload enabled)
# Backend: http://localhost:5001 (hot reload enabled)
# MongoDB: localhost:27017

# 5. Stop services when done
pnpm run docker:down
```

#### Option 2: Manual Development

```bash
# 1. Start MongoDB (choose one)
# Using Docker
docker run -d -p 27017:27017 --name mongodb mongo:7.0

# Or using local MongoDB installation
# brew services start mongodb/brew/mongodb-community
# sudo systemctl start mongod

# 2. Start backend (Terminal 1)
cd packages/backend
cp env.example .env
# Edit .env file with your settings
pnpm run dev

# 3. Start frontend (Terminal 2)
cd packages/frontend
pnpm run dev

# 4. Access services
# Frontend: http://localhost:3000
# Backend: http://localhost:5001
```

### Development Environment Configuration

#### Backend Development (.env)
```env
NODE_ENV=development
PORT=5000
MONGODB_URI=mongodb://localhost:27017/ticket_management_dev
FRONTEND_URL=http://localhost:3000
JWT_SECRET=development-secret-key
JWT_EXPIRES_IN=7d
```

#### Frontend Development
```env
# packages/frontend/.env.local
NEXT_PUBLIC_API_URL=http://localhost:5001
NEXT_PUBLIC_ENV=development
```

### Development Best Practices

1. **Code Quality**
   ```bash
   # Run linting
   pnpm run lint
   
   # Fix linting issues automatically
   pnpm run lint:fix
   
   # Type checking
   pnpm run type-check
   ```

2. **Development Scripts**
   ```bash
   # Watch mode for backend
   pnpm run dev:backend     # Auto-restart on changes
   
   # Watch mode for frontend
   pnpm run dev:frontend    # Hot reload enabled
   
   # Build and test
   pnpm run build:backend   # Test TypeScript compilation
   pnpm run build:frontend  # Test Next.js build
   ```

3. **Database Development**
   ```bash
   # Access MongoDB shell (if using Docker)
   docker exec -it ticket-management-mongodb mongosh
   
   # View database
   use ticket_management
   show collections
   
   # Reset database (development only)
   docker-compose down -v
   docker-compose up -d
   ```

## 🚀 Production Environment Setup

### Production Deployment Options

#### Option 1: Docker Production Deployment

1. **Prepare Production Environment**
   ```bash
   # Create production environment file
   cp packages/backend/env.example packages/backend/.env.production
   ```

2. **Configure Production Environment**
   ```env
   # packages/backend/.env.production
   NODE_ENV=production
   PORT=5000
   MONGODB_URI=mongodb://your-production-db:27017/ticket_management
   FRONTEND_URL=https://your-domain.com
   JWT_SECRET=your-super-secure-production-secret
   JWT_EXPIRES_IN=7d
   ```

3. **Build Production Images**
   ```bash
   # Build all services for production
   docker-compose -f docker-compose.prod.yml build
   
   # Or build individual services
   docker build -t ticket-management-backend ./packages/backend
   docker build -t ticket-management-frontend ./packages/frontend
   ```

4. **Deploy with Production Compose**
   ```bash
   # Start production services
   docker-compose -f docker-compose.prod.yml up -d
   
   # View production logs
   docker-compose -f docker-compose.prod.yml logs -f
   
   # Scale services (if needed)
   docker-compose -f docker-compose.prod.yml up -d --scale backend=3
   ```

#### Option 2: Manual Production Deployment

1. **Prepare Production Server**
   ```bash
   # Install Node.js 18+ and pnpm on production server
   curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
   sudo apt-get install -y nodejs
   npm install -g pnpm pm2
   ```

2. **Deploy Backend**
   ```bash
   # Build backend
   cd packages/backend
   pnpm install --prod
   pnpm run build
   
   # Start with PM2
   pm2 start dist/index.js --name "ticket-backend"
   pm2 save
   pm2 startup
   ```

3. **Deploy Frontend**
   ```bash
   # Build frontend
   cd packages/frontend
   pnpm install
   pnpm run build
   
   # Start with PM2
   pm2 start npm --name "ticket-frontend" -- start
   ```

4. **Setup Reverse Proxy (Nginx)**
   ```nginx
   # /etc/nginx/sites-available/ticket-management
   server {
       listen 80;
       server_name your-domain.com;
       
       # Frontend
       location / {
           proxy_pass http://localhost:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
       
       # Backend API
       location /api {
           proxy_pass http://localhost:5001;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

### Production Environment Configuration

#### Production Docker Compose
Create `docker-compose.prod.yml`:
```yaml
version: '3.8'

services:
  mongodb:
    image: mongo:7.0
    restart: always
    environment:
      MONGO_INITDB_ROOT_USERNAME: ${MONGO_ROOT_USERNAME}
      MONGO_INITDB_ROOT_PASSWORD: ${MONGO_ROOT_PASSWORD}
    volumes:
      - mongodb_prod_data:/data/db
    networks:
      - prod-network

  backend:
    build:
      context: ./packages/backend
      dockerfile: Dockerfile
    restart: always
    environment:
      NODE_ENV: production
      MONGODB_URI: mongodb://${MONGO_ROOT_USERNAME}:${MONGO_ROOT_PASSWORD}@mongodb:27017/ticket_management?authSource=admin
    depends_on:
      - mongodb
    networks:
      - prod-network

  frontend:
    build:
      context: ./packages/frontend
      dockerfile: Dockerfile
    restart: always
    environment:
      NODE_ENV: production
    depends_on:
      - backend
    ports:
      - "80:3000"
    networks:
      - prod-network

volumes:
  mongodb_prod_data:

networks:
  prod-network:
    driver: bridge
```

#### Production Security Checklist

1. **Environment Security**
   - [ ] Use strong JWT secrets (32+ characters)
   - [ ] Set secure CORS origins
   - [ ] Enable HTTPS/SSL certificates
   - [ ] Configure firewall rules
   - [ ] Use environment-specific databases

2. **Database Security**
   - [ ] Enable MongoDB authentication
   - [ ] Create database-specific users
   - [ ] Enable SSL/TLS for database connections
   - [ ] Regular database backups

3. **Application Security**
   - [ ] Update all dependencies
   - [ ] Enable rate limiting
   - [ ] Configure proper logging
   - [ ] Set up monitoring and alerts

### Production Deployment Scripts

Create `scripts/deploy.sh`:
```bash
#!/bin/bash
set -e

echo "🚀 Starting production deployment..."

# Pull latest code
git pull origin main

# Install dependencies
pnpm install

# Run tests
pnpm run test

# Build applications
pnpm run build

# Deploy with Docker
docker-compose -f docker-compose.prod.yml down
docker-compose -f docker-compose.prod.yml build --no-cache
docker-compose -f docker-compose.prod.yml up -d

echo "✅ Deployment completed successfully!"
```

### Production Monitoring

1. **Health Checks**
   ```bash
   # Check service health
   curl -f http://your-domain.com/health || exit 1
   
   # Check database connection
   docker exec mongodb mongosh --eval "db.adminCommand('ping')"
   ```

2. **Log Monitoring**
   ```bash
   # View application logs
   docker-compose -f docker-compose.prod.yml logs -f --tail=100
   
   # Monitor specific service
   docker-compose -f docker-compose.prod.yml logs -f backend
   ```

3. **Performance Monitoring**
   ```bash
   # Resource usage
   docker stats
   
   # Database metrics
   docker exec mongodb mongosh --eval "db.stats()"
   ```

### Troubleshooting

**Common Issues:**

1. **pnpm command not found**
   ```bash
   # Install pnpm globally
   npm install -g pnpm
   # Then restart your terminal
   ```

2. **Permission denied errors (Linux/macOS)**
   ```bash
   # For Docker
   sudo usermod -aG docker $USER
   newgrp docker
   
   # For pnpm global installation
   mkdir ~/.pnpm-global
   pnpm config set global-dir ~/.pnpm-global
   export PATH=~/.pnpm-global:$PATH
   ```

3. **Port already in use**
   ```bash
   # Find and kill process using port 3000 or 5000
   lsof -ti:3000 | xargs kill -9
   lsof -ti:5000 | xargs kill -9
   ```

4. **MongoDB connection issues**
   ```bash
   # Check if MongoDB is running
   docker ps
   # or if running locally
   brew services list | grep mongodb
   ```

## 📋 Available Scripts

### Root Level Scripts

```bash
# Development
pnpm run dev                 # Start both backend and frontend
pnpm run dev:backend         # Start only backend
pnpm run dev:frontend        # Start only frontend

# Production Build
pnpm run build              # Build both packages
pnpm run build:backend      # Build only backend
pnpm run build:frontend     # Build only frontend

# Production Start
pnpm run start              # Start both packages in production
pnpm run start:backend      # Start only backend in production
pnpm run start:frontend     # Start only frontend in production

# Code Quality
pnpm run lint               # Lint all packages
pnpm run lint:fix           # Fix linting issues
pnpm run type-check         # TypeScript type checking

# Docker
pnpm run docker:up          # Start all services with Docker
pnpm run docker:down        # Stop all Docker services
pnpm run docker:build       # Build Docker images
pnpm run docker:logs        # View Docker logs

# Maintenance
pnpm run clean              # Clean all build artifacts and node_modules
pnpm install:all           # Reinstall all dependencies
```

## 📊 Database Schema

### Collections

- **admins**: Admin user accounts and authentication
- **customers**: Customer accounts (email-based login)
- **events**: Event information with ticket limits
- **tickets**: Ticket records with QR codes and check-in status

### Key Relationships

- Tickets reference both Customers and Events
- Check-in records link Tickets to Admins
- Unique constraints prevent duplicate tickets per customer/event

## 🐳 Docker Configuration

The project includes comprehensive Docker setup:

- **MongoDB**: Official MongoDB 7.0 image with initialization script
- **Backend**: Multi-stage build for optimized production image
- **Frontend**: Development container with hot reload support
- **Networking**: Custom Docker network for service communication

## 🔒 Security Features

- JWT-based authentication for both admin and customer modules
- Password hashing with bcrypt
- Rate limiting to prevent abuse
- CORS configuration for frontend integration
- Input validation and sanitization
- MongoDB injection protection

## 📝 Environment Variables

### Backend Configuration

```env
# Server
PORT=5000
NODE_ENV=development

# Database
MONGODB_URI=mongodb://localhost:27017/ticket_management

# Security
JWT_SECRET=your-super-secret-jwt-key
JWT_EXPIRES_IN=7d

# CORS
FRONTEND_URL=http://localhost:3000
```

## 🧪 Testing

```bash
# Run tests for all packages
pnpm run test

# Run tests for specific package
pnpm run --filter @ticket-management/backend test
pnpm run --filter @ticket-management/frontend test
```

## 📈 Next Steps

1. **Backend Models**: Implement Mongoose schemas and repository patterns
2. **API Endpoints**: Build comprehensive REST API
3. **Frontend Components**: Create Material-UI based interfaces
4. **Authentication**: Implement JWT-based auth flows
5. **QR Code System**: Integrate QR generation and scanning
6. **Testing**: Add comprehensive test coverage

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support, email letrungkien0210@gmail.com or create an issue in the repository.

---

**Built with ❤️ using modern web technologies**