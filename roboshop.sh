#!/bin/bash

AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-0d3f2c710c9cc8168" # replace with your SG ID
INSTANCES=("frontend" "mysql" "backend")
ZONE_ID="Z0897598ZW3D3944XUN0" # replace with your ZONE ID
DOMAIN_NAME="sree84s.site" # replace with your domain

#for instance in $@
for instance in $@
do
    INSTANCES_ID=$(aws ec2 run-instances --image-id ami-09c813fb71547fc4f --instance-type t3.micro --security-group-ids sg-0966b3c93f0131a22 --tag-specifications "ResourceType=instance,Tags=[{Key=Name, Value=$instance}]" --query "Instances[0].InstanceId" --output text)
    if [ $instnce != "frontend" ]
    then
        IP=$(aws ec2 describe-instance --instance-ids $INSTANCES_ID --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)
        RECORD_NAME="$instance.$DOMAIN_NAME"
    else
        IP=$(aws ec2 describe-instance --instance-ids $INSTANCES_ID --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
        RECORD_NAME="$DOMAIN_NAME"
    fi
    echo "$instance IP address: $IP"

    aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch '
    {
        "Comment": "Creating or Updating a record set for cognito endpoint"
        ,"Changes": [{
        "Action"             : "UPSERT"
        ,"ResourceRecordSet" : {
            "Name"              : "'$RECORD_NAME'"
            ,"Type"             : "A"
            ,"TTL               : 1
            ,"ResourceRecords"  : [{
                "Value"         : "'$IP'"
            }]
        }
        }]
    }'
done