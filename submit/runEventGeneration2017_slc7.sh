#!/bin/bash

###########
# setup
export BASEDIR=`pwd`

############
# Computing environments
echo "Starting job on " `date` #Date/time of start of job
echo "Running on: `uname -a`" #Condor job is running on this node
echo "System software: `cat /etc/redhat-release`" #Operating System on that node

############
# inputs

export VO_CMS_SW_DIR=/cvmfs/cms.cern.ch
source $VO_CMS_SW_DIR/cmsset_default.sh
source ./inputs.sh

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
#############
#############
# Set random number

ls -lhrt

RANDOMSEED=`od -vAn -N4 -tu4 < /dev/urandom`

#Sometimes the RANDOMSEED is too long for madgraph
RANDOMSEED=`echo $RANDOMSEED | rev | cut -c 3- | rev`

TempNumber=${RANDOMSEED}
outfilename_tmp="$PROCESS"'_'"$RANDOMSEED"
outfilename="${outfilename_tmp//[[:space:]]/}"

#
#############
#############
# Generate GEN-SIM

export SCRAM_ARCH=slc7_amd64_gcc630
scram p CMSSW CMSSW_9_3_16
cd CMSSW_9_3_16/src
eval `scram runtime -sh`

mkdir -p Configuration/GenProduction/python/
cp ${BASEDIR}/input/${HADRONIZER} Configuration/GenProduction/python/

scram b

cmsDriver.py Configuration/GenProduction/python/${HADRONIZER} --fileout file:${outfilename}_gensim.root --mc --eventcontent RAWSIM,LHE --datatier GEN-SIM,LHE --conditions 93X_mc2017_realistic_v3 --beamspot Realistic25ns13TeVEarly2017Collision --step LHE,GEN,SIM --geometry DB:Extended --era Run2_2017 --python_filename ${outfilename}_gensim.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n 300

# Run
cmsRun ${outfilename}_gensim.py

ls -ltrh

mv ${outfilename}_gensim.root ../../
cd ../../

ls -ltrh

#
############
############
# Generate AOD

scram p CMSSW CMSSW_9_4_7
cd CMSSW_9_4_7/src
eval `scram runtime -sh`
scram b
cd ../../

cp ${BASEDIR}/input/pu_files2017.py .
cp ${BASEDIR}/input/aod_template2017.py .

sed -i 's/XX-GENSIM-XX/'${outfilename}'/g' aod_template2017.py
sed -i 's/XX-AODFILE-XX/'${outfilename}'/g' aod_template2017.py

mv aod_template2017.py ${outfilename}_1_cfg.py

cmsRun ${outfilename}_1_cfg.py

cmsDriver.py step2 --filein file:${outfilename}_step1.root --fileout file:${outfilename}_aod.root --mc --eventcontent AODSIM --runUnscheduled --datatier AODSIM --conditions 94X_mc2017_realistic_v11 --step RAW2DIGI,RECO,RECOSIM,EI --nThreads 2 --era Run2_2017 --python_filename ${outfilename}_aod_cfg.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n 500 

#Run
cmsRun ${outfilename}_aod_cfg.py

ls -ltrh

#
############
############
# Generate MiniAOD

cmsDriver.py step3 --filein file:${outfilename}_aod.root --fileout file:${outfilename}_miniaod.root --mc --eventcontent MINIAODSIM --runUnscheduled --datatier MINIAODSIM --conditions 94X_mc2017_realistic_v14 --step PAT --nThreads 2 --scenario pp --era Run2_2017,run2_miniAOD_94XFall17 --python_filename ${outfilename}_miniaod_cfg.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n 500 

#Run
cmsRun ${outfilename}_miniaod_cfg.py

ls -ltrh

copypath=$(readlink -f ./${outfilename}_miniaod.root)
echo "${copypath} will be copied to EOS"

#### Copy MiniAOD to EOS
xrdcp file://${copypath} root://cmseos.fnal.gov//store/user/jongho/temp/${outfilename}_miniaod.root

###########
###########
# Generate NanoAOD
export SCRAM_ARCH=slc6_amd64_gcc700
scram p CMSSW CMSSW_10_2_18
cd CMSSW_10_2_18/src
eval `scram runtime -sh`

scram b
cd ../../

cp ${BASEDIR}/input/mc_NANO_2017.py ./

sed -i 's/XX-MINI-XX/'${outfilename}'/g' mc_NANO_2017.py 
sed -i 's/XX-NANO-XX/'${outfilename}'/g' mc_NANO_2017.py

mv mc_NANO_2017.py ${outfilename}_nanoaod_cfg.py

#Run
cmsRun ${outfilename}_nanoaod_cfg.py

###########
###########
# Stage out #v1
copypath=$(readlink -f ./${outfilename}_miniaod.root)
echo "${copypath} will be copied to EOS"

xrdcp file://${copypath} root://cmseos.fnal.gov//store/user/jongho/temp/${outfilename}_nano.root

echo "DONE."
