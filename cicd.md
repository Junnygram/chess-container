### Integration Workflow (`integration.yaml`)

This GitHub Actions workflow automates the build process for a Node.js project, testing it across multiple Node.js versions whenever code is pushed to or a pull request is made against the `main` branch.

### Build Workflow (`build.yaml`)

This GitHub Actions workflow automates the building and pushing of a Docker image to Docker Hub whenever code is pushed to the `main` branch, tagging the image with both "latest" and the commit SHA. If an image tagged as "latest" already exists in the Docker repository, this workflow will still push a new image tagged with the commit SHA, allowing for both the latest version and a specific version associated with that commit to be available.
