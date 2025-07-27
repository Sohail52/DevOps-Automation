pipeline {
    agent any

    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main', 
                    url: 'https://github.com/Sohail52/DevOps-Project.git'
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(credentials: ['ec2-ssh-key']) {
                    sh 'ssh -o StrictHostKeyChecking=no ec2-user@${EC2_HOST} "bash ~/deploy.sh"'

                }
            }
        }
    }
}
