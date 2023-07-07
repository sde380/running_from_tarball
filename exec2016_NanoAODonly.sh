#!/bin/bash

export HOME=${PWD}
ls -ltrh
echo ""

tar xvaf submit.tgz
cd submit
ls -ltrh
echo ""
bash ./runEventGeneration2016_NanoAODonly.sh
cd ${HOME}
rm -r submit/
exit 0
