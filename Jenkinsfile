pipeline{
    agent any
    tools{
        maven 'MAVEN'
        jdk 'JDK21'
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
    }

}
