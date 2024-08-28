**Docker and Kubernetes: Why and How**

### Why Use Docker and Kubernetes?

**Docker**:
1. **Consistency Across Environments**: Docker allows you to package your application and its dependencies into a container, ensuring it runs the same in development, testing, and production.
2. **Isolation**: Containers isolate applications from each other, sharing the same OS kernel but running as if on separate systems.
3. **Resource Efficiency**: Containers are lightweight, starting and stopping much faster than traditional virtual machines.
4. **Portability**: Docker containers can run anywhere: on-premises, in the cloud, or on a developer’s local machine.
5. **Microservices Architecture**: Docker simplifies the development and deployment of microservices, allowing you to manage each service independently.

**Kubernetes**:
1. **Scalability**: Kubernetes automatically manages the scaling of your applications based on resource usage, ensuring efficient use of resources.
2. **Self-Healing**: Kubernetes monitors the health of containers, restarting failed containers or rescheduling them on healthy nodes.
3. **Load Balancing and Service Discovery**: Kubernetes automatically distributes traffic across your containers, ensuring no single instance is overwhelmed.
4. **Rolling Updates and Rollbacks**: Kubernetes allows for seamless updates to applications, ensuring minimal downtime and easy rollback if issues arise.
5. **Infrastructure Abstraction**: Kubernetes abstracts the underlying infrastructure, allowing you to manage your applications without worrying about the specifics of the hardware.

### How to Use Docker and Kubernetes

**Using Docker**:
1. **Install Docker**: Install Docker on your machine or server.
2. **Create a Dockerfile**: Write a Dockerfile to define the environment for your application. This file includes instructions on how to set up the application, including dependencies and configurations.
3. **Build a Docker Image**: Use the Dockerfile to build an image of your application using `docker build`.
4. **Run a Container**: Use `docker run` to start a container from the image.
5. **Manage Containers**: Use Docker commands like `docker ps`, `docker stop`, and `docker exec` to manage running containers.

**Using Kubernetes**:
1. **Set Up a Kubernetes Cluster**: Create a Kubernetes cluster using tools like `minikube` for local development or `eksctl` for Amazon EKS.
2. **Define Deployment and Services**: Write YAML files to define deployments, services, and other resources. A deployment specifies how many replicas of a container should run, while a service defines how to expose your application to the network.
3. **Deploy to Kubernetes**: Use `kubectl apply` to deploy your application to the Kubernetes cluster using the YAML configuration files.
4. **Monitor and Scale**: Use Kubernetes commands like `kubectl get pods` and `kubectl scale` to monitor and scale your application.
5. **Manage Rollouts**: Use `kubectl rollout` commands to manage updates and rollbacks of your application.

**Integration**:
- **CI/CD Pipelines**: Integrate Docker and Kubernetes into your CI/CD pipelines for automated building, testing, and deployment of containers.
- **Container Registries**: Store and manage Docker images in container registries like Docker Hub or Amazon ECR.
- **Helm Charts**: Use Helm, a Kubernetes package manager, to manage complex deployments and configurations.

### Example Workflow:
1. **Develop**: Write your application code.
2. **Containerize**: Create a Dockerfile and build a Docker image.
3. **Test Locally**: Run and test the container locally using Docker.
4. **Deploy**: Push the Docker image to a container registry and deploy it to a Kubernetes cluster.
5. **Scale and Monitor**: Use Kubernetes to scale your application and monitor its performance.

Docker and Kubernetes together form a powerful duo for modern application development, enabling consistent, scalable, and efficient deployment across various environments.



## Setting Up Docker and Building a Chess App Container

In this section, we'll explore how to clone a GitHub repository, build a Docker image, and push it to Docker Hub. This tutorial uses a simple chess application as an example to illustrate the process.

### Cloning the Repository

First, we update the instance, then clone the chess application repository from GitHub:

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
Paste the content into the nano editor. Then, press `Ctrl + X` to exit, `Y` to confirm saving the changes, and `Enter` to finalize.

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


In the `Dockerfile`, you'll typically define the base image, copy the necessary files, install dependencies, and specify the command to run the application.
now when we try to build 


```
docker build -t chess .
```

The build failed because Docker is not installed on your machine. Before attempting to build the image, ensure that Docker is properly installed. If Docker isn't installed, you can set it up using the following script:

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


To stop the container, run the command below using the container ID. You can also start, stop, or restart containers using the corresponding commands.
```
docker stop 32a6204355de
```


now we we need to open security group to see our app on the browser, follow the image below 

1. **Open the AWS Management Console:**
   - Navigate to the [EC2 Dashboard](https://console.aws.amazon.com/ec2/).

2. **Select Security Groups:**
   - In the left-hand menu, under “Network & Security,” click on “Security Groups.”

3. **Choose Your Security Group:**
   - Find and select the security group associated with your EC2 instance.

4. **Edit Inbound Rules:**
   - Click on the “Inbound rules” tab and then click “Edit inbound rules.”

5. **Add a Rule:**
   - Click “Add rule.”
   - Set the “Type” to `HTTP` (for port `80`) or `Custom TCP Rule` if you’re using a different port (e.g., `8080`).
   - For “Port Range,” specify the port you're using (e.g., `8080`).
   - For “Source,” you can set it to `0.0.0.0/0` to allow traffic from all IP addresses or restrict it to specific IP addresses as needed.
   - Click “Save rules.”

![Screenshot 2024-08-28 at 16 32 56](https://github.com/user-attachments/assets/3c5bf851-f894-4df1-a2a7-c1b9c0f62445)

now we will get our chess running on our browers via 

``` 
<public-ip>:8080
```
![Screenshot 2024-08-28 at 16 01 17](https://github.com/user-attachments/assets/a3cd01e0-2360-4e4a-a472-f21e2e8b6ad4)



### Docker Hub: Tagging and Pushing the Image

To share your Docker image, you need to push it to Docker Hub. First, log in to Docker Hub:


```bash
docker login
```
Log in by providing your username and password, then create a repository through the Docker Hub GUI.
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

### Best Practices and Final Notes

- **Security:** Always use strong passwords for Docker Hub and AWS. Avoid opening unnecessary ports to reduce security risks.
- **Cleanup:** Regularly remove unused Docker images and containers to free up space on your machine.
- **Automation:** Consider setting up a CI/CD pipeline to automate the build and deployment process, especially for production environments.

---

