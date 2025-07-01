pipeline {
    agent any

    environment {
        IMAGE_NAME = "mohamedrizlan/devops-project"
        DOCKERFILE_PATH = "app/Dockerfile"
        KUBECONFIG_CREDENTIALS = 'kubeconfig-credentials-id'  // Replace with your Jenkins credentials ID for kubeconfig
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                bat """
                docker build -t %IMAGE_NAME% -f %DOCKERFILE_PATH% .
                """
            }
        }

        stage('Docker Login & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                    bat """
                    docker login -u %DOCKERHUB_USERNAME% -p %DOCKERHUB_PASSWORD%
                    docker push %IMAGE_NAME%
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                // Use kubeconfig from Jenkins credentials
                withCredentials([file(credentialsId: KUBECONFIG_CREDENTIALS, variable: 'KUBECONFIG_FILE')]) {
                    // Set environment variable KUBECONFIG to point to this file
                    bat """
                    set KUBECONFIG=%KUBECONFIG_FILE%
                    kubectl apply -f k8s/deployment.yaml
                    """
                }
            }
        }
    }

    post {
        always {
            bat 'docker rmi %IMAGE_NAME%'
        }
    }
}
