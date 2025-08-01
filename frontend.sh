#!/bin/bash

# R="\e[31m"
# G="\e[32m"
# Y="\e[33m"
# B="\e[34m"
# N="\e[0m"
# USERID=$(id -u)
# TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
# LOGS_FOLDER="/var/log/expense1-logs"
# LOGS_FILE=$(echo $0 | cut -d "." -f1)
# lOGS_FILE_NAME="$LOGS_FOLDER/$LOGS_FILE-$TIMESTAMP.log"

# CHECK_ROOT(){
#     if [ $USERID -ne 0 ]
#     then 
#         echo -e "ERROR:: $B You must be root user to execute this script $N "
#         exit 1
#     fi 
# }

# mkdir -p $LOGS_FOLDER
# echo "Script started executing at:: $TIMESTAMP" &>>$lOGS_FILE_NAME

# CHECK_ROOT

# VALIDATE() {
#     if [ $1 -ne 0 ]
#     then 
#         echo -e "$2 ...... $R FAILURE $N "
#         exit 1
#     else 
#         echo -e "$2 ...... $G SUCCESS $N "
#     fi
# }

# dnf install nginx -y &>>$lOGS_FILE_NAME
# VALIDATE $? "Installing nginx"

# systemctl enable nginx &>>$lOGS_FILE_NAME
# VALIDATE $? "Enabling nginx"

# systemctl start nginx &>>$lOGS_FILE_NAME
# VALIDATE $? "Starting nginx"

# rm -rf /usr/share/nginx/html/* &>>$LOGS_FILE_NAME
# VALIDATE $? "Removing existing version of code"

# curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGS_FILE_NAME
# VALIDATE $? "Downloading Latest code"

# cd /usr/share/nginx/html
# VALIDATE $? "Moving to HTML directory"

# unzip /tmp/frontend.zip &>>$LOGS_FILE_NAME
# VALIDATE $? "unzipping the frontend code"

# cp /home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf
# VALIDATE $? "Copied expense config"

# systemctl restart nginx &>>$LOGS_FILE_NAME
# VALIDATE $? "Restarting nginx"

#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/expense-logs"
LOG_FILE=$(echo $0 | cut -d "." -f1 )
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE_NAME="$LOGS_FOLDER/$LOG_FILE-$TIMESTAMP.log"

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then
        echo "ERROR:: You must have sudo access to execute this script"
        exit 1 #other than 0
    fi
}

mkdir -p $LOGS_FOLDER
echo "Script started executing at: $TIMESTAMP" &>>$LOG_FILE_NAME

CHECK_ROOT

dnf install nginx -y  &>>$LOG_FILE_NAME
VALIDATE $? "Installing Nginx Server"

systemctl enable nginx &>>$LOG_FILE_NAME
VALIDATE $? "Enabling Nginx server"

systemctl start nginx &>>$LOG_FILE_NAME
VALIDATE $? "Starting Nginx Server"

rm -rf /usr/share/nginx/html/* &>>$LOG_FILE_NAME
VALIDATE $? "Removing existing version of code"

mkdir -p /usr/share/nginx/html
VALIDATE $? "Creating html path"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOG_FILE_NAME
VALIDATE $? "Downloading Latest code"

cd /usr/share/nginx/html
VALIDATE $? "Moving to HTML directory"

unzip /tmp/frontend.zip &>>$LOG_FILE_NAME
VALIDATE $? "unzipping the frontend code"

cp /home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf
VALIDATE $? "Copied expense config"

systemctl restart nginx &>>$LOG_FILE_NAME
VALIDATE $? "Restarting nginx"
