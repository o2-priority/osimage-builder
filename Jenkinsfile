def project = env.PROJECT

stage('Build') {
  node {
    checkout scm
    sh('''
        export TEST1=${project}
        export TEST2=${PROJECT}
        export TEST3=project
        env
        docker-compose up --no-color
    ''')

  }
}

stage('Test artifact') {
  node {
  }
}
