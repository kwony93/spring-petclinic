pipeline {
  //agent -> select nodes.
  agent any

  tools {
    maven "M3"
    jdk "JDK17"
  }
  
  environment {
    // Docker Account info. register
    DOCKERHUB_CREDENTIALS = credentials('dockerCredential')    
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

    // SSH Publish
    stage('SSH Publish') {
      steps {
        echo 'SSH Publish'
        sshPublisher(publishers: [sshPublisherDesc(configName: 'target',
        transfers: [sshTransfer(cleanRemote: false,
        excludes: '',
        execCommand: '''
        docker rm -f $(docker ps -aq)
        docker rmi -f $(docker images -q)
        docker run -itd -p 80:8080 --name=spring-petclinic hklee2748/spring-petclinic:latest
        ''',
        execTimeout: 120000,
        flatten: false,
        makeEmptyDirs: false,
        noDefaultExcludes: false,
        patternSeparator: '[, ]+',
        remoteDirectory: '',
        remoteDirectorySDF: false,
        removePrefix: 'target',
        sourceFiles: '')],
        usePromotionTimestamp: false,
        useWorkspaceInPromotion: false,
        verbose: false)])
      }
    }


    
  }
}
