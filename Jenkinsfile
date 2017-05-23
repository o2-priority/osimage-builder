def project = env.PROJECT

stage('Build') {
  node {
    checkout scm
    env.PROJECT=project
    sh('docker-compose up')

  }
}

stage('Test artifact') {
  node {
  }
}
