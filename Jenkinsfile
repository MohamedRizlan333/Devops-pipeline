pipeline {
    agent any

    environment {
        IMAGE_NAME = 'mohamedrizlan/devops-project'
        DOCKERHUB_CREDENTIALS = 'dockerhub-creds'  // Your Jenkins Docker Hub credentials ID
        KUBECONFIG_CREDENTIALS = 'kubeconfig-creds' // Jenkins credential ID storing your kubeconfig file (if used)
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/MohamedRizlan333/Devops-pipeline.git', branch: 'main'
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    // Build Docker image using Dockerfile inside app folder
                    sh 'docker build -t $IMAGE_NAME -f app/Dockerfile app/'
                }
            }
        }

        stage('Docker Login') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', DOCKERHUB_CREDENTIALS) {
                        echo "Logged into Docker Hub"
                    }
                }
            }
        }

        stage('Docker Push') {
            steps {
                script {
                    sh "docker push $IMAGE_NAME"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: KUBECONFIG_CREDENTIALS, variable: 'KUBECONFIG_FILE')]) {
                    script {
                        // Set KUBECONFIG env var so kubectl uses this config
                        env.KUBECONFIG = KUBECONFIG_FILE

                        // Apply deployment and service YAMLs (update path if different)
                        sh 'kubectl apply -f k8s/deployment.yaml'
                        sh 'kubectl apply -f k8s/service.yaml'
                    }
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
