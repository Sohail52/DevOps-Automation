pipeline {
    agent any
    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main', 
                    credentialsId: '54.167.91.251',
                    url: 'https://github.com/Sohail52/DevOps-Project.git'
            }
        }
        stage('Deploy to EC2') {
            steps {
                sshagent(credentials: ['54.167.91.251']) {
                    sh 'ssh -o StrictHostKeyChecking=no ec2-user@54.167.91.251 "bash ~/deploy.sh"'
                }
            }
        }
    }
}
