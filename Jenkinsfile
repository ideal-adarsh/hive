pipeline{
    agent {
      docker { image 'node:alpine' }
    }

    stages{
        stage("Test"){
            steps{
              sh 'node --version'
            }
        }
        stage("A"){
            steps{
                echo "========executing A again and again========"
            }
            post{
                always{
                    echo "========always========"
                }
                success{
                    echo "========A executed successfully========"
                }
                failure{
                    echo "========A execution failed========"
                }
            }
        }
    }
    post{
        always{
            echo "========always========"
        }
        success{
            echo "========pipeline executed successfully ========"
        }
        failure{
            echo "========pipeline execution failed========"
        }
    }
}