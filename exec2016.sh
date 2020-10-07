#!/bin/bash

export HOME=${PWD}

tar xvaf submit.tgz
cd submit
bash ./runEventGeneration2016_v2.sh 
cd ${HOME}
rm -r submit/
exit 0
