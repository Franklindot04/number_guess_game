pipeline {
    agent any

    tools {
        maven 'Maven3'    // Your Maven installation in Jenkins
        jdk 'JDK21'       // Your JDK installation in Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Test') {
            steps {
                sh 'mvn clean verify'
            }
        }

        stage('Package WAR') {
            steps {
                sh 'mvn package'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {   // Name must match Jenkins SonarQube server
                    sh 'sonar-scanner -Dsonar.projectKey=number_guess_game -Dsonar.sources=src'
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'target/*.war', allowEmptyArchive: true
            junit 'target/test-classes/**/*.xml'
        }
    }
}

