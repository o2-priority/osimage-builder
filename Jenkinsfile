def project = env.PROJECT

stage('Build') {
  node {
    checkout scm
    env.PROJECT=project
    sh('''
        env
        docker-compose up --no-color
    ''')

  }
}

stage('Test artifact') {
  node {
  }
}
