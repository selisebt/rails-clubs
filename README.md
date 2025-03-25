# CST Clubhouse

## Description

This Repo contains the code for the CST Clubhouse WebApp used the workshop.

## Installation

### Prerequisites

The following tools must be installed on your system to run the project:

1. Docker
2. Git
3. Code Editor / IDE (RubyMine/VSCode)

### Steps

You may have to run the following git global config to set your username and email:

```bash

  git config --global user.name "your-username"
  git config --global user.email "youremail@example.com"
````

1. Clone the repository

```bash
  
  git clone https://github.com/selisebt/rails-clubs.git
```

2. Change directory to the project folder

```bash

  cd rails-clubs
  pwd
```

3. Run the following command to run the project in a docker container for development

```bash

  # Replace $(pwd) with the absolute path to the project folder (use pwd output from above)
  docker run --name cst-clubhouse -v $(pwd):/app -p 3000:3000 -d ruby:3.4.2 tail -f /dev/null
```

This will create a docker container with the name `cst-clubhouse` and run the `tail -f /dev/null` command to keep the container running.

4. Run the following command to check if the container is running

```bash

  docker ps
```

5. Open your Code Editor / IDE and navigate to the project folder

6. Use the following command to enter the container

```bash

  docker exec -it cst-clubhouse bash
```

7. Run the following commands inside the container to run the rails project (In next session)

```bash

  bundle install
  rails db:create
  rails db:migrate
  rails s -b 0.0.0.0
```

### Useful `git` commands (not to run inside container)

The following commands are useful when working with `git` for this workshop:

Run these commands in the project folder.

1. Check the status of the project

```bash

  git status
```

2. Change Branch

```bash

  git fetch && git checkout <branch-name>
```

3. TODO: Reset all changes

