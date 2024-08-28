
## Setting Up Docker and Building a Chess App Container

In this section, we'll explore how to clone a GitHub repository, build a Docker image, and push it to Docker Hub. This tutorial uses a simple chess application as an example to illustrate the process.

### Cloning the Repository

First, we updte the instnce then clone the chess application repository from GitHub:

```bash
sudo apt update -y
git clone https://github.com/felerticia/chess
```

This command downloads the repository to the instance, enabling you to work with the source code. After cloning, we navigate into the project directory:

```bash
cd chess
ls 
```
![Screenshot 2024-08-28 at 16 15 52](https://github.com/user-attachments/assets/53f56d0e-16c6-4e6d-8708-5a934ba6cc71)

### Creating a Dockerfile

Next, we create a `Dockerfile`, which contains instructions on how to build a Docker image for the chess application:

```bash
touch Dockerfile
nano Dockerfile
```
this is the instruction below 
```bash
# Use a Node.js base image
FROM node:18-alpine

# Set the working directory
WORKDIR /app

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose the port the app runs on
EXPOSE 3000

# Command to run the application
CMD ["npm", "start"]
```
![Screenshot 2024-08-28 at 16 24 41](https://github.com/user-attachments/assets/eb0a2829-2423-4d7d-b734-4e5fd26abadf)

 ctrl x y and enter to close nano editor 

In the `Dockerfile`, you'll typically define the base image, copy the necessary files, install dependencies, and specify the command to run the application.
now when we try to build 
now we build we dont have docker instaled 
```
docker build -t chess .
```

thisdidnt build because we dont have docker installed now we build and it might fails because we dont have docker instaled . So before building the image, ensure that Docker is installed on your machine. If it's not, you can install it using the following script:

```bash
curl -O https://raw.githubusercontent.com/Junnygram/installation_scripts/master/docker.sh
./docker.sh
docker --version
```

After verifying the Docker installation, you can build the Docker image:

```bash
docker build -t chess .
```

This command might take some time as Docker pulls the base image and installs dependencies. The `-t` flag tags the image with the name `chess`.

### Running the Container

Once the image is built, you can run it using:

```bash
docker run -d -p 3000:3000 chess
```

This maps port 3000 of the container to port 3000 on your local machine, allowing you to access the chess application through `http://localhost:3000`. The `-d` is to  run the container in the background (detached mode), this allows us to perform other operation in the terminal while its running in the background.

Now when we run the comand below, this will list all currently running containers
```bash
docker ps
```
we will get the below 

![Screenshot 2024-08-28 at 16 32 11](https://github.com/user-attachments/assets/4556d8fa-024b-47aa-aa42-a7ff1d4d63bf)


to stop, we can run below with the container ID, it can be start stop restart 
```
docker stop 32a6204355de
```


now we we need to open security group to see our app on the browser, follow the image below 

![Screenshot 2024-08-28 at 16 32 56](https://github.com/user-attachments/assets/3c5bf851-f894-4df1-a2a7-c1b9c0f62445)

![Screenshot 2024-08-28 at 16 41 00](https://github.com/user-attachments/assets/e4c5ec44-f5b1-4260-b6d4-e14401addb6f)

![Screenshot 2024-08-28 at 16 43 44](https://github.com/user-attachments/assets/0535741c-91b4-432d-927c-510b98191c57)



### Docker Hub: Tagging and Pushing the Image

To share your Docker image, you need to push it to Docker Hub. First, log in to Docker Hub:


```bash
docker login
```
login, provide your username and password, .. the create a repository on the gui 
Next, tag the image so Docker knows where to push it:

```bash
docker tag chess junny27/chess:latest
```

Finally, push the image to your Docker Hub repository:

```bash
docker push junny27/chess:latest
```

### Deploying on AWS EC2

![Screenshot 2024-08-28 at 16 45 00](https://github.com/user-attachments/assets/c581eb6e-a14b-4cdc-bd57-93d6d88b467a)

Make sure the security group attached to the instance allows inbound traffic on port 3000 from your IP or any IP (`0.0.0.0/0`) for public access.

By following these steps, you'll have a live chess application running on your EC2 instance, accessible through the public IP address of your instance.

---

