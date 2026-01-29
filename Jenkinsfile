pipeline {
    agent any

    tools {
        maven 'Maven3'    // Name of Maven installation in Jenkins
        jdk 'JDK21'       // Name of JDK installation in Jenkins
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

        stage('SonarQube Analysis') {
            environment {
                SONAR_TOKEN = credentials('sonar-token')  // Jenkins credential name for the SonarQube token
            }
            steps {
                sh "mvn sonar:sonar -Dsonar.projectKey=number_guess_game -Dsonar.host.url=http://localhost:9000 -Dsonar.login=$SONAR_TOKEN"
            }
        }
    }
}

