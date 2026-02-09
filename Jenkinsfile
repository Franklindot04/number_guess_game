pipeline {
    agent any

    tools {
        maven 'Maven3'
        jdk 'jdk21'
    }

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

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh """
                        mvn sonar:sonar \
                        -Dsonar.projectKey=NumberGuessGame \
                        -Dsonar.host.url=http://13.53.42.115:9000 \
                        -Dsonar.login=${SONAR_TOKEN}
                    """
                }
            }
        }

        stage('Deploy to Nexus') {
            steps {
                sh 'mvn clean deploy'
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                sshagent(['ec2-user']) {
                    sh '''
                        echo "Deploying WAR file to Tomcat server..."
                        mkdir -p /var/lib/jenkins/.ssh
                        ssh-keyscan -H 16.170.35.114

                        scp target/NumberGuessGame-1.0.war ec2-user@16.170.35.114:/tmp/

                        ssh ec2-user@16.170.35.114 '
                            sudo cp /tmp/NumberGuessGame-1.0.war /opt/tomcat/webapps/
                            sudo systemctl restart tomcat
                            sleep 5
                            if sudo ls /opt/tomcat/webapps/NumberGuessGame-1.0.war > /dev/null 2>&1; then
                                echo "Deployment successful!"
                            else
                                echo "Deployment failed!"
                                exit 1
                            fi
                        '
                    '''
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline execution completed."
        }
        success {
            echo "CI/CD Pipeline completed successfully. Application deployed to Tomcat."
            echo "Access application at: http://16.170.35.114:8080/NumberGuessGame-1.0/"
        }
    }
}

