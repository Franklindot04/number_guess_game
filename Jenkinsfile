pipeline {
    agent any

    environment {
        SONAR_TOKEN = credentials('sonar-token')
        NEXUS_USER = credentials('nexus-user')
        NEXUS_PASS = credentials('nexus-pass')
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

        stage('Deploy to Nexus') {
            steps {
                sh """
                mvn deploy \
                    -DskipTests \
                    -DaltDeploymentRepository=releases::default::http://13.62.76.132:8081/nexus/content/repositories/releases/ \
                    -Dnexus.username=${NEXUS_USER} \
                    -Dnexus.password=${NEXUS_PASS}
                """
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                sh """
                curl -u tomcat-user:tomcat-password \
                     -T target/NumberGuessGame-1.0.war \
                     "http://13.60.183.176:8080/guess/manager/text/deploy?path=/guess&update=true"
                """
            }
        }
    }

        post {
        always {
            archiveArtifacts artifacts: 'target/*.war', allowEmptyArchive: true
            junit 'target/surefire-reports/*.xml'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs.'
        }
    }
}       
