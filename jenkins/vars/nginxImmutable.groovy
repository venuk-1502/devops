def call(Map params = [:]) {

    def args= [
            COMPONENT : '',
            LABEL     : 'master'
    ]
    args << params

    pipeline {
        agent { label params.LABEL }

        options {
            ansiColor('xterm')
        }

        environment {
            NEXUS = credentials("NEXUS")
        }

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

            stage('Submit for Code Quality') {
                steps {
                    sh 'echo Code Quality'
                   // sh """
                   //   sleep 5
                   //   sonar-scanner -Dsonar.projectKey=${params.COMPONENT} -Dsonar.sources=. -Dsonar.host.url=http://172.31.21.229:9000 -Dsonar.login=be6cfd1385e726a95a659491011c47f10ca33312
                   // """
                }
            }

            stage('Check Code Quality gate') {
                steps {
                    sh 'echo Checking Code Quality Gate status'
                  //  sh """
                  //    sonar-quality-gate.sh admin DevOps321 172.31.21.229 ${params.COMPONENT}
                  //  """
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
                    sh """
                    GIT_TAG=`echo ${GIT_BRANCH} | awk -F / '{print \$NF}'`
                    echo \${GIT_TAG} >version
                    cd  static
                    zip -r ../${params.COMPONENT}-\${GIT_TAG}.zip *
                    cd ..
                    curl -v -u ${NEXUS} --upload-file ${params.COMPONENT}-\${GIT_TAG}.zip http://172.31.16.46:8081/repository/${params.COMPONENT}/${params.COMPONENT}-\${GIT_TAG}.zip
                    """
                }
            }
            stage('Make AMI') {
                when {
                    expression { sh([returnStdout: true, script: 'echo ${GIT_BRANCH} | grep tags || true' ]) }
                }
                steps {
                    sh """
                    GIT_TAG=`echo ${GIT_BRANCH} | awk -F / '{print \$NF}'`
                    export TF_VAR_APP_VERSION=\${GIT_TAG}
                    terraform init 
                    terraform apply -auto-approve
                    """
                }
            }

            stage('Delete AMI Instances') {
                when {
                    expression { sh([returnStdout: true, script: 'echo ${GIT_BRANCH} | grep tags || true' ]) }
                }
                steps {
                    sh """
                    GIT_TAG=`echo ${GIT_BRANCH} | awk -F / '{print \$NF}'`
                    export TF_VAR_APP_VERSION=\${GIT_TAG}
                    terraform init 
                    terraform state rm module.ami.aws_ami_from_instance.ami
                    terraform destroy -auto-approve
                    """
                }
            }

        //    stage('App Deployment - Dev Env') {
        //        steps {
        //            script {
        //                GIT_TAG = GIT_BRANCH.split('/').last()
        //            }
        //            build job: 'Mutable/App-Deploy', parameters: [
        //                    string(name: 'ENV', value: 'dev'),
        //                    string(name: 'APP_VERSION', value: "${GIT_TAG}"),
        //                    string(name: 'COMPONENT', value: "${params.COMPONENT}")
        //            ]
        //        }
        //    }

        }
        post {
            always {
                cleanWs()
            }
        }
    }

}