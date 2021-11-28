def call(Map params = [:]) {

    def args= [
            COMPONENT : '',
            LABEL     : 'master'
    ]
    args << params

    pipeline {
        agent { label params.LABEL }

        stages {
            stage('Labeling Build') {
                steps {
                    script {
                        str = GIT_BRANCH.split('/').last()
                        addShortText background: 'yellow', color: 'black', borderColor: 'yellow', text: "COMPONENT = ${params.COMPONENT}"
                        addShortText background: 'yellow', color: 'black', borderColor: 'yellow', text: "BRANCH = ${str}"
//            addShortText background: 'orange', color: 'black', borderColor: 'yellow', text: "${ENV}"
                    }
                }
            }
            stage('Maven Compile') {
                steps {
                    sh 'echo Maven Compiler'
                    sh 'mvn package'
                    sh "echo COMPONENT = ${params.COMPONENT}"
                    sh 'env'
                    //GIT_BRANCH
                }
            }

            stage('Submit for Code Quality') {
                steps {
                    sh 'echo Code Quality'
                    sh """
                      sonar-scanner -Dsonar.projectKey=${params.COMPONENT} -Dsonar.sources=. -Dsonar.java.binaries=target/. -Dsonar.host.url=http://172.31.21.229:9000 -Dsonar.login=be6cfd1385e726a95a659491011c47f10ca33312
                    """
                }
            }

            stage('Check Code Quality gate') {
                steps {
                    sh 'echo Checking Code Quality Gate status'
                    sh """
                      sleep 5
                      sonar-quality-gate.sh admin DevOps321 172.31.21.229 ${params.COMPONENT}
                    """
                }
            }

            stage('Test Cases') {
                steps {
                    sh 'echo Test Cases'
                }
            }

            stage('Upload Artifacts') {
                when {
                    expression { sh([returnStdout: true, script: 'echo ${GIT_BRANCH} | grep tags || true' ]) }
                }
                steps {
                    sh 'echo Test Cases'
                    sh 'env'
                }
            }

        }
        post {
            always {
                cleanWs()
            }
        }
    }

}