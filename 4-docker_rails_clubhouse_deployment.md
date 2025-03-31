# Docker Deployment Guide for CST Students

This guide will help you deploy the Rails-Clubs application during your Docker workshop. Each student will deploy their own containerized instance of the application with a unique URL.

## What to Expect

During this deployment:
1. You'll connect to a shared server via SSH
2. You'll use your student ID to get a unique 5 digit number
3. You'll clone the Rails-Clubs repository and build a Docker container
4. Your application will be accessible at a unique URL: `https://UNIQUE_ID.cst.selise.dev`

## Step-by-Step Deployment Process

### Step 1: Connect to the Workshop Server

```bash
ssh ubuntu@vm.selise.dev
# Enter password provided in chat
```

### Step 2: Set Your Unique ID

```bash
# Set your unique ID as an environment variable
unique_id STUDENT_NUMBER or EMAIL
export UNIQUE_ID=UNIQUE_ID_GIVEN_BY_ABOVE_COMMAND  # Replace with YOUR 5-digit unique ID

# Verify it's set correctly
echo $UNIQUE_ID
```

This variable will be available in your current terminal session. If you open a new terminal or log out, you'll need to set it again.

### Step 3: Set Up Your Environment

```bash
# cd into your workspace directory
cd ~/workspace/$UNIQUE_ID
# Clone the Rails-Clubs repository
git clone git@github.com:selisebt/rails-clubs.git
cd rails-clubs

# Build the Docker image with your unique tag
docker build -t rails-clubhouse-$UNIQUE_ID .
```

This process may take a few minutes as it builds the Docker image.

### Step 4: Run Your Application

```bash
touch .env
echo "DEFAULT_USER_EMAIL='example@example.com'" > .env
echo "DEFAULT_USER_PASSWORD='NotVeryStrongPassword'" >> .env
```

# Start your container with your unique port mapping
```bash
docker run -d --name rails-clubhouse-$UNIQUE_ID \
   -p $((3000 + $UNIQUE_ID)):3000 \
   --env-file .env \
   -e RAILS_ENV=production \
   -e SECRET_KEY_BASE=dummy_key_for_workshop_$UNIQUE_ID \
   rails-clubhouse-$UNIQUE_ID
```


This command:
1. Creates a container with your unique name (`rails-clubhouse-$UNIQUE_ID`)
2. Maps a unique port based on your ID (`$UNIQUE_ID`)
3. Sets necessary environment variables with your unique ID
4. Uses your uniquely tagged image (`rails-clubhouse-$UNIQUE_ID`)

## Check your app 
Visit https://UNIQUE_ID.cst.selise.dev in your browser. You should see the Rails-Clubs application running.

Use the credentials you set in the `.env` file to log and check around.