pipeline {
  agent any

  tools {
    maven 'MVN3'
    jdk 'JDK21'
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
  }
}
