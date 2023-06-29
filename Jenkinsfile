pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('Fetch Terraform Code') {
            steps {
                dir('terraform') {
                    git branch: 'main', url: 'https://github.com/devopsDemobyManoj/Terraform-AWS.git'
                }
                
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
                        def outputValue = sh(returnStdout: true, script: "terraform output -raw public_ip").trim()
                        echo "Output Variable Value: ${outputValue}"
                    }
                }
            }
        }
        stage('ansible') {
            steps {
                dir('terraform') {
                    script {
                        // Fetch Terraform output
                        def publicIP = sh(returnStdout: true, script: 'terraform output -raw public_ip').trim()
                        echo "Output Variable Value: ${publicIP}"
                    
                        // Get SSH key from Jenkins credentials
                        def privateKeyPath = "${env.JENKINS_HOME}/jenkinsDemo.pem"
                        env.server_ip = publicIP
                        // Execute Ansible playbook
                        sh "ansible-playbook -i inventory.ini httpd.yml"
                        
                    }
                }
            }
        }
    }
}
