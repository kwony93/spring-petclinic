pipeline {
  agent any

  tools {
    maven 'MVN3'
    jdk 'JDK21'
  }

  environment {
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
          docker build -t aws-spring-petclinic:$BUILD_NUMBER .
          docker tag aws-spring-petclinic:$BUILD_NUMBER hklee2748/aws-spring-petclinic:latest
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

    
  }
}
