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

5. Use the following command to enter the container

```bash

  docker exec -it cst-clubhouse bash
  cd app/
```

6. **(In the next session)** Run the following commands inside the container to run the rails project

```bash

  bundle install
  rails db:create
  rails db:migrate
  rails s -b 0.0.0.0
```

## Useful `git` commands (not to run inside container)

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

3. Reset all changes (run this before switching/checking out to another branch)

```bash

git checkout .
git clean -ffdx

```


## Branches

The following branches are available in the project:

1. `main` - The main branch of the project
2. `feature/rails-setup-0` - Rails setup
3. `feature/devise-setup-1` - Devise setup
4. `feature/db-models-2` - Database models
5. `feature/user-management-3` - User management
6. `feature/fe/user-management-4` - User management frontend
7. `feature/clubs-5` - Clubs
8. `feature/fe/clubs-6` - Clubs frontend
9. `feature/club-api-tests-7` - Club API tests setup
10. `feature/club-api-tests-7.1` - Club API tests
11. `feature/announcements-8` - Announcements
12. `feature/fe/announcements-9` - Announcements frontend
13. `feature/events-10` - Events
14. `feature/fe/events-11` - Events frontend
15. `feature/event-reminder-12` - Event remainder
16. ~~`feature/budgeting-13` - Budgeting~~
17. ~~`feature/fe/budgeting-14` - Budgeting frontend~~
18. `feature/containerization-15` - Containerization
19. `feature/CICD-16` - CI/CD
