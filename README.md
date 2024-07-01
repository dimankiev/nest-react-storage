# Nest.js + React (Next.js) Storage App

This repository contains deployment scripts for web storage application built with Next.js for the frontend and NestJS for the backend, using Redis for session storage and Caddy as a reverse proxy.

## Prerequisites

Before you begin, ensure you have the following installed on your system:
- Docker
- Docker Compose
- Git

## Deployment Instructions

Follow these steps to deploy the application:

1. **Clone the Repository**

   ```bash
   git clone https://github.com/dimankiev/nest-react-storage
   cd nest-react-storage
   ```

2. **Set Up Environment Variables**

   Create a `.env` file in the root directory of the project with the following content:

   ```
   GOOGLE_CLIENT_ID=your_google_client_id_here
   GOOGLE_CLIENT_SECRET=your_google_client_secret_here
   ```

   Replace `your_google_client_id_here` and `your_google_client_secret_here` with your actual Google OAuth credentials.  
   See [Using OAuth 2.0 to Access Google APIs](https://developers.google.com/identity/protocols/oauth2) for more information.

4. **Configure Caddy**

   Ensure the `Caddyfile` is present in the root directory with the following content:

   ```
   {
     auto_https disable_certs
     http_port 8080
     https_port 8443
   }

   :8080 {
     @api-path path /api/*
     @gui-path not path /api/*
     reverse_proxy @api-path app_backend:3000
     reverse_proxy @gui-path app_frontend:8080
   }
   ```

   Feel free to modify this configuration, but don't forget to change docker-compose.yml as well (if you change network or ports)

5. **Build and Start the Application**
   For the first time you should use `deploy.sh` script, which will:
   1. Check if you have all the required files and utilities
   2. Clone frontend and backend repositories and ensure they're up-to-date
   3. Build images and deploy them in containers using `docker-compose`

   Run the following command to start all services next time:

   ```bash
   docker-compose up -d
   ```

   Or use this convenient `deploy.sh` script.

7. **Access the Application**

   Once the build process is complete and all containers are running, you can access the application:
   - Web Interface: `http://localhost:8080`
   - API Endpoint: `http://localhost:8080/api`
  
   This app is absolutely compatible with `ngrok` or `cloudflared` (Cloudflare Zero Trust tunnel)

## Troubleshooting

If you encounter any issues:

1. Ensure all required ports (8080, 8443) are available and not in use by other applications.
2. Check the Docker logs for any error messages:
   ```bash
   docker-compose logs
   ```
3. Verify that your `.env` file contains the correct Google OAuth credentials.
4. If you make changes to the environment variables, remember to rebuild the containers:
   ```bash
   docker-compose down
   docker-compose up -d --build
   ```

## Updating the Application

To update the application with the latest changes:

1. Pull the latest changes from the repository:
   ```bash
   git pull origin main
   ```
2. Rebuild and restart the containers:
   ```bash
   docker-compose down
   git pull
   cd frontend
   git pull
   cd ../
   cd backend
   git pull
   cd ../
   docker-compose up --build
   ```

## Security Notes

- The application uses HTTP on port 8080. For production use, configure proper SSL/TLS certificates.
- Ensure your Google OAuth credentials are kept secret and not shared publicly.
- Regularly update dependencies and Docker images to patch any security vulnerabilities.

## Support

If you encounter any issues or have questions, please open an issue in the GitHub repository or contact me.
