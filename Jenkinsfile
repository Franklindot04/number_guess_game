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
                withSonarQubeEnv('SonarQube') {   // Must match your Jenkins SonarQube server name
                    sh 'mvn sonar:sonar -Dsonar.projectKey=number_guess_game -Dsonar.sources=src'
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'target/*.war', allowEmptyArchive: true
            junit 'target/surefire-reports/*.xml'
        }
    }
}

