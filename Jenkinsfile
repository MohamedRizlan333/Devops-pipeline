pipeline {
    agent any

    environment {
        IMAGE_NAME = 'mohamedrizlan/devops-project'
        DOCKERHUB_CREDENTIALS = 'dockerhub-creds'
        KUBECONFIG_CREDENTIALS = 'kubeconfig-creds'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/MohamedRizlan333/Devops-pipeline.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t mohamedrizlan/devops-project -f app/Dockerfile app/'

            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', DOCKERHUB_CREDENTIALS) {
                        echo "Docker Hub login successful"
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                bat 'docker push %IMAGE_NAME%'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: KUBECONFIG_CREDENTIALS, variable: 'KUBECONFIG')]) {
                    bat """
                        set KUBECONFIG=%KUBECONFIG%
                        kubectl apply -f k8s\\deployment.yaml
                        kubectl apply -f k8s\\service.yaml
                    """
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
