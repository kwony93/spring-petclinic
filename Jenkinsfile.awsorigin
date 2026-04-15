pipeline {
  //agent -> select nodes.
  agent any

  tools {
    maven "M3"
    jdk "JDK21"
  }
  
  environment {
    REGION = "ap-northeast-2"
    DOCKERHUB_CREDENTIALS = credentials('DockerCredentials')
    AWS_CREDENTIALS_NAME = "AWSCredentials"
  }
  
  stages {
    // Git Clone.
    stage('Git clone') {
      steps {
        git url: 'https://github.com/kwony93/spring-petclinic.git/', branch: 'main'
      }
    }
    
    // Build of using Maven.
    stage('Maven Build') {
      steps {
        sh 'mvn -Dmaven.test.failure.ignore=true clean package'
      }
      // steps 실행 이후 출력 설정(확인용)
      post {
        success {
          echo 'Maven Build Success'
        }
        failure {
          echo 'Maven Build Failed'
        }
      }
    }
    // Docker Image 생성
    stage('Docker Image Build') {
      steps {
        echo 'Docker Image Build'
        dir("${env.WORKSPACE}") {
          sh """
          docker build -t spring-petclinic:$BUILD_NUMBER .
          docker tag spring-petclinic:$BUILD_NUMBER hklee2748/spring-petclinic:latest
          """
        }
      }
    }
    
    // Docker Image upload
    stage('Docker Image Upload') {
      steps {
        echo 'Docker Image Upload'
        sh """
        echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
        docker push hklee2748/spring-petclinic:latest
        """
      }
    }

    // Docker Image Remove
    stage('Docker Image Remove') {
      steps {
        echo 'Docker Image Remove'
        sh 'docker rmi -f spring-petclinic:$BUILD_NUMBER'
      }
    }

    // Upload to S3
    stage('Upload to S3') {
      steps {
        echo 'Upload to S3'
        dir("${env.WORKSPACE}") {
          sh 'zip -r scripts.zip ./scripts appspec.yml'
          //withAWS(region:"${REGION}", credentials:"${AWS_CREDENTIALS_NAME}") {
          withAWS(region:"${REGION}", credentials:'AWSCredentials') {
            s3Upload(file:"scripts.zip", bucket:"user03-codedeploy-bucket")
          }
          sh 'rm -rf ./scripts.zip'
        }
      }
    }
   
    // Code Deploy 
    stage('Codedeploy Workload') {
      steps {
        withAWS(region:"${REGION}", credentials:'AWSCredentials') {
          sh """
             aws deploy create-deployment-group \
             --application-name user03-code-deploy \
             --auto-scaling-groups USER03-ASG-TARGET \
             --deployment-group-name user03-code-deploy-${BUILD_NUMBER} \
             --deployment-config-name CodeDeployDefault.OneAtATime \
             --service-role-arn arn:aws:iam::491085389788:role/user03-code-deploy-service-role
             """
          sh """
             aws deploy create-deployment --application-name user03-code-deploy \
             --deployment-config-name CodeDeployDefault.OneAtATime \
             --deployment-group-name user03-code-deploy-${BUILD_NUMBER} \
             --s3-location bucket=user03-codedeploy-bucket,bundleType=zip,key=scripts.zip
             """
        }
        sleep(10) // sleep 10s 
      }
    }
    
  }  
}
