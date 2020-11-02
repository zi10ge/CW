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
                withCredentials([usernamePassword(credentialsId: 'docker', passwordVariable: 'DOCKER_USER', usernameVariable: 'DOCKER_PASS')]) {
                  // sh 'ansible-playbook ansible.yml -i hosts --extra-vars "foo1=${DOCKER_USER} foo2=${DOCKER_PASS}" -vv'
                }                
            }
        }
    }
}