# Jenkins in Kubernetes
This repository has a `Dockerfile` and a `helm` chart for setting up a simple Jenkins master for running in Kubernetes.

This Jenkins has the required tools to work in and with Kubernetes
- Jenkins application with pre-loaded plugins (see [plugins.txt](plugins.txt))
- Skipped setup wizard
  - You can control admin user and password with `--set adminUser=${USER},adminPassword=${PASSWORD}`
  - You can add and remove plugins by editing the [plugins.txt](plugins.txt) file
- Docker for managing a Docker CI lifecycle
- `kubectl` command line client for working with the Kubernetes API
- `helm` for managing your helm charts CI/CD lifecycle

### Build the Jenkins Docker image
```bash
$ export DOCKER_REG=SET_YOUR_DOCKER_REGISTRY_HERE

# Build the image
$ docker build -t ${DOCKER_REG}/jenkins:lts-k8s .


# Push the image
$ docker push ${DOCKER_REG}/jenkins:lts-k8s
```

### Deploy Jenkins helm chart
Since you are building your own version of Jenkins, you need your Kubernetes cluster to be able to pull the Docker image.
You have to create a Docker registry secret and reference to it in your `helm install` command.

```bash
# Create a namespace to host your Jenkins
$ kubectl create ns jenkins

# Create a Docker registry secret
$ export DOCKER_REG=SET_YOUR_DOCKER_REGISTRY_HERE
$ export DOCKER_USR=SET_YOUR_DOCKER_USERNAME_HERE
$ export DOCKER_PWD=SET_YOUR_DOCKER_PASSWORD_HERE
$ export DOCKER_EML=SET_YOUR_DOCKER_EMAIL_HERE

$ kubectl create secret docker-registry docker-reg-secret --namespace jenkins \
        --docker-server=${DOCKER_REG} --docker-username=${DOCKER_USR} --docker-password=${DOCKER_PWD} --docker-email=${DOCKER_EML}


# Deploy the Jenkins helm chart
# (same command for install and upgrade)
$ helm upgrade --install jenkins --namespace jenkins \
        --set imagePullSecrets=docker-reg-secret \
        --set image.repository=${DOCKER_REG}/jenkins \
        --set image.tag='lts-k8s' \
        ./helm/jenkins-k8s
```

