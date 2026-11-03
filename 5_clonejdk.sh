#!/bin/bash
set -e

if [[ $TARGET_VERSION -eq 25 ]]; then
    # Pinned so patches/jre_25 keeps applying cleanly; bump together with the patch
    git clone --branch jdk-25.0.5-ga --depth 1 https://github.com/openjdk/jdk25u.git openjdk
elif [[ $TARGET_VERSION -eq 24 ]]; then
    git clone --branch jdk-24+20 --depth 1 https://github.com/graalvm/labs-openjdk.git openjdk
else
    git clone --depth 1 https://github.com/openjdk/jdk17u openjdk-17
fi
