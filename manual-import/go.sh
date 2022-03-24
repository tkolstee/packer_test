#!/bin/bash

aws ec2 import-image --description "Manual import" --disk-containers "file://$(pwd)/containers.json"
aws ec2 describe-import-image-tasks
echo -n "TASK (like import-ami-xxxx): "
read task
watch -d "aws ec2 describe-import-image-tasks --import-task-ids ${task}"
