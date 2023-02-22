def deploy_port = ["main": 8080, "staging": 3000 ]
def feature_port = 3005
pipeline {
    agent any
    stages {
        stage('Build image') {
            steps {
                sh 'docker build -t cowsay:yarden .'
            }
        }

        stage('push image') {
            steps {
                sh """
                aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 644435390668.dkr.ecr.eu-west-1.amazonaws.com
                docker tag cowsay:yarden 644435390668.dkr.ecr.eu-west-1.amazonaws.com/cowsay:yarden
                docker push 644435390668.dkr.ecr.eu-west-1.amazonaws.com/cowsay:yarden 
                """
            }
        }

        stage('scp script to EC2') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: "yarden-EC2-SSH", keyFileVariable: 'key')]) {
                    sh 'scp -i ${key} -o StrictHostKeyChecking=no Dockerscript.sh ubuntu@52.210.230.97:/home/ubuntu/Dockerscript.sh'
                }
            }
        }

        stage('Dploy app in EC2') {
            steps {
                script{
                    
                   if(deploy_port[env.BRANCH_NAME]) { 
                        def port = deploy_port[env.BRANCH_NAME]
                    
                    } else{ 
                        deploy_port["${env.BRANCH_NAME}"] = feature_port
                    }
                    def COWSAY_NAME = env.BRANCH_NAME.replace("/","-")
                    def port = deploy_port[env.BRANCH_NAME]
                    withCredentials([sshUserPrivateKey(credentialsId: "yarden-EC2-SSH", keyFileVariable: 'key')]) {
                        sh "ssh -i ${key} -v -o StrictHostKeyChecking=no ubuntu@52.210.230.97 sh /home/ubuntu/Dockerscript.sh ${port} ${COWSAY_NAME} "
                        sh 'sleep 5'
                        sh "curl http://52.210.230.97:${port}/${COWSAY_NAME}"
                        sh "ssh -i ${key} -v -o StrictHostKeyChecking=no ubuntu@52.210.230.97 docker stop cowsay-${COWSAY_NAME}"
                    }
                }

            }

        }
    }   
}
