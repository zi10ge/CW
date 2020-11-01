pipeline {
    agent any

    tools {
        terraform "terraform"
    }

    stages {

        stage ('Get git repo') {
            steps {
                git 'https://github.com/zi10ge/CW.git'
            }
        }
        
        stage('Create AWS instances') {
            steps {
                  withAWS(credentials: 'aws4CW') {
                    sh 'terraform init'
                    sh 'terraform plan -out config.out'
                    sh 'terraform apply config.out'
                }
            }
        }

        stage('Configure instances, build and provision app with ansible') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                   ansiblePlaybook disableHostKeyChecking: true, becomeUser: 'ubuntu', extras: '-vv', installation: 'ansible', inventory: 'hosts', playbook: 'ansible.yml'
                }                
            }
        }
    }
}