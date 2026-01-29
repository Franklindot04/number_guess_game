pipeline {
    agent any

    environment {
        // Replace this with your actual token
        SONAR_TOKEN = 'sqa_fdb1905a4661313553134316cccdc988e4a8b0db'
        MAVEN_HOME = tool name: 'Maven 3.9.1', type: 'maven' // adjust Maven tool name in Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Test') {
            steps {
                withEnv(["PATH+MAVEN=${MAVEN_HOME}/bin"]) {
                    sh 'mvn clean verify jacoco:report'
                }
            }
        }

        stage('Package WAR') {
            steps {
                withEnv(["PATH+MAVEN=${MAVEN_HOME}/bin"]) {
                    sh 'mvn package'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withEnv(["PATH+MAVEN=${MAVEN_HOME}/bin"]) {
                    sh """
                    mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.9.1.2184:sonar \
                        -Dsonar.projectKey=number_guess_game \
                        -Dsonar.sources=src/main/java \
                        -Dsonar.tests=src/test/java \
                        -Dsonar.java.binaries=target/classes \
                        -Dsonar.junit.reportPaths=target/surefire-reports \
                        -Dsonar.coverage.jacoco.xmlReportPaths=target/site/jacoco/jacoco.xml \
                        -Dsonar.token=${SONAR_TOKEN}
                    """
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

