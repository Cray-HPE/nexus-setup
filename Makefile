# Copyright 2019-2021 Hewlett Packard Enterprise Development LP
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
# (MIT License)

# DOCKER
NAME ?= cray-nexus-setup
VERSION ?= $(shell cat .version)
#DOCKER_IMAGE ?= ${NAME}:${VERSION}

# RPM
SPEC_NAME ?= nexus
RPM_NAME ?= cray-nexus
SPEC_FILE ?= ${SPEC_NAME}.spec
BUILD_METADATA ?= 1~development~$(shell git rev-parse --short HEAD)
RPM_VERSION ?= $(shell grep -Po '(?<=Version: ).*' ${SPEC_FILE})
#RPM_SOURCE_NAME ?= ${RPM_NAME}-${RPM_VERSION}-2.${BUILD_METADATA}
RPM_BUILD_DIR ?= $(PWD)/dist/rpmbuild
RPM_SOURCE_PATH := ${RPM_BUILD_DIR}/SOURCES/${RPM_SOURCE_NAME}.tar.bz2

# HELM CHART
CHART_PATH ?= kubernetes
CHART_VERSION_1 ?= local
CHART_VERSION_2 ?= local

rpm: rpm_prepare rpm_package_source rpm_build_source rpm_build
charts: chart1 chart2

image:
	docker build --pull ${DOCKER_ARGS} --tag '${IMAGE_NAME}:${VERSION}' .
	docker images

rpm_prepare:
	rm -rf $(RPM_BUILD_DIR)
	mkdir -p $(RPM_BUILD_DIR)/SPECS $(RPM_BUILD_DIR)/SOURCES
	cp $(SPEC_FILE) $(RPM_BUILD_DIR)/SPECS/

rpm_package_source:
	tar --transform 'flags=r;s,^,/${RPM_NAME}-${RPM_VERSION}/,' --exclude .git --exclude dist -cvjf $(RPM_SOURCE_PATH) .

rpm_build_source:
	BUILD_METADATA=$(BUILD_METADATA) rpmbuild -ts $(RPM_SOURCE_PATH) --nodeps --define "_topdir $(RPM_BUILD_DIR)"

rpm_build:
	BUILD_METADATA=$(BUILD_METADATA) rpmbuild -ba $(SPEC_FILE) --nodeps --define "_topdir $(RPM_BUILD_DIR)" --define "local_docker_image true" --define "cray_nexus_setup_image $(DOCKER_IMAGE)" --define "cray_nexus_setup_tag $(VERSION)"

chart1:
	helm dep up ${CHART_PATH}/${CHART_NAME_1}
	helm package ${CHART_PATH}/${CHART_NAME_1} -d ${CHART_PATH}/.packaged --version ${CHART_VERSION_1}

chart2:
	helm dep up ${CHART_PATH}/${CHART_NAME_2}
	helm package ${CHART_PATH}/${CHART_NAME_2} -d ${CHART_PATH}/.packaged --version ${CHART_VERSION_2}
