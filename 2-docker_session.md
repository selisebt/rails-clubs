# Docker session: From Basics to Deploying a Rails Application

## Introduction

This session will guide you through Docker fundamentals and best practices, culminating in deploying a Rails application in a containerized environment. By the end of this session, you'll understand how Docker works, how to create and manage containers, and how to deploy your Rails application using Docker.


## Table of Contents

1. [Docker Fundamentals](#docker-fundamentals)
2. [Working with Docker Images](#working-with-docker-images)
3. [Managing Docker Containers](#managing-docker-containers)
4. [Docker Networking](#docker-networking)
5. [Docker Volumes and Persistent Data](#docker-volumes-and-persistent-data)
6. [Docker Compose](#docker-compose)
7. [Optimizing Docker Images](#optimizing-docker-images)
8. [Deploying a Rails Application with Docker](#deploying-a-rails-application-with-docker)
9. [Production Best Practices](#production-best-practices)
10. [Troubleshooting Common Issues](#troubleshooting-common-issues)

## Docker Fundamentals

### What is Docker/Container Runtimes?

Docker is a platform that enables developers to build, package, and run applications in containers. Containers are lightweight, portable, and self-sufficient environments that include everything needed to run an application.

Unlike traditional virtual machines, Docker containers share the host system's kernel, making them more efficient and faster to start. This architecture allows developers to "build once, run anywhere," ensuring consistency across different environments.

### Key Docker Concepts

- **Container**: **A lightweight, standalone, and executable unit that packages the application along with its dependencies**. It is a runnable instance of an image, isolated from the host system and other containers using operating system virtualization. Containers provide a consistent runtime environment regardless of the host system.

- **Image**: A read-only template that contains the instructions needed to create a container. It includes the application code, runtime, libraries, environment variables, and file systems. Images are built in layers and can be shared across different systems via a registry.

- **Dockerfile/Containerfile**: A plain text file that defines a set of instructions to automate the process of building a Docker image. It specifies the base image, application dependencies, environment setup, and commands to run the application. The `docker build` command processes the Dockerfile/Containerfile to create the image.

- **Registry**: A centralized repository for storing and distributing Docker images. Developers can push their images to a registry and pull them as needed. Public registries like Docker Hub or private registries enable teams to manage their containerized application images securely.

### Installation Verification

**Practical Step 1**: Verify Docker installation

```bash
docker --version
docker info
```

**What happens**: The first command displays the Docker version you have installed. The second command shows detailed information about your Docker installation, including the number of containers and images, system configuration, and resource limits.


### Hello World in Docker

**Practical Step 2**: Run your first container

```bash
docker run hello-world
```

**What happens**: This command performs several steps:
1. Docker looks for the hello-world image locally
2. If not found, it pulls the image from Docker Hub
3. It creates a container from this image
4. It starts the container, which prints a message and exits


## Working with Docker Images

### Finding Images

**Practical Step 3**: Search for images on Docker Hub

```bash
docker search nginx
```

**What happens**: Docker queries the Docker Hub API and returns a list of images related to "nginx," showing their names, descriptions, stars (popularity), and official status.

### Pulling Images

**Practical Step 4**: Pull an image from Docker Hub

```bash
docker pull nginx:latest
```

**What happens**: Docker downloads the latest version of the nginx image from Docker Hub to your local machine, showing the progress of each layer being downloaded.

Pulling images explicitly allows you to prepare environments offline before running containers. The tag (`:latest` in this case) specifies which version of the image to use, which is essential for reproducible deployments.

### Listing Images

**Practical Step 5**: List all images on your system

```bash
docker images
```

**What happens**: Displays a table of all Docker images stored locally, including repository names, tags, image IDs, creation dates, and sizes.


### Building Custom Images

**Practical Step 6**: Create a simple Dockerfile

Create a new directory and a Dockerfile inside it:

```bash
mkdir docker-test
cd docker-test
touch Dockerfile
```

Edit the Dockerfile with your preferred editor and add:

```dockerfile
FROM alpine:latest
RUN apk add --no-cache bash
CMD ["bash", "-c", "echo 'Hello from my custom Docker image!'"]
```

**What happens**: 
- You create a Dockerfile which:
  - Uses Alpine Linux as a base image (very small Linux distribution)
  - Installs bash using Alpine's package manager
  - Sets the default command to print a message using bash

**Why it's important**: The Dockerfile is the blueprint for your image. This simple example demonstrates the basic structure:
- `FROM` specifies the base image to build upon
- `RUN` executes commands during the build process
- `CMD` defines the default command to run when a container starts

**Practical Step 7**: Build the image

```bash
docker build -t $UNIQUE_ID-my-custom-image .
```

**What happens**: Docker reads the Dockerfile in the current directory (`.`) and:
1. Pulls the base image if not already present
2. Executes each instruction in the Dockerfile, creating a new layer for each step
3. Tags the resulting image as `$UNIQUE_ID-my-custom-image` (using the `-t` flag)

**Why it's important**: Building images is how you package your application and its dependencies. The tagging system (`-t`) lets you give meaningful names to your images for easier reference later.

**Practical Step 8**: Run your custom image

```bash
docker run $UNIQUE_ID-my-custom-image
```

**What happens**: Docker creates and starts a container based on the `$UNIQUE_ID-my-custom-image` image, executes the default command (which prints "Hello from my custom Docker image!"), and then exits since the command completes.

This verifies that your image was built correctly and functions as expected. Running containers from your custom images is the fundamental way to deploy applications with Docker.

## Managing Docker Containers

### Running Containers

**Practical Step 9**: Run a container in interactive mode

```bash
docker run -it --name $UNIQUE_ID-my-alpine alpine /bin/sh
```

**What happens**: This command:
1. Creates a new container named `$UNIQUE_ID-my-alpine` from the `alpine` image
2. Allocates a pseudo-TTY (`-t`)
3. Keeps STDIN open (`-i`)
4. Runs the `/bin/sh` shell inside the container
5. Gives you an interactive shell prompt inside the container

Interactive mode is essential for debugging, exploring container environments, or running interactive applications. The `-it` flags are commonly used together to provide a fully interactive terminal experience.


### Listing Containers

**Practical Step 11**: List running containers

```bash
docker ps | grep $UNIQUE_ID
```

**What happens**: Shows a table of all currently running containers, including container IDs, image names, creation times, status, ports, and names.


**Practical Step 12**: List all containers (including stopped ones)

```bash
docker ps -a | grep $UNIQUE_ID
docker ps -a
```

**What happens**: Shows all containers on your system, including those that have exited or stopped, with their exit codes.

### Why it's important

This gives you a complete picture of container history on your system. Seeing stopped containers helps identify failed runs, containers that need to be cleaned up, or containers you might want to restart.

### Starting, Stopping, and Removing Containers

**Practical Step 12**: Start, stop, and remove a container

```bash
# Run a container in detached mode
docker run -d --name $UNIQUE_ID-web-server nginx

# Stop the container
docker stop $UNIQUE_ID-web-server

# Start the container again
docker start $UNIQUE_ID-web-server

# Remove the container (must be stopped first)
docker stop $UNIQUE_ID-web-server
docker rm $UNIQUE_ID-web-server
```

**What happens**:
- The first command runs nginx in "detached" mode (`-d`), which means it runs in the background
- `stop` sends a SIGTERM signal to gracefully shut down the container
- `start` restarts a stopped container, preserving its state
- `rm` permanently removes the container (but not the image)

**Why it's important**: These commands demonstrate the container lifecycle management. Understanding how to start, stop, and remove containers is essential for maintaining a clean and efficient Docker environment. The detached mode is particularly useful for running services in the background.

### Container Logs and Inspection

**Practical Step 13**: View container logs

```bash
# Run a container with a name
docker run -d --name $UNIQUE_ID-logging-demo nginx

# View its logs
docker logs $UNIQUE_ID-logging-demo

# Follow the logs in real-time
docker logs -f $UNIQUE_ID-logging-demo
```

**What happens**:
- The first command starts an nginx container in the background
- `docker logs` displays the STDOUT and STDERR output from the container
- The `-f` flag "follows" the log output in real-time, similar to `tail -f`

**Why it's important**: 101 of finding what's wrong is logs.

**Practical Step 14**: Inspect container details

```bash
docker inspect $UNIQUE_ID-logging-demo
```

**What happens**: Outputs a detailed JSON document with complete information about the container, including network settings, volume mounts, environment variables, resource limits, and more.

**Why it's important**: Helps in debugging as this shows exact information about the container

## Docker Networking

### Network Types

Docker provides several network types:
- **Bridge (default)**: Internal private network where containers can communicate with each other
- **Host**: Removes network isolation between container and host
- **None**: No networking
- **Custom bridge networks**: User-defined networks with better isolation and name resolution


### Exposing Ports

**Practical Step 15**: Run a container with port mapping

```bash
# Run nginx with port forwarding
docker run -d --name $UNIQUE_ID-web-server -p $UNIQUE_ID:80 nginx:alpine
```

**What happens**: 
1. Creates a container named `$UNIQUE_ID-web-server` from the `nginx` image
2. Runs it in detached mode (`-d`) in the background
3. Maps port $UNIQUE_ID on the host to port 80 in the container (`-p $UNIQUE_ID:80`)
4. The nginx web server inside the container is now accessible at http://vm.selise.dev:$UNIQUE_ID

**Why it's important**: Port mapping is essential for making containerized services accessible from outside the container. The `-p` flag (publish) connects a container's internal port to a port on your host machine. This enables:
- External access to web servers, APIs, or databases running in containers
- Running multiple instances of the same service on different host ports
- Creating complex microservice architectures where each service is in its own container

You can also bind to specific interfaces using: `-p 127.0.0.1:$UNIQUE_ID:80` (only local access) or `-p 0.0.0.0:$UNIQUE_ID:80` (access from any network interface).

### Listing and Creating Networks

**Practical Step 16**: List networks and create a custom network

```bash
# List all networks
docker network ls

# Create a custom bridge network
docker network create $UNIQUE_ID-my-network

# Verify your new network is in the list
docker network ls | grep $UNIQUE_ID
```
**What happens**:
- The first command shows all Docker networks on your system
- The second creates a custom bridge network called `$UNIQUE_ID-my-network`
- The third verifies that your new network appears in the list

**Why it's important**: Custom networks provide better isolation and built-in DNS resolution between containers. Creating dedicated networks for different applications helps with security and organization. The ability to list networks helps you manage your network topology.

### Connecting Containers to Networks

**Practical Step 17**: Run containers on your custom network

```bash
# Start two containers on your custom network
docker run -d --name $UNIQUE_ID-container1 --network $UNIQUE_ID-my-network alpine sleep 1000
docker run -d --name $UNIQUE_ID-container2 --network $UNIQUE_ID-my-network alpine sleep 1000

# Inspect the network to see the connected containers
docker network inspect $UNIQUE_ID-my-network
```

**What happens**:
- You create two containers, both connected to your custom network
- Both containers run the `sleep` command to keep them alive
- `network inspect` shows detailed information about the network, including all connected containers

**Why it's important**: This demonstrates how to place containers on specific networks. Container orchestration often involves grouping related containers on the same network for security and performance reasons. The inspect command helps you verify your network configuration.

### Container Communication

**Practical Step 18**: Test communication between containers

```bash
# Execute a ping command from container1 to container2
docker exec $UNIQUE_ID-container1 ping -c 4 $UNIQUE_ID-container2
```

**What happens**: The `docker exec` command runs `ping` inside `$UNIQUE_ID-container1`, targeting `$UNIQUE_ID-container2` by name. Since both containers are on the same custom network, the Docker DNS service allows container1 to resolve container2's IP address by its name.

**Why it's important**: This demonstrates one of the key benefits of Docker networking: automatic DNS resolution between containers on the same network. This feature makes it easy to create distributed applications where services can find each other by name, without hardcoding IP addresses.

## Docker Volumes and Persistent Data

### Types of Data Persistence in Docker

- **Volumes**: Docker-managed data storage completely separate from container lifecycle
- **Bind mounts**: Map a host directory directly into a container

### Working with Volumes

**Practical Step 19**: Create and manage volumes

```bash
# Create a named volume
docker volume create $UNIQUE_ID-my-data

# List volumes
docker volume ls | grep $UNIQUE_ID

# Inspect a volume
docker volume inspect $UNIQUE_ID-my-data
```
**What happens**:
- The first command creates a named volume managed by Docker
- `volume ls` lists all volumes on your system
- `volume inspect` shows details about where the volume is stored on the host filesystem

**Why it's important**: Volumes are the preferred way to persist data in Docker because they are:
1. Completely managed by Docker
2. Independent from container lifecycle
3. Easier to back up and migrate
4. Can be shared between containers

This set of commands demonstrates basic volume management that you'll need for databases or any application that needs to persist data or any stateful applications. 

**Practical Step 20**: Use a volume with a container

```bash
# Run a container with a volume
docker run -d --name $UNIQUE_ID-db-server -v $UNIQUE_ID-my-data:/data alpine sleep 1000

# Create a file in the volume
docker exec $UNIQUE_ID-db-server sh -c "echo 'This data will persist' > /data/test.txt"

# Verify the file exists
docker exec $UNIQUE_ID-db-server cat /data/test.txt

# Stop and remove the container
docker stop $UNIQUE_ID-db-server
docker rm $UNIQUE_ID-db-server

# Run a new container with the same volume
docker run -d --name $UNIQUE_ID-new-db-server -v $UNIQUE_ID-my-data:/data alpine sleep 1000

# Verify the data persisted
docker exec $UNIQUE_ID-new-db-server cat /data/test.txt
```

**What happens**:
1. You create a container that mounts the volume at `/data` inside the container
2. You create a file in that volume
3. You destroy the container completely
4. You create a new container with the same volume
5. You verify that the data survived the container's removal

**Why it's important**: This practical demonstration shows how volumes decouple data from the container lifecycle, which is essential for stateful applications like databases. 

## Docker Compose

### Introduction to Docker Compose

Docker Compose is a tool for defining and running multi-container Docker applications. With a single YAML file, you configure all your application's services, networks, and volumes, and with a single command, you create and start all the services.

### Creating a Compose File

**Practical Step 21**: Create a simple docker-compose.yml file

```bash
mkdir compose-demo
cd compose-demo
touch docker-compose.yml
```

Add the following to docker-compose.yml:

```yaml
services:
  web:
    image: nginx
    ports:
      - "$UNIQUE_ID:80"
    volumes:
      - ./html:/usr/share/nginx/html
    depends_on:
      - app
  
  app:
    image: alpine
    command: sh -c "while true; do echo 'App is running - log from app container'; sleep 3; done"
```

**What happens**: You create a Docker Compose configuration with two services:
1. A web service using nginx, exposing port $UNIQUE_ID and mounting a local directory into the container
2. A simple app service that prints a message every 3 seconds
3. The `depends_on` directive ensures that the app service starts before the web service

**Why it's important**: This demonstrates the basic structure of a Docker Compose file, which serves as the blueprint for multi-container applications. The declaration is clear, descriptive, and version-controlled, making it ideal for development environments and simple deployments.

### Example: Simple Blog Application

Let's create a more practical example - a simple blog application with a web server and database:

**Practical Step 22**: Create a blog application with Docker Compose

Create a new directory for our blog project:

```bash
mkdir blog-project
cd blog-project
touch docker-compose.yml
```

Add the following to docker-compose.yml:

```yaml
services:
  # Database service
  db:
    image: mysql:5.7
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: blogdb
      MYSQL_USER: bloguser
      MYSQL_PASSWORD: blogpassword
  
  # WordPress service (our blog application)
  wordpress:
    depends_on:
      - db
    image: wordpress:latest
    volumes:
      - wordpress_files:/var/www/html
    ports:
      - "${UNIQUE_ID}:80"
    restart: always
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: bloguser
      WORDPRESS_DB_PASSWORD: blogpassword
      WORDPRESS_DB_NAME: blogdb
      WORDPRESS_DB_PORT: 3306

# Define the volumes
volumes:
  db_data:
  wordpress_files:
```

**What happens**: This Docker Compose file sets up a complete blog application using WordPress with:

1. A MySQL database service that:
   - Uses the official MySQL 5.7 image
   - Creates a named volume for persistent data storage
   - Sets up credentials for the database
   - Exposes the database port (for potential external tools)

2. A WordPress service that:
   - Uses the latest WordPress image
   - Depends on the database service
   - Maps the WordPress files to a volume for persistence
   - Connects to the MySQL database using the credentials
   - Exposes port $UNIQUE_ID so you can access the blog

**Why it's important**: This practical example demonstrates how Docker Compose can easily set up a complete application stack.

- How multiple services work together (web application + database)
- How services communicate with each other
- How environment variables configure the application
- How volumes provide data persistence
- How port mapping makes the application accessible

**Practical Step 23**: Start the blog application

```bash
docker-compose up
```

This starts both services in the foreground. After a few moments, students can visit https://${UNIQUE_ID}.cst.selise.dev (or the appropriate server address) and see a working WordPress site where they can set up their blog.

**Practical Step 24**: Explore your running application

```bash
# Check service status
docker-compose ps

# View logs from both services
docker-compose logs

# See just the WordPress logs
docker-compose logs wordpress

# Access the WordPress container
docker-compose exec wordpress bash
```

**Practical Step 25**: Shut down the application when done

```bash
docker-compose down
```

To remove the volumes as well (which would delete your blog data):

```bash
docker-compose down -v
```

**Quite powerful:**
- It's a complete, working application that they can actually use
- The concepts are familiar (a blog with a database)
- It demonstrates all the key Docker Compose concepts
- The setup is simple enough to understand but complex enough to be realistic
- Students can extend it easily (e.g., adding phpMyAdmin as another service)

### Running Docker Compose

**Practical Step 26**: Start the services

```bash
docker-compose up
```

**What happens**: Docker Compose reads the `docker-compose.yml` file and:
1. Creates a default network for the application
2. Pulls necessary images if they don't exist locally
3. Creates and starts containers for each service
4. Links them according to the dependencies
5. The services run in the foreground

**Why it's important**: This single command replaces what would otherwise be multiple Docker commands. It's much simpler to manage complex applications this way, especially when the number of containers and their interconnections grow.

**Practical Step 27**: Check the status of the services

```bash
docker-compose ps
```

**What happens**: Shows the status of all services defined in your docker-compose.yml, including container names, command, state, and ports.

**Why it's important**: This gives you a consolidated view of your application's containers, filtered to just show the services relevant to this compose project. This is much more focused than `docker ps` which shows all containers on the system.

**Practical Step 28**: View the logs

```bash
docker-compose logs
```

**What happens**: Shows the combined logs from all services in the Docker Compose application, with each line prefixed with the service name for clarity.

**Why it's important**: This unified view of logs is incredibly valuable for debugging multi-container applications, as it shows you the interleaved output from all services in chronological order. This makes it easier to trace issues that span multiple containers.

**Practical Step 29**: Stop the services

```bash
docker-compose down
```

**What happens**: Stops and removes all containers, networks, and (by default) unnamed volumes created by `docker-compose up`.

**Why it's important**: This command provides a clean way to shut down an entire application stack with a single command. It's more thorough than just stopping containers, as it also cleans up networks and can optionally remove volumes to provide a completely fresh environment next time.

### Explore on Your Own

Here are some additional Docker optimization topics to explore in your own time:

1. **Multi-stage Builds in Practice**: Create a multi-stage Dockerfile that uses a build stage with a full Node.js image to install dependencies and build the application, followed by a production stage using a minimal nginx image that only copies the built files from the first stage.

2. **Layer Caching**: Optimize Dockerfiles by structuring them to take advantage of Docker's layer caching. Install system dependencies first (rarely change), copy and install only dependency files before the rest of the code, and copy frequently-changing application code last.

3. **Image Size Optimization**: Compare full images vs Alpine-based images to see the significant size difference. Alpine-based images are often 2-3x smaller, which improves download/deployment speed, reduces memory usage, decreases attack surface, and lowers registry storage costs.

4. **Squashing Docker Images**: Learn how to use `docker build --squash` to combine multiple layers into one, reducing the final image size.

5. **Distroless Images**: Explore Google's "distroless" base images that contain only your application and its runtime dependencies with no package manager, shell or other programs.

6. **BuildKit Features**: Dive into Docker BuildKit's advanced features like better caching, parallel building, and secret mounting during build time.

7. **Docker Image Scanning**: Implement security scanning in your workflow with tools like Trivy, Clair, or Docker Scan to detect vulnerabilities.

8. **Custom Base Images**: Learn how to create and maintain your own base images to standardize your organization's containers.

9. **Production Best Practices**: 
   - Run containers as non-root users
   - Use minimal base images
   - Scan images for vulnerabilities
   - Implement proper network segmentation
   - Use environment variables for configuration following the 12-factor app methodology
   - Keep sensitive information out of your codebase and image

10. **Health Checks Implementation**: Add health checks to containers to allow Docker and orchestration platforms to detect when a container is no longer functioning correctly, enabling automatic restarts, proper load balancing, better monitoring, and easier debugging.

11. **Container Resource Management**: Learn to set resource constraints on containers (memory, CPU) to prevent a single container from consuming all host resources, enable better multi-tenancy, make resource usage more predictable, identify applications with memory leaks, and allow more efficient scheduling in orchestration systems.

12. **Troubleshooting Techniques**:
    - Master container log access (both historical and real-time)
    - Use docker exec for debugging and running one-off commands
    - Implement proper monitoring and alerting
    - Develop strategies for common container failure scenarios

These techniques can significantly improve your Docker workflow, reducing build times, image sizes, and enhancing security.



Remember these key takeaways:
- Docker provides consistent environments across development, testing, and production
- Containers are lightweight and efficient compared to traditional VMs
- Docker Compose simplifies multi-container application management
- Proper image optimization and security practices are essential for production

Continue exploring Docker's capabilities and keep up with best practices as you containerize more of your applications!

## Additional Resources
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Awesome Compose](https://github.com/docker/awesome-compose/)