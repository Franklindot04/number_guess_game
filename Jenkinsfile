pipeline {
    agent any

    environment {
        SONAR_TOKEN = credentials('sonar-token') // SonarQube token
        NEXUS_USERNAME = credentials('nexus-username') // Nexus username
        NEXUS_PASSWORD = credentials('nexus-password') // Nexus password
        TOMCAT_USER = credentials('tomcat-user') // Tomcat manager username
        TOMCAT_PASS = credentials('tomcat-pass') // Tomcat manager password
        WAR_NAME = 'NumberGuessGame-1.0.war'
        TARGET_WAR = "target/${WAR_NAME}"
        NEXUS_URL = 'http://13.62.76.132:8081/repository/releases/'
        TOMCAT_URL = 'http://13.60.183.176:8080/manager/text/deploy?path=/guess&update=true'
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
                mvn deploy:deploy-file \
                    -Durl=${NEXUS_URL} \
                    -DrepositoryId=releases \
                    -Dfile=${TARGET_WAR} \
                    -DgroupId=com.studentapp \
                    -DartifactId=NumberGuessGame \
                    -Dversion=1.0 \
                    -Dpackaging=war \
                    -DgeneratePom=true \
                    -DrepositoryId=releases \
                    -Dusername=${NEXUS_USERNAME} \
                    -Dpassword=${NEXUS_PASSWORD}
                """
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                sh """
                curl --upload-file ${TARGET_WAR} --user ${TOMCAT_USER}:${TOMCAT_PASS} "${TOMCAT_URL}"
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
            echo "Pipeline completed successfully. WAR deployed to Nexus and Tomcat!"
        }
        failure {
            echo "Pipeline failed. Check the logs above."
        }
    }
}

