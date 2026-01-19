pipeline {
  //agent -> select nodes.
  agent any

  tools {
    maven "M3"
    jdk "JDK17"
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
        
      }
    }
   
    
  }
}
