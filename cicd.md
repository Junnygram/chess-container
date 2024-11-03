If've deleted the "latest" tag from my Docker repository, the first push will create a new Docker image. with the <meta> head `React app` in the `index.html`, then the second merge request will create an image with the <meta> head `Containerized app` just to verify that ur workflow will work as expected.

### Integration Workflow (`integration.yaml`)

This workflow automates the build process for a Node.js project across various Node.js versions. It triggers on pushes or pull requests to the `main` branch.

### Build Workflow (`build.yaml`)

This workflow handles the building and pushing of a Docker image to Docker Hub whenever code is pushed to the `main` branch. It tags the image with the commit SHA.

### Key Changes and Improvements:

1. **Clarity and Structure**: Each job has a specific purpose and is named according to the Node.js version being built.
2. **Efficient Tagging**: The tagging logic in the build workflow determines how to tag based on the existence of the "latest" tag.
3. **Comments**: Added comments for clarity, making the workflow easier to follow.
4. **Secrets for Security**: Utilizes GitHub secrets for Docker Hub credentials to improve security.

## Kubernetes Deployment on GCP

With the prerequisites in place, you can proceed with deploying the application on Google Cloud Platform using Kubernetes. Detailed instructions on how to configure and manage your Kubernetes deployment can be found in the [k8s-declarative.md](https://github.com/Junnygram/chess-container/tree/main/k8s/k8s-declarative.md) file.
