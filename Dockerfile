FROM alpine:3.7

ENV GOOGLE_CLOUD_SDK_VERSION=195.0.0

ENV GAE_HOME /google-cloud-sdk/platform/google_appengine
ENV PATH /google-cloud-sdk/bin:$GAE_HOME:$PATH

RUN apk add --no-cache \
      curl \
      bash \
      python

RUN set -x && \
    cd /   && \
    curl -O https://storage.googleapis.com/cloud-sdk-release/google-cloud-sdk-${GOOGLE_CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-${GOOGLE_CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${GOOGLE_CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    ln -s /lib /lib64 && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true

RUN set -ex && \
    CLOUDSDK_CORE_DISABLE_PROMPTS=1 gcloud components install \
      app-engine-python \
      app-engine-python-extras \
      cloud-datastore-emulator \
      pubsub-emulator && \
    chmod +x /google-cloud-sdk/platform/google_appengine/*.py

CMD ["/bin/bash"]
