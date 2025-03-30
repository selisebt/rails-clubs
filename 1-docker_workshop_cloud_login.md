# Docker Session: Cloud VM Login Instructions

## Introduction

For this Docker session, we'll be using a shared cloud VM environment. Each student will have their own workspace on this VM, identified by a unique ID. This approach ensures everyone has access to the same consistent environment without worrying about differences in local machine setups.

## Step 1: Connecting to the Workshop VM

Open your terminal/powershell and use SSH to connect to the workshop VM:

```bash
ssh root@vm.selise.dev
```

When prompted, enter the password shared in the Mattermost chat

## Step 2: Setting Your Unique ID

Each student needs to set a unique environment variable to avoid conflicts when running containers. Your unique ID will be used to:

- Create your personal workspace directory
- Set unique port numbers for your containers
- Tag your Docker images uniquely
- Ensure your work doesn't interfere with other students

Set your unique ID as follows:

```bash
unique_id STUDENT_NUMBER or EMAIL

export UNIQUE_ID=UNIQUE_ID_GIVEN_BY_ABOVE_COMMAND
```

**IMPORTANT:** This environment variable only persists in your current terminal session. If you disconnect or open a new terminal window, you'll need to set it again.

## Step 3: Create Your Workshop Directory

Create a personal workspace directory using your unique ID:

```bash
# Create directory
mkdir -p ~/workspace/$UNIQUE_ID
cd ~/workspace/$UNIQUE_ID
```

## Step 4: Follow Along with the session

You're now ready to follow along with the instructor using the commands in the workshop material. 

Remember to:
1. Always use your `$UNIQUE_ID` when building and running containers
2. Use unique port numbers based on your ID to avoid conflicts
3. Tag your images with your unique ID

## Troubleshooting

### If you get disconnected
Simply reconnect with SSH and set your UNIQUE_ID again

### Port conflicts
If you see an error about ports already in use, make sure you're using your unique port
if there is a container running on that port, you can stop it
