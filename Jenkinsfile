def COLOR_MAP = [
    'SUCCESS': 'good',
    'FAILURE': 'danger',
    'UNSTABLE': 'warning',
    'ABORTED': '#CCCCCC'
]

pipeline {
    agent any
    
    tools {
        maven 'MAVEN'
        jdk 'JDK21'
    }
    
    environment {
        SONARQUBE_SERVER = 'Sonar'   // Jenkins SonarQube server config name
        NEXUS_CRED = 'Nexus'         // Jenkins credentials ID for Nexus
        BUILD_TIMESTAMP = "${new Date().format('yyyyMMddHHmmss')}"
    }

    stages {
        stage("Checkout") {
            steps {
                git url: 'https://github.com/Dedeepya59/Online_Banking_Application.git'
            }
        }

        stage("Build") {
            steps {
                sh 'mvn clean package -DskipTests=true'
            }
        }

        stage("Checkstyle Report") {
            steps {
                sh 'mvn checkstyle:checkstyle'
            }
        }

        stage("SonarQube Analysis") {
            steps {
                script {
                    def scannerHome = tool 'Sonar'
                    withSonarQubeEnv("${SONARQUBE_SERVER}") {
                        sh """
                        ${scannerHome}/bin/sonar-scanner \
                        -Dsonar.projectKey=Online_Banking \
                        -Dsonar.projectName=Online_Banking \
                        -Dsonar.projectVersion=1.0 \
                        -Dsonar.sources=src/ \
                        -Dsonar.java.binaries=target/classes \
                        -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml \
                        -Dsonar.java.coveragePlugin=jacoco \
                        -Dsonar.jacoco.reportPaths=target/jacoco.exec \
                        -Dsonar.junit.reportPaths=target/surefire-reports/
                        """
                    }
                }
            }
        }

        stage("Quality Gate") {
            steps {
                timeout(time: 15, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage("Upload Artifacts to Nexus") {
            steps {
                script {
                    nexusArtifactUploader(
                        nexusVersion: 'nexus3',
                        protocol: 'http',
                        nexusUrl: 'localhost:8081',
                        groupId: 'QA',
                        version: "${env.BUILD_ID}-${env.BUILD_TIMESTAMP}",
                        repository: 'Online-Banking',
                        credentialsId: "${NEXUS_CRED}",
                        artifacts: [[
                            artifactId: 'Online-Banking',
                            classifier: '',
                            file: 'target/BankingApp-0.0.1-SNAPSHOT.jar',
                            type: 'jar'
                        ]]
                    )
                }
            }
        }
    } // stages end

    post {
        always {
            script {
                def result = currentBuild.currentResult
                def emoji = ""
                if (result == "SUCCESS") {
                    emoji = ":smile:"
                } else if (result == "FAILURE") {
                    emoji = ":cry:"
                } else if (result == "ABORTED") {
                    emoji = ":no_entry_sign:"
                } else {
                    emoji = ":warning:"
                }

                slackSend(
                    channel: '#devopscicd',
                    color: COLOR_MAP[result],
                    message: "${emoji} *${result}*: Job `${env.JOB_NAME}` build #${env.BUILD_NUMBER} \nCheck console: ${env.BUILD_NAME}"
                )
            }
        }
    }
}
