pipeline {
    agent any

    environment {
        VAULT_ADDR = 'http://3.106.54.97:8200'
        TF_VAR_vault_role_id = credentials('vault_role_id')
        TF_VAR_vault_secret_id = credentials('vault_secret_id')
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from your GitHub repository
                git branch: 'main', url: 'https://github.com/ritishreddy/terraform-0987.git'
            }
        }

        stage('Terraform Init') {
            steps {
                // Initialize Terraform
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                // Run Terraform plan
                sh 'terraform plan'
            }
        }

        stage('Terraform Apply') {
            steps {
                // Apply the Terraform plan, you can use -auto-approve to skip confirmation
                sh 'terraform apply -auto-approve'
            }
        }
    }

    post {
        always {
            // Clean up workspace after execution
            cleanWs()
        }
    }
}
