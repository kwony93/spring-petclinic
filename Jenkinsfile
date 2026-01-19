pipeline {
  agent any

  tools {
    maven "M3"
    jdk "JDK17"
  } 

  stages {
    stage('Git clone') {
      steps {
          git url: 'https://github.com/kwony93/spring-petclinic.git/', branch: 'main'
      } 
    }
    
  }
  
}
