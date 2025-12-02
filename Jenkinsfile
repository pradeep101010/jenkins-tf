pipeline {
    agent any

    environment {
        TF_WORKING_DIR = "." 
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws_access_key', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'secret', variable: 'AWS_SECRET_ACCESS_KEY'),
                    string(credentialsId: 'session_token', variable: 'AWS_SESSION_TOKEN') // optional
                ]) {
                    sh '''
                        cd day1
                        terraform init -input=false
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws_access_key', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'secret', variable: 'AWS_SECRET_ACCESS_KEY'),
                    string(credentialsId: 'session_token', variable: 'AWS_SESSION_TOKEN') // optional
                ]) {
                    sh """
                    cd ${TF_WORKING_DIR}
                    terraform plan -out=tfplan -input=false
                    """
                }
            }
        }

        stage('Approval') {
            when {
                anyOf {
                    branch 'main'
                    branch 'master'
                }
            }
            steps {
                input message: "Approve Terraform Apply on ${env.BRANCH_NAME}?"
            }
        }

        stage('Terraform Apply') {
            when {
                anyOf {
                    branch 'main'
                    branch 'master'
                }
            }
            steps {
                withCredentials([
                    string(credentialsId: 'aws_access_key', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'secret', variable: 'AWS_SECRET_ACCESS_KEY'),
                    string(credentialsId: 'session_token', variable: 'AWS_SESSION_TOKEN') // optional
                ]) {
                    sh """
                    cd ${TF_WORKING_DIR}
                    terraform apply -input=false tfplan
                    """
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning up workspace..."
            cleanWs()
        }
        failure {
            echo "Pipeline failed!"
        }
        success {
            echo "Terraform deployment complete!"
        }
    }
}
