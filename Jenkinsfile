pipeline{
    agent any
    tools{
        maven 'MAVEN'
        jdk 'JDK21'
    }
    environment {
        SONARQUBE_SERVER = 'Sonar' // Replace with your SonarQube server name in Jenkins
        scannerHome = tool name: 'Sonar'
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
                    timeout(time: 20, unit: 'MINUTES') {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qg.status}"
                        }
                    }
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

}