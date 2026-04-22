pipeline {
  agent any

  tools {
    maven 'MVN3'
    jdk 'JDK21'
  }

  environment {
    REGION = 'ap-northeast-2'
    DOCKERHUB_CREDENTIALS = credentials('Docker-Creds')
  }

  stages {
    stage('Git clone') {
      steps {
        git url: 'https://github.com/kwony93/spring-petclinic.git/', branch: 'main'
      }
    }

    stage('Maven Build') {
      steps {
        sh 'mvn -Dmaven.test.failure.ignore=true clean package'
      }
      post {
        success {
          echo 'Maven Build Success'
        }
        failure {
          echo 'Maven Build Failed'
        }
      }
    }

    stage('Docker Image Build') {
      steps {
        sh """
          docker build -t spring-petclinic:$BUILD_NUMBER .
          docker tag spring-petclinic:$BUILD_NUMBER hklee2748/aws-spring-petclinic:latest
        """
      }
    }

    stage('Docker Image Upload') {
      steps {
        sh """
          echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
          docker push hklee2748/aws-spring-petclinic:latest
        """
      }
    }

    stage('Docker Image Remove') {
      steps {
        echo 'Docker Image Remove'
        sh 'docker rmi -f spring-petclinic:$BUILD_NUMBER'
      }
    }

    stage('Create Deployment Bundle') {
      steps {
        sh '''
          rm -f scripts.zip
          zip -r scripts.zip scripts appspec.yml
          ls -lh scripts.zip
        '''
      }
    }

    stage('Upload to S3') {
      steps {
        sh '''
          aws s3 cp scripts.zip s3://user03-codedeploy-bucket/scripts.zip --region ap-northeast-2
        '''
      }
    }
  }

  post {
    always {
      sh 'rm -f scripts.zip || true'
    }
  }
}
