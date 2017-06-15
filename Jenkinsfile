stage('Build') {
  node {
    checkout scm
    sh('''
        export PROJECT=${PROJECT}
        env
        docker-compose up --no-color
    ''')

  }
}

stage('Test artifact') {
  node {
  }
}
