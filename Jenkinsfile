pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('Fetch Terraform Code') {
            steps {
                git branch: 'main', url: 'https://github.com/devopsDemobyManoj/Terraform-AWS.git'
            }
        }

        stage('Initialize') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }
        
        stage('Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }
        
        stage('Approval') {
            steps {
                // Implement your approval mechanism here
                input 'Proceed with the deployment?'
            }
        }
        
        stage('Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply tfplan'
                }
            }
        }
        
        stage('Fetch Output Variable') {
            steps {
                dir('terraform') {
                    script {
                        def outputValue = sh(returnStdout: true, script: "terraform output -raw variable_name").trim()
                        echo "Output Variable Value: ${outputValue}"
                    }
                }
            }
        }
    }
}
