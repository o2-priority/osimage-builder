#!/usr/bin/env groovy

node {

    currentBuild.result = "SUCCESS"
    workspace = pwd()

    osImageBuilderRepo = 'osimage-builder'
    pmLiveAwsAccountId = '995352824234'
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
                rm -vf reports/*
                docker-compose up
                """

			archiveArtifacts(
				artifacts: '**/reports/*.report,**/reports/*.json',
				excludes: null,
				onlyIfSuccessful: false
			)
        }

        stage("Expose AMI to pm-live Account") {
            echo "Grant pm-live account launch permission for AMI built"
            sh  """
                cd ${workspace}
                ami_id=\$(jq '.builds | sort_by(.build_time) | .[-1] | .artifact_id' reports/packer-manifest.json | cut -d':' -f2 | tr '"' ' ')
                aws ec2 modify-image-attribute --image-id \${ami_id} --launch-permission "{\"Add\":[{\"UserId\":\"${pmLiveAwsAccountId}\"}]}"
                """
        }

    } //AnsiColorBuildWrapper
}
