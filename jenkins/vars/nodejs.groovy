def call(Map params = [:]) {

    def args= [
            COMPONENT : '',
            LABEL     : 'master'
    ]
    args << params

    pipeline {
        agent { label params.LABEL }

        stages {

            stage('Compile') {
                steps {
                    sh 'echo Compile'
                    sh "echo COMPONENT = ${params.COMPONENT}"
                    sh 'env'
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