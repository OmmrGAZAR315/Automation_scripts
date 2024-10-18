#!/bin/bash

# Variables
LOCAL_FILE_PATH=$1
ARCHIVE_NAME=$2
REMOTE_USER="root"
REMOTE_HOST=$3
REMOTE_PASS=$4
REMOTE_DIR=$5


# Compress the file
tar -cvzf $ARCHIVE_NAME -C $(dirname $LOCAL_FILE_PATH) $(basename $LOCAL_FILE_PATH)

echo "File compressed successfully."
ssh-keyscan -H $REMOTE_HOST >> ~/.ssh/known_hosts
sshpass -p $REMOTE_PASS rsync --progress -avz $ARCHIVE_NAME $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR

echo "File transferred successfully."
if [ -n "$6" ]; then
        sshpass -p $REMOTE_PASS ssh $REMOTE_USER@$REMOTE_HOST "cd $REMOTE_DIR && tar -xvzf $ARCHIVE_NAME"
        sshpass -p $REMOTE_PASS ssh $REMOTE_USER@$REMOTE_HOST "rm $REMOTE_DIR/$ARCHIVE_NAME"
fi

echo "File extracted successfully."

rm -r $ARCHIVE_NAME

echo "File transferred and extracted successfully."

