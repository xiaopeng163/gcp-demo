FROM python:3.9-alpine

ARG TARGETARCH

ENV WORKDIR="/tools" \
    YQ="v4.7.1" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    TERRAFORM_VERSION="1.2.9" \
    TFLINT_VERSION="v0.44.1" \
    GCLOUD_VERSION="421.0.0"

ENV TZ  Asia/Shanghai

RUN apk add --no-cache curl bash jq bash-completion git build-base libffi-dev

# change default shell from ash to bash
RUN sed -i -e "s/bin\/ash/bin\/bash/" /etc/passwd


# ---------------------------- Jinja2
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -U Jinja2 && \
    pip install --no-cache-dir -U j2cli && \
    pip install --no-cache-dir pre-commit && \
    pip install --no-cache-dir -U yamllint

# install tflint
RUN curl  \
    --location \
    --output tflint.zip https://github.com/terraform-linters/tflint/releases/download/${TFLINT_VERSION}/tflint_linux_${OS_ARCH}.zip && \
    unzip tflint.zip -d /usr/local/bin && \
    chmod +x /usr/local/bin/tflint


# ---------------------------- yq
RUN curl -LO https://github.com/mikefarah/yq/releases/download/${YQ}/yq_linux_${OS_ARCH} && \
    chmod +x yq_linux_${OS_ARCH} && \
    mv yq_linux_${OS_ARCH} /usr/local/bin/yq

# install terraform
RUN curl \
    --location \
    --output /tmp/terraform.zip \
    https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${OS_ARCH}.zip \
    && unzip /tmp/terraform.zip -d /usr/local/bin \
    && rm -rf /tmp/terraform.zip

# install gcloud
RUN curl --location --output /tmp/gcloud.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-421.0.0-linux-x86_64.tar.gz \
    && tar zxvf /tmp/gcloud.tar.gz -C /root \
    && rm -rf /tmp/gcloud.tar.gz


COPY config/bashrc /root/.bashrc

CMD [ "/bin/bash", "--init-file", "/etc/profile" ]
