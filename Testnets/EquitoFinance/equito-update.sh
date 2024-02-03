#/bin/sh
RED='\033[0;31m'        # Red Color
GR='\033[0;32m'         # Green Color
YW='\033[0;33m'         # Yellow Color
PR='\033[0;35m'         # Purpule Color
CY='\033[0;36m'         # Cyan Color
NC='\033[0m'            # No Color

# The first block of our script!
# Checking if the new version of the Docker Image is available!
# Getting te name of te Image
IMAGE_NAME="robindev912/equito-validator-node"

# Getting the ID of the local image
LOCAL_IMAGE_ID=$(sudo docker images -q $IMAGE_NAME)

# Trying to update Image to understand if the new version is available
sudo docker pull $IMAGE_NAME > /dev/null

# Getting ID of the updated Image
UPDATED_IMAGE_ID=$(sudo docker images -q $IMAGE_NAME)

# Compare the ID that we got with the current ID.
if [ "$LOCAL_IMAGE_ID" = "$UPDATED_IMAGE_ID" ]; then
    echo ""
    echo -e $CY"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"$NC
    echo -e $YW"Great! You already have the latest version of $IMAGE_NAME!!!"$NC
    echo ""
    echo -ne $PR"Do you want to continue with the script execution? (y/n): "$NC
    read CONTINUE

    if [[ "$CONTINUE" =~ ^[Nn](o)?$ ]]; then
        echo ""
        echo -e $GR"You have canceled installation! Bye!Bye!"$NC
        exit 1
    fi
else
    echo ""
    echo -e $CY"The new version of $IMAGE_NAME has been detected and uploaded. Going to update!"$NC
fi
#------------------------------------------------------------------#

# Checking if the eqt-postgres and equito containers are present in the system
EQTPG_CONTAINER_ID=$(sudo docker ps -a -q -f name=eqt-postgres)
EQUITO_CONTAINER_ID=$(sudo docker ps -a -q -f name=equito)

CONTINUE_SCRIPT=0

if [ -z "$EQTPG_CONTAINER_ID" ]; then
    echo ""
    echo -ne $RED"The eqt-postgres container is not found. Do you want to continue? (y/n): "$NC
    read RESPONSE
    if [[ "$RESPONSE" =~ ^[Nn](o)?$ ]]; then
        CONTINUE_SCRIPT=1
    fi
else
    echo ""
    echo -e $YW"The eqt-postgres container is found."$NC
fi

if [ -z "$EQUITO_CONTAINER_ID" ] && [ $CONTINUE_SCRIPT -eq 0 ]; then
    echo -ne $RED"The equito container is not found. Do you want to continue? (y/n): "$NC
    read RESPONSE
    if [[ "$RESPONSE" =~ ^[Nn](o)?$ ]]; then
        CONTINUE_SCRIPT=1
    fi
elif [ $CONTINUE_SCRIPT -eq 0 ]; then
    echo -e $YW"The equito container is found."$NC
fi

if [ $CONTINUE_SCRIPT -eq 1 ]; then
    echo ""
    echo -e $GR"You have canceled installation! Bye! Bye!"$NC
    exit 1
fi

# Stop and delete the eqt-postgres container if it exists
if [ ! -z "$EQTPG_CONTAINER_ID" ]; then
    echo ""
    echo -e $PR"Stopping eqt-postgres Container"$NC
    sudo docker stop $EQTPG_CONTAINER_ID >/dev/null; sleep 1
    echo -e $PR"Removing eqt-postgres Container"$NC
    sudo docker rm $EQTPG_CONTAINER_ID >/dev/null; sleep 1
fi

# Stop and delete the equito container if it exists
if [ ! -z "$EQUITO_CONTAINER_ID" ]; then
    echo ""
    echo -e $CY"Stopping equito Container"$NC
    sudo docker stop $EQUITO_CONTAINER_ID >/dev/null; sleep 1
    echo -e $CY"Removing equito Container"$NC
    sudo docker rm $EQUITO_CONTAINER_ID >/dev/null; sleep 1
fi

# Checking whether the containers were successfully deleted
if [ -z "$(sudo docker ps -a -q -f name=eqt-postgres)" ] && [ -z "$(sudo docker ps -a -q -f name=equito)" ]; then
    echo ""
    echo -e $GR"The eqt-postgres and equito containers have been stopped and removed successfully."$NC
else
    # Check each container separately
    if [ ! -z "$(sudo docker ps -a -q -f name=eqt-postgres)" ]; then
        echo ""
        echo -e $RED"Failed to stop and remove the eqt-postgres container. Please investigate manually."$NC
        exit 1
    fi
    if [ ! -z "$(sudo docker ps -a -q -f name=equito)" ]; then
        echo ""
        echo -e $RED"Failed to stop and remove the equito container. Please investigate manually."$NC
        exit 1
    fi
fi

# Download a new container image
sudo docker pull robindev912/equito-validator-node >/dev/null; sleep 1

# Retrieving the existing password if it exists in the .env file
EXISTING_PASSWORD=$(grep -oP 'DATABASE_URL=postgresql://postgres:\K[^@]+' ~/.equito-node/.env)

# Suggest for the customer to use an existing password if it was found in the .env file
if [ ! -z "$EXISTING_PASSWORD" ]; then
    echo ""
    echo -e $GR"Great! An existing password was found in the .env file: $EXISTING_PASSWORD"$NC
    echo -ne $YW"Do you want to use this password? (y/n): "$NC
    read USE_EXISTING

    if [[ "$USE_EXISTING" =~ ^[Yy](es)?$ ]]; then
        POSTGRES_PASSWORD=$EXISTING_PASSWORD
    else
        # Request a new password and update the .env file if the customer want to use another one
        echo ""
        echo -e $PR"Enter the new password for PostgreSQL:"$NC
        read -s POSTGRES_PASSWORD
        echo -e $CY"Confirm the new password:"$NC
        read -s POSTGRES_PASSWORD_CONFIRM

        while [ "$POSTGRES_PASSWORD" != "$POSTGRES_PASSWORD_CONFIRM" ]; do
            echo ""
            echo -e $RED"Passwords do not match. Please try again."$NC
            echo ""
            echo -e $PR"Enter the new password for PostgreSQL:"$NC
            read -s POSTGRES_PASSWORD
            echo -e $CY"Confirm the new password:"$NC
            read -s POSTGRES_PASSWORD_CONFIRM
        done

        # Update the password in the .env file
        sed -i "s/$EXISTING_PASSWORD/$POSTGRES_PASSWORD/" ~/.equito-node/.env
    fi
else
    # Request to enter a new password if the existing one is not found inside .env file
    echo ""
    echo -e $PR"Enter the new password for PostgreSQL:"$NC
    read -s POSTGRES_PASSWORD
    echo -e $CY"Confirm the new password:"$NC
    read -s POSTGRES_PASSWORD_CONFIRM

    while [ "$POSTGRES_PASSWORD" != "$POSTGRES_PASSWORD_CONFIRM" ]; do
        echo ""
        echo $RED"Passwords do not match. Please try again."$NC
        echo ""
        echo -e $PR"Enter the new password for PostgreSQL:"$NC
        read -s POSTGRES_PASSWORD
        echo -e $CY"Confirm the new password:"$NC
        read -s POSTGRES_PASSWORD_CONFIRM
    done
fi

# Runnung the eqt-postgres container
sudo docker run --name eqt-postgres -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD -p 5432:5432 -d postgres >/dev/null
sleep 10;

# Checking if the eqt-postgres container is running
if [ "$(sudo docker inspect --format='{{.State.Status}}' eqt-postgres)" = "running" ]; then
    echo ""
    echo -e $GR"The eqt-postgres container has started successfully and is running."$NC
else
    echo ""
    echo $RED"Failed to start the eqt-postgres container. Please investigate the error manually."$NC
    exit 1
fi

# Running the equito-node container
cd ~/.equito-node && sudo docker run --env-file ~/.equito-node/.env -d --platform linux/x86_64/v8 --name equito-node -it -p 7890:7890 --add-host=host.docker.internal:host-gateway robindev912/equito-validator-node >/dev/null

# Checking if the equito-node container is running
if [ "$(sudo docker inspect --format='{{.State.Status}}' equito-node)" = "running" ]; then
    echo -e $GR"The equito-node container has started successfully and is running."$NC
else
    echo -e $RED"Failed to start the equito-node container. Please investigate the error manually."$NC
    exit 1
fi
echo ""
echo -e $CY"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"$NC
echo -e $GR"Congrats! The update process has been completed successfully."$NC
echo -e $CY"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"$NC


echo ""
echo -e $YW"############################################################"$NC
echo -e $YW"#"$NC $CY"To check the logs of the Docker Container, please run:  "$NC $YW"#"$NC
echo -e $YW"#"$NC $CY"sudo docker logs equito-node                            "$NC $YW"#"$NC
echo -e $YW"############################################################"$NC
