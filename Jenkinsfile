pipeline {
    stages {
        stage('Build') {
            steps {
              echo 'Build workspace'
                sh 'xcodebuild -workspace SlackClone.xcworkspace/ -scheme SlackClone'
            }
        }
        stage('Test') {
            steps {
              echo 'Test workspace'
                //sh './jenkins/scripts/test.sh'
            }
        }
    }
}
