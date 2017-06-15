
stage('Build') {
  node {
    checkout scm
    sh('''
        PROJECT=${PROJECT}
        env
        docker-compose up --no-color
    ''')

  }
}

stage('Test artifact') {
  node {
  }
}
