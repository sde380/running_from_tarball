#!/bin/bash

###########
# setup
export BASEDIR=`pwd`

############
# Computing environments
echo "Starting job on " `date` #Date/time of start of job
echo "Running on: `uname -a`" #Condor job is running on this node
echo "System software: `cat /etc/redhat-release`" #Operating System on that node
echo "Printing the environment variables"
printenv
echo ""
echo ""
pwd 

############
# inputs

export VO_CMS_SW_DIR=/cvmfs/cms.cern.ch
source $VO_CMS_SW_DIR/cmsset_default.sh

#
#############
#############
# make a working area

echo " Start to work now"
pwd
mkdir -p ./work
cd    ./work
export WORKDIR=`pwd`

#
###########
###########
# Generate NanoAOD
export SCRAM_ARCH=slc6_amd64_gcc700
scram p CMSSW CMSSW_10_2_18
cd CMSSW_10_2_18/src
eval `scram runtime -sh`

cp ${BASEDIR}/input/nanotools.tar ./
tar xvaf nanotools.tar 

scram b -j 1

#Run
cmsRun nanoaod_cfg.py

ls -ltrh *nano.root

### mono-hs samples ###
OUTDIRnano=root://cmseos.fnal.gov//store/user/jongho/monoHiggs/NanoAODv6/2016/changeME

echo ""
echo "xrdcp output to ${OUTDIRnano}"

for FILE in *nano.root
do
    echo "command: xrdcp -f ${FILE} ${OUTDIRnano}/${FILE}"
    xrdcp -f ${FILE} ${OUTDIRnano}/${FILE} 2>&1
    XRDEXIT=$?
    if [[ $XRDEXIT -ne 0 ]]; then
        echo "exit code $XRDEXIT, failure in xrdcp"
    fi
done

###########
###########

echo ""
echo "DONE."
