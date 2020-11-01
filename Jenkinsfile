pipeline {
    agent any

    tools {
        terraform "terraform"
    }

    stages {

        stage ('Get git repo') {
            steps {
                git 'https://github.com/zi10ge/awstest.git'
            }
        }
        
        stage('create AWS instances') {
            steps {
                  withAWS(credentials: 'aws4CW') {
                    sh 'terraform init'
                    sh 'terraform plan -out config.out'
                    sh 'terraform apply config.out'
                }
            }
        }
    }
}