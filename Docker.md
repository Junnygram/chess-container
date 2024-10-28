1. Clone the Repository

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

![Screenshot 2024-10-27 at 14 05 32](https://github.com/user-attachments/assets/370d118c-1723-4a72-890a-4e696fc643c9)

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

![Screenshot 2024-10-27 at 12 34 16](https://github.com/user-attachments/assets/d4a862f3-566d-4dbe-92bf-8125e4ce50be)

## Building and Running the Docker Image

### 1. Build the Docker Image

Build the Docker image using the Dockerfile:

```bash
docker build -t chess-app .
```

![Screenshot 2024-10-27 at 12 37 21](https://github.com/user-attachments/assets/7af0fba7-f4d4-427e-848d-cf52cff1bdce)

### 2. Run the Docker Image

Run the Docker container in detached mode, mapping port 80 on your local machine to port 80 in the container:

```bash
docker run -d -p 80:80 chess-app
```

![Screenshot 2024-10-27 at 12 44 10](https://github.com/user-attachments/assets/a3cbf4fe-908d-4a0c-a5d2-e89879f40149)

Now, the app should be accessible at `http://localhost:80` from the Docker container.

You should now have both the local development server running at `http://localhost:3000` and the containerized app running at `http://localhost:80`.

---

![Screenshot 2024-10-27 at 12 44 48](https://github.com/user-attachments/assets/c7ab3973-3f77-4b2b-9eb5-8ef1cbd42314)

To tag and push your Docker image to Docker Hub, follow these steps:

### Step 1: Create a Repository on Docker Hub

1. Log in to your Docker Hub account.
2. Click on "Create Repository."
   ![Screenshot 2024-10-27 at 12 55 26](https://github.com/user-attachments/assets/924ed0ae-620c-48a9-b36c-90681c530220)###
3. Fill in the repository name (e.g., `chess-app`), description, and visibility settings (public or private).
   ![Screenshot 2024-10-27 at 12 55 09](https://github.com/user-attachments/assets/9327dee4-f9ef-44a2-b8a8-cfbba08b06b1)

![Screenshot 2024-10-27 at 12 55 26](https://github.com/user-attachments/assets/d29c2342-62ea-4990-8a6f-21172b2ec929)

4. Click "Create" to finalize.

### Step 2: Authenticate to Docker Hub

If you aren't authenticated, log in via the command line:

```bash
docker login
```

You'll be prompted to enter your Docker Hub username and password.

### Step 3: Tag the Image

Use the following command to tag your image:

```bash
docker tag chess-app:latest junny27/chess-app:latest
```

![Screenshot 2024-10-27 at 13 02 54](https://github.com/user-attachments/assets/2f5f4d89-24f5-4682-9f95-3ca641f48ab9)

### Step 4: Push the Image to Docker Hub

Finally, push the tagged image to your Docker Hub repository:

```bash
docker push junny27/chess-app:latest
```

![Screenshot 2024-10-27 at 13 03 26](https://github.com/user-attachments/assets/f646127d-5d39-4793-aa9c-46b921e8385c)

After completing these steps, your image should be available on Docker Hub for deployment in other environments.

Congratulations! We've successfully containerized the application, run it both locally and in a Docker container, and pushed the image to Docker Hub.

Now lets stop our image running in the background.

### Step 1: Find the Container ID

List all running containers to find the ID:

```bash
docker ps
```

This will display a list of running containers, along with their IDs and other details.

### Step 2: Stop the Container

Once you have the container ID from the list, stop the container using:

```bash
docker stop <container_id>
```

Replace `<container_id>` with the actual ID you found. If you have any more questions or need further assistance, let me know!
![Screenshot 2024-10-27 at 13 51 19](https://github.com/user-attachments/assets/6e74c33b-9c0d-436c-b3da-66085092eb90)



 Now lets continue with CI/CD implemenation  [here](https://github.com/Junnygram/chess-container/blob/main/cicd.md).

