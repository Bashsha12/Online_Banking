pipeline{
    agent any
    tools{
        maven 'MAVEN'
        jdk 'JDK21'
    }
    environment {
        SONARQUBE_SERVER = 'Sonar' // Replace with your SonarQube server name in Jenkins
        scannerHome = tool name: 'Sonar'
        Nexus = 'Nexus' // Replace with your Nexus server name in Jenkins
    }
    stages{
        stage("Checkout"){
            steps{
                script{
                    git url: 'https://github.com/Dedeepya59/Online_Banking_Application.git'
                }
            }
            post{
                success{
                    echo 'Checkout completed successfully!'
                }
                failure{
                    echo 'Checkout failed!'
                }
            
                }
        }
        stage ("Build"){
            steps{
                script{
                    sh 'mvn clean package -DskipTests=true'
                }
            }
            post{
                success{
                    echo 'Build completed successfully!'
                }
                failure{
                    echo 'Build failed!'
                    archiveArtifacts artifacts: '**/target/*.jar', allowEmptyArchive: true
                }
            }
        }
        
        stage("Checkstyle Report"){
            steps{
                script{
                    sh 'mvn checkstyle:checkstyle'
                                }
            }  
            post{
                success{
                    echo 'Checkstyle report generated successfully!'
                    
                }
                failure{
                    echo 'Checkstyle report generation failed!'
                }
            }

        }
        stage("SonarQube Analysis"){
            steps{
                withSonarQubeEnv("${SONARQUBE_SERVER}") {
                    sh '''
                    ${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=Online_Banking \
                    -Dsonar.projectName=Online_Banking \
                    -Dsonar.projectVersion=1.0 \
                    -Dsonar.sources=src/ \
                    -Dsonar.java.binaries=target/classes \
                    -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml \
                    -Dsonar.java.coveragePlugin=jacoco \
                    -Dsonar.jacoco.reportPaths=target/jacoco.exec \
                    -Dsonar.junit.reportPaths=target/surefire-reports/
                    '''
                }
            }
            post{
                success{
                    echo 'SonarQube analysis completed successfully!'
                    echo 'Waiting for SonarQube quality gate result...'
                    
                }
                failure{
                    echo 'SonarQube analysis failed!'
                }
            }
        }
        stage("Quality Gate"){
            steps{
                script{
                     timeout(time: 15, unit: 'MINUTES') {
            waitForQualityGate abortPipeline: true
                }
            }
            post{
                success{
                    echo 'Quality gate passed successfully!'
                }
                failure{
                    echo 'Quality gate failed!'
                }
            }
        }
    }
    
    stage("Upload Artifacts to Nexus "){
        steps{
            script{
                nexusArtifactUploader(
        nexusVersion: 'nexus3',
        protocol: 'http',
        nexusUrl: 'localhost:8081',
        groupId: 'QA',
        version: "${env.BUILD_ID}-${env.BUILD_TIMESTAMP}",
        repository: 'Online-Banking',
        credentialsId: 'Nexus',
        artifacts: [
            [artifactId: 'Online-Banking',
             classifier: '',
             file: 'target/Online_Banking-0.0.1-SNAPSHOT.jar',
             type: 'jar']
        ]
     )

            }
        }
        post{
            success{
                echo 'Artifact uploaded to Nexus successfully!'
            }
            failure{
                echo 'Artifact upload to Nexus failed!'
            }
    }
    }
    }

}