#!/bin/bash

#export X509_USER_PROXY=${PWD}/x509up
export HOME=${PWD}

tar xvaf submit.tgz
cd submit
bash ./runEventGeneration2017_slc7.sh
cd ${HOME}
rm -r submit/
exit 0
