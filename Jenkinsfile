pipeline {
    agent any

    tools {
        maven 'Maven3'    // make sure this matches your Jenkins Maven installation
        jdk 'JDK21'       // make sure this matches your Jenkins JDK installation
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
                withSonarQubeEnv('SonarQube') {
                    // Use a known working plugin version
                    sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.9.1.2184:sonar -Dsonar.projectKey=number_guess_game -Dsonar.sources=src'
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

