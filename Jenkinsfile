pipeline {
    agent any

    tools {
        maven 'maven3'
        jdk 'JDK21'
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
                sshagent(['tomcat-deploy-key']) {
                    sh '''
                        echo "Deploying WAR file to Tomcat server..."

                        mkdir -p /var/lib/jenkins/.ssh
                        ssh-keyscan -H 16.170.35.114 >> /var/lib/jenkins/.ssh/known_hosts

                        # Copy ANY WAR file produced by Maven (version-agnostic)
                        scp target/*.war ec2-user@16.170.35.114:/tmp/

                        # Deploy automatically to Tomcat (no version hardcoding)
                        ssh ec2-user@16.170.35.114 '
                            sudo cp /tmp/*.war /opt/tomcat/webapps/
                            sudo systemctl restart tomcat
                            sleep 5
                        '

                        echo "Deployment to Tomcat completed."
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
            echo "Access application at: http://16.170.35.114:8080/"
        }
    }
}

