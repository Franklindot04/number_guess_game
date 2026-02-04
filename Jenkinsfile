pipeline {
    agent any

    tools {
        maven 'Maven3'
        jdk 'JDK21'
    }

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

        stage('Package') {
            steps {
                sh 'mvn package'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
                        sh """
                            mvn sonar:sonar \
                              -Dsonar.projectKey=NumberGuessGame \
                              -Dsonar.login=$SONAR_TOKEN
                        """
                    }
                }
            }
        }

        stage('Deploy to Nexus') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'nexus-user', usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PASS')]) {
                    sh """
                        mvn deploy \
                          -DskipTests \
                          -DaltDeploymentRepository=releases::default::http://13.62.76.132:8081/nexus/content/repositories/releases/ \
                          -Dnexus.username=$NEXUS_USER \
                          -Dnexus.password=$NEXUS_PASS
                    """
                }
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                sshagent(['tomcat-deploy-key']) {
                    sh """
                        echo "Deploying WAR file to Tomcat server..."

                        mkdir -p ~/.ssh
                        ssh-keyscan -H 13.60.183.176 >> ~/.ssh/known_hosts 2>/dev/null

                        scp target/NumberGuessGame-1.0.war ec2-user@13.60.183.176:/tmp/

                        ssh ec2-user@13.60.183.176 '
                            sudo cp /tmp/NumberGuessGame-1.0.war /opt/tomcat/webapps/
                            sudo systemctl restart tomcat
                            sleep 5
                            if sudo ls /opt/tomcat/webapps/NumberGuessGame-1.0.war > /dev/null 2>&1; then
                                echo "✅ Deployment successful!"
                            else
                                echo "❌ Deployment failed!"
                                exit 1
                            fi
                        '
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'CI/CD Pipeline completed successfully. Application deployed to Tomcat.'
            echo "Access application at: http://13.60.183.176:8080/guess/"
        }
        failure {
            echo 'Pipeline failed. Check Jenkins logs.'
        }
        always {
            echo 'Pipeline execution completed.'
        }
    }
}

