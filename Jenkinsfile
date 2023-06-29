def aws_server_ip
pipeline {
    agent any

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('checkout') {
            steps {
                script {
                    dir("terraform") {
                        checkout([$class: 'GitSCM', branches: [[name: '*/main']],
                            userRemoteConfigs: [[url: 'https://github.com/devopsDemobyManoj/Terraform-AWS.git']]])
                    }
                }
            }
        }

        stage('Plan') {
            steps {
                sh 'pwd;cd terraform/ ; terraform init'
                sh "pwd;cd terraform/ ; terraform plan -out tfplan"
                sh 'pwd;cd terraform/ ; terraform show -no-color tfplan > tfplan.txt'
            }
        }

        stage('Approval') {
            when {
                not {
                    equals expected: true, actual: params.autoApprove
                }
            }
            steps {
                script {
                    def plan = readFile 'terraform/tfplan.txt'
                    input message: "Do you want to apply the plan?",
                          parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }

        stage('terraform apply') {
            steps {
                sh "pwd;cd terraform/ ; terraform apply -auto-approve -input=false -no-color tfplan | tee tfoutput.txt"
                script {
                    aws_server_ip = readFile('terraform/tfoutput.txt').readLines().find { it =~ /public_ip\s+=/ }.split('=')[1].trim()
                    echo "The captured IP is: ${aws_server_ip}"
                }
            }
        }

        stage('ansible') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: '3096090d-3385-483b-b880-3a58dbf64b46	', keyFileVariable: 'SSH_PRIVATE_KEY')]) {
                    script {
                        writeFile file: 'inventory.ini', text: "[webserver]\n${aws_server_ip} ansible_user=ec2-user ansible_ssh_private_key_file=${env.SSH_PRIVATE_KEY}"
                    }
                }
                sh """
                    cd terraform ; ansible-playbook -i inventory.ini httpd.yml
                """
            }
        }
    }
}
