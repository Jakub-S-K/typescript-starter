pipeline {
    agent any

    environment {
        APP_VERSION = "1.0.${BUILD_NUMBER}"
        IMAGE_NAME = "nestjs-app"
    }

    stages {
        stage('Clone') {
            steps {
                git branch: 'master', url: 'https://github.com/Jakub-S-K/typescript-starter.git'
            }
        }

        stage('Build') {
            steps {
                sh "docker build --target builder -t ${IMAGE_NAME}-build:${BUILD_NUMBER} ."
            }
        }

        stage('Test') {
            steps {
                sh "docker build --target tester -t ${IMAGE_NAME}-tester:${BUILD_NUMBER} ."
            }
        }

        stage('Deploy') {
            steps {
                sh "docker build --target deploy -t ${IMAGE_NAME}:${APP_VERSION} ."
            }
        }

        stage('Smoke Test') {
            steps {
                sh "docker run -d --name smoke-test-app -p 3000:3000 ${IMAGE_NAME}:${APP_VERSION}"
                sleep 5
                sh 'docker run --rm --network container:smoke-test-app curlimages/curl -s -f http://localhost:3000 || (docker rm -f smoke-test-app && exit 1)'
                sh "docker rm -f smoke-test-app"
            }
        }

        stage('Publish') {
            steps {
                sh "docker save ${IMAGE_NAME}:${APP_VERSION} -o ${IMAGE_NAME}-${APP_VERSION}.tar"
                archiveArtifacts artifacts: '*.tar, Dockerfile, Jenkinsfile', allowEmptyArchive: false
            }
        }
    }

    post {
        always {
            sh "docker rm -f smoke-test-app || true"
            sh "docker rmi ${IMAGE_NAME}-tester:${BUILD_NUMBER} || true"
        }
    }
}
