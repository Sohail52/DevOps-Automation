pipeline {
    agent any

    environment {
        EC2_USER = "ec2-user"         // or "ubuntu" based on your AMI
        EC2_HOST = "54.167.91.251"    // replace with your EC2 Public IP
        SSH_KEY = credentials('ec2-ssh-key') // ID from Jenkins credentials
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Sohail52/DevOps-Project.git'
            }
        }

        stage('Terraform Init + Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Deploy Flask App to EC2') {
            steps {
                sh '''
                ssh -o StrictHostKeyChecking=no -i $SSH_KEY $EC2_USER@$EC2_HOST << EOF
                    sudo yum install -y python3-pip
                    pip3 install flask
                    pkill -f app.py || true
                    cd ~/flask-app || mkdir -p ~/flask-app && cd ~/flask-app
                    rm -rf *
                    exit
                EOF

                scp -i $SSH_KEY flask-app/* $EC2_USER@$EC2_HOST:~/flask-app/

                ssh -i $SSH_KEY $EC2_USER@$EC2_HOST << EOF
                    cd ~/flask-app
                    nohup python3 app.py > output.log 2>&1 &
                EOF
                '''
            }
        }
    }
}
