### 1. Clone the Repository

First, download the project code by cloning the repository:

```bash
git clone https://github.com/felerticia/chess.git
cd chess
```

### 2. Install Dependencies

Ensure that Node.js and npm are installed on your machine. Then, install the project dependencies:

```bash
npm install
```

### 3. Run the Development Server Locally

Start the React application to confirm that it runs as expected before containerizing it:

```bash
npm start
```

The app should now be accessible at `http://localhost:3000`. Open this URL in your browser to verify that it’s working.

---

## Containerizing the Application

To containerize the application, we will use a multi-stage Dockerfile to first build the React app and then serve it using Nginx. Nginx is ideal for production environments because it runs on port 80 by default and allows us to expose the app through one port, enhancing security.

### Dockerfile

Here's the Dockerfile for building and running the app in a container:

```Dockerfile
# Stage 1: Build the React app
FROM node:16-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files
COPY . .

# Build the React application
RUN npm run build

# Stage 2: Serve the React app
FROM nginx:alpine

# Copy the build files from the previous stage
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start the Nginx server
CMD ["nginx", "-g", "daemon off;"]
```

### Explanation

- **Stage 1**: Builds the React application. We use `node:16-alpine` as the base image for efficiency. The app is built and packaged within this stage.
- **Stage 2**: Uses `nginx:alpine` to serve the app on port 80, providing an optimized production environment.

---

## Building and Running the Docker Image

### 1. Build the Docker Image

Build the Docker image using the Dockerfile:

```bash
docker build -t chess-app .
```

### 2. Run the Docker Image

Run the Docker container in detached mode, mapping port 80 on your local machine to port 80 in the container:

```bash
docker run -d -p 80:80 chess-app
```

Now, the app should be accessible at `http://localhost:80` from the Docker container.

You should now have both the local development server running at `http://localhost:3000` and the containerized app running at `http://localhost:80`.

---

## Tagging and Pushing to Docker Hub

To make the image available for deployment in other environments, tag and push it to Docker Hub.

### 1. Tag the Image

```bash
docker tag chess-app:latest junny27/chess-app:latest
```

### 2. Push the Image to Docker Hub

Log in to Docker Hub if needed, then push the image:

```bash
docker push junny27/chess-app:latest

```

Congratulations! You've successfully containerized the application, run it both locally and in a Docker container, and pushed the image to Docker Hub.
