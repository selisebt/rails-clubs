

| **Command**   | **Description**                                                                                 | **Example**                                          |
| ------------- | ----------------------------------------------------------------------------------------------- | ---------------------------------------------------- |
| `FROM`        | Specifies the base image for the container.                                                     | `FROM ubuntu:20.04`                                  |
| `RUN`         | Executes commands in the shell during the build process, creating a new layer in the image.     | `RUN apt-get update && apt-get install -y python3`   |
| `CMD`         | Provides the default command to execute when the container starts.                              | `CMD ["python3", "app.py"]`                          |
| `ENTRYPOINT`  | Configures a container to run as an executable with specific arguments.                         | `ENTRYPOINT ["python3", "app.py"]`                   |
| `WORKDIR`     | Sets the working directory inside the container for subsequent instructions.                    | `WORKDIR /app`                                       |
| `COPY`        | Copies files or directories from the build context to the image.                                | `COPY . /app`                                        |
| `ADD`         | Similar to `COPY` but also supports fetching remote URLs and extracting archives.               | `ADD https://example.com/file.tar.gz /app`           |
| `EXPOSE`      | Documents the port on which the container listens at runtime.                                   | `EXPOSE 8080`                                        |
| `ENV`         | Sets environment variables in the container.                                                    | `ENV APP_ENV=production`                             |
| `ARG`         | Defines build-time variables that can be passed via the `--build-arg` flag.                     | `ARG VERSION=1.0`                                    |
| `LABEL`       | Adds metadata to the image, such as author or version information.                              | `LABEL maintainer="dev@example.com"`                 |
| `USER`        | Specifies the user to use when running the container.                                           | `USER appuser`                                       |
| `VOLUME`      | Creates a mount point for volumes to persist data outside the container.                        | `VOLUME /data`                                       |
| `ONBUILD`     | Adds a trigger instruction that is executed when the image is used as a base for another build. | `ONBUILD RUN echo "This runs during the next build"` |
| `STOPSIGNAL`  | Sets the system call signal for stopping the container.                                         | `STOPSIGNAL SIGKILL`                                 |
| `HEALTHCHECK` | Defines a command to monitor the container's health status.                                     | `HEALTHCHECK CMD curl --fail http://localhost:8080   |  | exit 1` |
| `SHELL`       | Allows changing the default shell used by `RUN` commands.                                       | `SHELL ["powershell", "-Command"]`                   |