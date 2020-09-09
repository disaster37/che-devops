FROM centos:centos8

ARG http_proxy
ARG https_proxy

ENV KUBECTL_VERSION="v1.18.6" \
    VAULT_VERSION="1.5.0" \
    TERRAFORM_11_VERSION="0.11.14" \
    TERRAFORM_12_VERSION="0.12.29" \
    TERRAFORM_13_VERSION="0.13.0" \
    TERRAGRUNT_VERSION="v0.23.33" \
    ENVSUBST_VERSION="v1.2.0" \
    PUPPET_VERSION="5.5.21" \
    BOLT_VERSION="2.22.0" \
    DOCKER_COMPOSE_VERSION="1.26.2" \
    HADOLINT_VERSION="v1.18.0" \
    GRADLE_VERSION="6.6" \
    HELM_VERSION="v3.3.1" \
    RANCHER_VERSION="v2.4.6" \
    GRADLE_HOME="/opt/gradle"\  
    PATH=$PATH:/opt/puppetlabs/puppet/bin:/opt/gradle/bin
    
    

# Required for che
ADD https://raw.githubusercontent.com/disaster37/che-scripts/master/centos.sh /tmp/centos.sh
RUN sh /tmp/centos.sh

# Download usefull cli needed for devops power
RUN \
    cd /tmp &&\
    echo "Kubectl" &&\
    curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/bin/kubectl &&\
    chmod +x /usr/bin/kubectl &&\
    echo "vault" &&\
    curl -L https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip -o /tmp/vault.zip &&\
    unzip /tmp/vault.zip &&\
    mv vault /usr/bin/vault &&\
    chmod +x /usr/bin/vault &&\
    echo "terraform 11" &&\
    curl -L https://releases.hashicorp.com/terraform/${TERRAFORM_11_VERSION}/terraform_${TERRAFORM_11_VERSION}_linux_amd64.zip -o /tmp/terraform_11.zip &&\
    unzip /tmp/terraform_11.zip &&\
    mv terraform /usr/bin/terraform_11 &&\
    chmod +x /usr/bin/terraform_11 &&\
    echo "terraform 12" &&\
    curl -L https://releases.hashicorp.com/terraform/${TERRAFORM_12_VERSION}/terraform_${TERRAFORM_12_VERSION}_linux_amd64.zip -o /tmp/terraform_12.zip &&\
    unzip /tmp/terraform_12.zip &&\
    mv terraform /usr/bin/terraform_12 &&\
    chmod +x /usr/bin/terraform_12 &&\
    echo "terraform 13" &&\
    curl -L https://releases.hashicorp.com/terraform/${TERRAFORM_13_VERSION}/terraform_${TERRAFORM_13_VERSION}_linux_amd64.zip -o /tmp/terraform_13.zip &&\
    unzip /tmp/terraform_13.zip &&\
    mv terraform /usr/bin/terraform_13 &&\
    chmod +x /usr/bin/terraform_13 &&\
    echo "terragrunt" &&\
    curl -L https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 -o /usr/bin/terragrunt &&\
    chmod +x /usr/bin/terragrunt &&\
    echo "envsubst" &&\
    curl -L https://github.com/a8m/envsubst/releases/download/${ENVSUBST_VERSION}/envsubst-Linux-x86_64 -o /usr/bin/envsubst &&\
    chmod +x /usr/bin/envsubst &&\
    echo "hadolint" &&\
    curl -L https://github.com/hadolint/hadolint/releases/download/${HADOLINT_VERSION}/hadolint-Linux-x86_64 -o /usr/bin/hadolint &&\
    chmod +x /usr/bin/hadolint &&\
    echo "gradle" &&\
    curl -L https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -o /tmp/gradle.zip &&\
    unzip /tmp/gradle.zip &&\
    mv /tmp/gradle-* /opt/gradle &&\
    echo "helm" &&\
    curl -L https://get.helm.sh/helm-${HELM_VERSION]-linux-amd64.tar.gz -o /tmp/helm.tar.gz &&\
    tar -xvzf /tmp/helm.tar.gz &&\
    mv /tmp/linux-amd64/helm /usr/bin/helm &&\
    echo "rancher2" &&\
    curl -L https://github.com/rancher/cli/releases/download/${RANCHER_VERSION}/rancher-linux-amd64-${RANCHER_VERSION}.tar.gz -o /tmp/rancher.tar.gz &&\
    tar -xvzf /tmp/rancher.tar.gz &&\
    mv /tmp/rancher-*/rancher /usr/bin/rancher
    
# Utils
RUN \
    yum -y install git make yum-utils
    
    
# Install docker && docker compose
RUN \
  yum-config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo &&\
  yum -y  install docker-ce --nobest &&\
  curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &&\
  chmod +x /usr/local/bin/docker-compose &&\
  ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    
# Pyhton 3
RUN \
    yum -y install python3 &&\
    yum -y install python3-pip
    
# Ruby
RUN \
    yum -y install ruby
    
# Puppet
RUN \
    rpm -Uvh https://yum.puppet.com/puppet5/puppet5-release-el-7.noarch.rpm &&\
    yum install -y gcc-c++ libxml2 libxml2-devel libxslt-devel zlib-devel pdk puppet-agent-${PUPPET_VERSION}
RUN \
    /opt/puppetlabs/puppet/bin/gem install rspec  &&\
    /opt/puppetlabs/puppet/bin/gem install rspec-puppet &&\
    /opt/puppetlabs/puppet/bin/gem install puppetlabs_spec_helper &&\
    /opt/puppetlabs/puppet/bin/gem install puppet-lint &&\
    /opt/puppetlabs/puppet/bin/gem install r10k &&\
    /opt/puppetlabs/puppet/bin/gem install nokogiri -- --use-system-libraries=true --with-xml2-include=/usr/include/libxml2 &&\
    /opt/puppetlabs/puppet/bin/gem install beaker -v 4.0.0 &&\
    /opt/puppetlabs/puppet/bin/gem install beaker-puppet -v 1.1.0 &&\
    /opt/puppetlabs/puppet/bin/gem install beaker-puppet_install_helper -v 0.9.7 &&\
    /opt/puppetlabs/puppet/bin/gem install beaker-pe -v 2.0.6 &&\
    /opt/puppetlabs/puppet/bin/gem install beaker-module_install_helper -v 0.1.7 &&\
    /opt/puppetlabs/puppet/bin/gem install beaker-task_helper -v 1.7.2 &&\
    /opt/puppetlabs/puppet/bin/gem install beaker-rspec -v 6.2.4 &&\
    /opt/puppetlabs/puppet/bin/gem install beaker-docker -v 0.5.1 &&\
    /opt/puppetlabs/puppet/bin/gem install beaker-hiera -v 0.1.1

# Install Bolt
RUN yum install -y puppet-bolt-${BOLT_VERSION}

# Install skopeo
RUN yum install -y skopeo

# Install Java for gradle
RUN yum install -y java-1.8.0-openjdk-devel


# Clean image
RUN \
    yum clean all &&\
    rm -rf /tmp/*

    
    

WORKDIR "/projects"
VOLUME "/home/dev"

CMD ["sleep", "infinity"]
