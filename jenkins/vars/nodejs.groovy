def call() {
    pipeline {
        agent { label 'WORKSTATION' }

        stages {

            stage('Compile') {
                steps {
                    sh 'echo Compile'
                }
            }

            stage('Code Quality') {
                steps {
                    sh 'echo Code Quality'
                }
            }

            stage('Test Cases') {
                steps {
                    sh 'echo Test Cases'
                }
            }

        }

    }
}