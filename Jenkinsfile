pipeline {
    agent any
environment {
        // Set environment variables for Vault token, etc.
        VAULT_ADDR = 'http://3.106.54.97:8200'
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
