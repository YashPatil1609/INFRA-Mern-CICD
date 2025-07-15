pipeline{
    agent any
    environment{
        DOCKER_HUB_USER = "yashpatil16"
    }
    stages{
        stage("Increment application versions"){
            steps{
                script{
                    echo "Incrementing application versions..."

                    dir('./mern/frontend') {
                        sh "npm version patch --no-git-tag-version"
                        def version = sh(script: "jq -r '.version' package.json", returnStdout: true).trim()
                        env.FRONTEND_VERSION = "$version-$BUILD_NUMBER"
                        echo "Frontend Version: ${env.FRONTEND_VERSION}"
                    
                    }
                    dir('./mern/backend') {
                    sh "npm version patch --no-git-tag-version"
                    def version = sh(script: "jq -r '.version' package.json", returnStdout: true).trim()
                    env.BACKEND_VERSION = "$version-$BUILD_NUMBER"
                    echo "Backend Version: ${env.BACKEND_VERSION}"

                }
            }
        }
        }
        stage("Building Docker images and pushing them to dockerhub"){
            steps{
                script{
                    echo "Building Docker images and pushing them to dockerhub..."
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'env.DOCKER_HUB_USER', passwordVariable: 'PASSWORD')]){
                        dir('./mern/frontend'){
                            sh "docker build -t ${DOCKER_HUB_USER}/mernfrontend:${env.FRONTEND_VERSION} ."
                            sh "echo $PASSWORD | docker login -u ${DOCKER_HUB_USER} --password-stdin"
                            sh "docker push ${DOCKER_HUB_USER}/mernfrontend:${env.FRONTEND_VERSION}"
                        }
                        dir('./mern/backend'){
                            sh "docker build -t ${DOCKER_HUB_USER}/mernbackend:${env.BACKEND_VERSION} ."
                            sh "echo $PASSWORD | docker login -u ${DOCKER_HUB_USER} --password-stdin"
                            sh "docker push ${DOCKER_HUB_USER}/mernbackend:${env.BACKEND_VERSION}"
                        }
                    }
                }
            }
        } 
        stage("Commiting version update"){
            steps{
                script{
                    withCredentials([usernamePassword(credentialsId: 'github-PAT', usernameVariable: 'USER', passwordVariable: 'PASS')]){
                        sh 'git config --global user.email "jenkins@example.com"'
                        sh 'git config --global user.name "jenkins"'

                        sh 'git remote set-url origin https://${USER}:${PASS}@github.com/YashPatil1609/INFRA-Mern-CICD.git'

                
                        sh 'git add .'
                        sh 'git commit -m "Incremented application versions"'

                
                        sh 'git push origin HEAD:main'
                    }
                }
            }
        }

        stage("Infra Provisioning"){
            environment{
                AWS_ACCESS_KEY_ID = credentials('AWS-Access-key-id')
                AWS_SECRET_ACCESS_KEY = credentials('AWS-Secret-Access-Key')
            }
            steps{
                script{
                    dir('./Terraform'){
                        sh 'terraform init'
                        sh 'terraform apply -auto-approve'
                        EC2-PUBLIC-IP = sh(script: "terraform output public-ip", returnStdout: true).trim()
                    }
                }
            }
        }

        stage("Deploying to the Server"){
            steps{
                script{
                    sleep(time: 120, unit: 'SECONDS')
                    echo "{$EC2-PUBLIC-IP}"

                    def shellCmd = "bash ./startup-script.sh ${FRONTEND_VERSION} ${BACKEND_VERSION}"
                    sshagent(['INFRA-Mern-CICD']){
                        sh 'scp -o StrictHostKeyChecking=no startup-script.sh ec2-user@{EC2-PUBLIC-IP}:/home/ec2-user'
                        sh 'scp -o StrictHostKeyChecking=no docker-compose.yml ec2-user@{EC2-PUBLIC-IP}:/home/ec2-user'
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@{EC2-PUBLIC-IP} ${shellCmd}"
                       
                            
                        
                    }
                }
            }
        }       
    }
}
