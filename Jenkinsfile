pipeline {
    agent any

    tools {
        terraform "terraform"
    }

    stages {
        stage ('Get git repository') {
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

        stage('Wate instances for SSH to come up') {
            steps {
                sh 'ansible-playbook local.yml -i hosts -vv'
            }
        }

        stage('Build app') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker', passwordVariable: 'DOCKER_USER', usernameVariable: 'DOCKER_PASS')]) {
                   sh 'ansible-playbook build.yml -i hosts --extra-vars "foo1=${DOCKER_USER} foo2=${DOCKER_PASS}" -vv'
                }                
            }
        }
        
        stage('Provision app') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker', passwordVariable: 'DOCKER_USER', usernameVariable: 'DOCKER_PASS')]) {
                   sh 'ansible-playbook stage.yml -i hosts --extra-vars "foo1=${DOCKER_USER} foo2=${DOCKER_PASS}" -vv'
                }                
            }
        }
    }
}