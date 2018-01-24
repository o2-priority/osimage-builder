#!/usr/bin/env groovy

node {

    currentBuild.result = "SUCCESS"
    workspace = pwd()

    osImageBuilderRepo = 'osimage-builder'
    env.PROJECT        = 'priority-microdc'
    env.OS_RELEASE     = 'trusty-14.04'
    env.AWS_PROFILE    = 'o2priority_ref'

    currentBuild.displayName   = "#${env.BUILD_NUMBER}"

    wrap([$class: 'AnsiColorBuildWrapper']) {
        stage("Checkout Infra Code") {
            checkout(
                changelog: false,
                poll: false,
                scm: [
                    $class: 'GitSCM',
                    branches: [[name: 'refs/heads/master']],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [],
                    submoduleCfg: [],
                    userRemoteConfigs: [[credentialsId: 'priority-ci-user-git-creds-id', url: "git@github.com:o2-priority/${osImageBuilderRepo}"]]
                ]
            )
        }


        stage("Build AMI (OS hardening + CIS Benchmark test)") {
            sh  """
                cd ${workspace}
                docker-compose up
                """

			archiveArtifacts(
				artifacts: '**/reports/*.report',
				excludes: null,
				onlyIfSuccessful: false
			)
        }

    } //AnsiColorBuildWrapper
}
