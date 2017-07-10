pipelineJob('osimage-builder') {
  logRotator {
    daysToKeep(14)
    osimageNumToKeep(3)
  }
  triggers {
    scm('H/2 * * * *')
  }
  definition {
    cpsScm {
      scm {
        git {
          remote {
            github('alanplatt/osimage-builder', 'ssh')
            credentials('microdc-ci-user-git-creds-id')
          }
          branch('*/master')
        }
      }
      scriptPath('Jenkinsfile')
    }
  }
}
