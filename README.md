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

**IMPORTANT:** This example is for demo and testing. It should not be used a production environment!

### Get the example Docker image
You can pull an already built version of this Jenkins image from [bintray.com](https://bintray.com).
```bash
# Pull the image
$ docker pull eldada-docker-examples.bintray.io/jenkins:lts-k8s
```

### Build the Jenkins Docker image
You can build the image yourself
```bash
$ export DOCKER_REG=SET_YOUR_DOCKER_REGISTRY_HERE

# Build the image
$ docker build -t ${DOCKER_REG}/jenkins:lts-k8s .

# Push the image
$ docker push ${DOCKER_REG}/jenkins:lts-k8s
```

### Test your image
You can run your container locally, if you have Docker installed
- Using the pre-built image
```bash
# Run the container you built before
$ docker run -d --name jenkins -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock eldada-docker-examples.bintray.io/jenkins:lts-k8s

```

- Using your built image
```bash
# Run the container you built before
$ docker run -d --name jenkins -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock ${DOCKER_REG}/jenkins:lts-k8s

```
- Browse to http://localhost:8080 on your local browser

### Deploy Jenkins helm chart to Kubernetes
If you are using the pre-built image `eldada-docker-examples.bintray.io/jenkins:lts-k8s`, you can install the helm chart with
```bash
# Deploy the Jenkins helm chart
# (same command for install and upgrade)
$ helm upgrade --install jenkins ./helm/jenkins-k8s
```


If you are building your own version of Jenkins, you need your Kubernetes cluster to be able to pull the Docker image.
You have to create a Docker registry secret and reference to it in your `helm install` command.
```bash
# Create a Docker registry secret
$ export DOCKER_REG=SET_YOUR_DOCKER_REGISTRY_HERE
$ export DOCKER_USR=SET_YOUR_DOCKER_USERNAME_HERE
$ export DOCKER_PWD=SET_YOUR_DOCKER_PASSWORD_HERE
$ export DOCKER_EML=SET_YOUR_DOCKER_EMAIL_HERE

$ kubectl create secret docker-registry docker-reg-secret \
        --docker-server=${DOCKER_REG} \
        --docker-username=${DOCKER_USR} \
        --docker-password=${DOCKER_PWD} \
        --docker-email=${DOCKER_EML}


# Deploy the Jenkins helm chart
# (same command for install and upgrade)
$ helm upgrade --install jenkins \
        --set imagePullSecrets=docker-reg-secret \
        --set image.repository=${DOCKER_REG}/jenkins \
        --set image.tag='lts-k8s' \
        ./helm/jenkins-k8s
```

### Data persistence
By default, in Kubernetes, the Jenkins deployment uses a persistent volume claim that is mounted to `/var/jenkins_home`.
This assures your data is saved across crashes, restarts and upgrades.   

### Vagrant
You can test your Docker image using `Vagrant`. The enclosed [Vagrantfile](Vagrantfile) will provision an Ubuntu VM with Docker.

- Spin up the Vagrant VM then build and run the Docker image
```bash
# Spin up the Vagrant VM
$ vagrant up

# SSH into the VM
$ vagrant ssh

# Go to the mounted sources repository
$ cd /opt/provisioning

# Build and run your Jenkins container as shown above
```
- Browse to http://localhost:8080 on your local browser
