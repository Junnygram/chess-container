## Docker Integration Workflow

This documentation outlines the integration and build workflows for a Node.js project utilizing Docker . The workflows are designed to automate the build process and facilitate deployment.

### Overview

1. **Integration Workflow (`integration.yaml`)**
   - Automates the build process for a Node.js project across various Node.js versions.
   - Triggers on pushes or pull requests to the `main` branch.

2. **Build Workflow (`build.yaml`)**
   - Handles the building and pushing of Docker images to Docker Hub.
   - Tags images with the commit SHA for traceability.

### Key Changes and Improvements

- **Clarity and Structure**: Each job is named according to the Node.js version it builds, enhancing readability.
- **Efficient Tagging**: The build workflow intelligently tags images based on the existence of the "latest" tag.
- **Comments for Clarity**: Added comments within the workflows to provide context and explanations.
- **Security**: Utilizes GitHub secrets for Docker Hub credentials to enhance security.

### Docker Hub Token Creation

To improve security, create a Docker token instead of using your password. Tokens can be easily revoked if compromised. Follow these steps:

1. **Create a Docker Token**: 
   - Navigate to your Docker account settings and generate a new access token.

   ![Screenshot 2024-10-27 at 21 26 51](https://github.com/user-attachments/assets/ab2bcb54-dd23-4032-93f4-85ddbf01c25a)

2. **Set Up GitHub Secrets**:
   - Go to your repository settings.
   - Under "Secrets and Variables", add new repository secrets:
     - `DOCKER_USERNAME`: Your Docker username.
     - `DOCKER_PASSWORD`: The token you created.

   ![Screenshot 2024-10-27 at 21 26 25](https://github.com/user-attachments/assets/ceb2df55-227b-4950-9b38-f475ef4e1b9a)

3. **Workflow Execution**:
   - When a pull request is created, the Integration Workflow runs.
   - Upon merging, the Build Workflow executes.

### Troubleshooting

If the Build Workflow does not complete:
- Verify that you are using GitHub secrets instead of variables for your Docker credentials.

   ![Screenshot 2024-10-27 at 21 28 22](https://github.com/user-attachments/assets/ed512d76-7887-48a5-b8cb-c35d23ad0c36)

### Kubernetes Integration

For further integration with Kubernetes, refer to the relevant resources in the repository [here](https://github.com/Junnygram/chess-container/blob/main/k8s).


---

This version streamlines your information and organizes it into clear sections, making it easier for readers to follow and understand the process.
