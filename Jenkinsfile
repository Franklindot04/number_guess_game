pipeline {
    agent any

    environment {
        SONAR_TOKEN = credentials('sonar-token') // SonarQube token stored in Jenkins
        TOMCAT_USER = credentials('tomcat-user') // Tomcat username stored in Jenkins
        TOMCAT_PASS = credentials('tomcat-pass') // Tomcat password stored in Jenkins
        TOMCAT_URL  = "http://13.60.183.176:8080/guess/manager/text" // Tomcat Manager URL
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

        stage('Deploy to Tomcat') {
            steps {
                sh """
                    curl -u ${TOMCAT_USER}:${TOMCAT_PASS} \
                        -T target/NumberGuessGame-1.0.war \
                        "${TOMCAT_URL}/deploy?path=/guess&update=true"
                """
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

