pipelineJob('artifact-builder') {
  logRotator {
    daysToKeep(14)
    artifactNumToKeep(3)
  }
  triggers {
    scm('H/2 * * * *')
  }
  definition {
    cpsScm {
      scm {
        git {
          remote {
            github('alanplatt/artifact-builder', 'ssh')
            credentials('microdc-ci-user-git-creds-id')
          }
          branch('*/master')
        }
      }
      scriptPath('Jenkinsfile')
    }
  }
}
