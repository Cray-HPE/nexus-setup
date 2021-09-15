// Copyright 2020 Hewlett Packard Enterprise Development LP

@Library('dst-shared@master') _

dockerBuildPipeline {
 app = "nexus-setup"
 name = "cray-nexus-setup"
 description = "Utilities to setup and configure Nexus"
 repository = "cray"
 imagePrefix = "cray"
 product = "csm"
 githubPushRepo = "Cray-HPE/nexus-setup"
 githubPushBranches = /(release\/.*|master)/
}
