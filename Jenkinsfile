pipeline {
  agent any

  tools {
    maven 'Maven3'
    jdk 'JDK21'
  }

  stages {
    stage('checkout 확인') {
      steps {
        echo 'Jenkinsfile from SCM loaded successfully'
      }
    }

    stage('Build') {
      steps {
        sh 'mvn -v'
        sh 'mvn clean package -DskipTests'
      }
    }
  }
}
