pipeline {
    agent any

    environment {
        SONAR_TOKEN = credentials('sonar-token')
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
                # Only run if a WAR file exists
                if [ -f target/NumberGuessGame-1.0.war ]; then
                    curl --upload-file target/NumberGuessGame-1.0.war \
                         --user tomcat-user:tomcat-password \
                         http://13.60.183.176:8080/manager/text/deploy?path=/guess&update=true
                else
                    echo "No WAR file found, skipping deploy."
                fi
                """
            }
        }
    }

    post {
        always {
            // Wrap in a node to ensure workspace access
            node {
                archiveArtifacts artifacts: 'target/*.war', allowEmptyArchive: true
                junit 'target/surefire-reports/*.xml'
            }
        }
    }
}

