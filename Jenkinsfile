pipeline {
    agent any

    stages {
        stage('Clone Repo') {
            steps {
                git url: 'https://github.com/Sohail52/DevOps-Project.git', branch: 'main'
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent (credentials: ['54.167.91.251']) {
                    sh 'ssh -o StrictHostKeyChecking=no ec2-user@54.167.91.251 "bash ~/deploy.sh"'
                }
            }
        }
    }
}
