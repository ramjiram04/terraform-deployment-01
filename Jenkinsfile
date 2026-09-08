pipeline {
    agent any

    options {
        skipDefaultCheckout(true)
        disableConcurrentBuilds()
        timestamps()
    }

    environment {
        TF_IN_AUTOMATION = 'true'
        TF_INPUT         = 'false'
        TF_CLI_ARGS      = '-no-color'
    }

    stages {
        stage('Checkout') {
            steps {
                deleteDir()
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init -input=false -reconfigure'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform fmt -check -recursive'
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''#!/bin/bash
                    set -o pipefail
                    terraform plan -input=false -out=tfplan 2>&1 | sed -E "s/$(printf '\033')\\[[0-9;]*[A-Za-z]//g" | LC_ALL=C tr -cd '\11\12\15\40-\176'
                '''
                sh '''#!/bin/bash
                    set -o pipefail
                    terraform show -no-color tfplan | sed -E "s/$(printf '\033')\\[[0-9;]*[A-Za-z]//g" | LC_ALL=C tr -cd '\11\12\15\40-\176' > tfplan.txt
                '''
                sh 'terraform show -json tfplan > tfplan.json'
                sh 'sha256sum tfplan > tfplan.sha256'
                archiveArtifacts artifacts: 'tfplan,tfplan.txt,tfplan.json,tfplan.sha256', fingerprint: true
            }
        }

        stage('Approval') {
            steps {
                input id: 'cloud360-apply-approval', message: 'Cloud360 user approval is required to apply this saved Terraform plan.', ok: 'Apply approved plan', submitter: 'cloud360-agent'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'sha256sum -c tfplan.sha256'
                sh '''#!/bin/bash
                    set -o pipefail
                    terraform apply -input=false -auto-approve tfplan 2>&1 | sed -E "s/$(printf '\033')\\[[0-9;]*[A-Za-z]//g" | LC_ALL=C tr -cd '\11\12\15\40-\176'
                '''
                sh 'terraform output -json > terraform-output.json'
                archiveArtifacts artifacts: 'terraform-output.json', fingerprint: true
            }
        }
    }
}
