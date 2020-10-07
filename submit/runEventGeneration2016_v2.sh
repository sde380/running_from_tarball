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

export SCRAM_ARCH=slc6_amd64_gcc481
scram p CMSSW CMSSW_7_1_43_patch1
cd CMSSW_7_1_43_patch1/src
eval `scram runtime -sh`

mkdir -p Configuration/GenProduction/python/
cp ${BASEDIR}/input/${HADRONIZER} Configuration/GenProduction/python/

scram b

cmsDriver.py Configuration/GenProduction/python/${HADRONIZER} --fileout file:${outfilename}_gensim.root --mc --eventcontent RAWSIM,LHE --customise SLHCUpgradeSimulations/Configuration/postLS1Customs.customisePostLS1,Configuration/DataProcessing/Utils.addMonitoring --datatier GEN-SIM,LHE --conditions MCRUN2_71_V1::All --beamspot Realistic50ns13TeVCollision --step LHE,GEN,SIM --magField 38T_PostLS1 --python_filename ${outfilename}_gensim.py --no_exec -n 300 


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

export SCRAM_ARCH=slc6_amd64_gcc530
scram p CMSSW CMSSW_8_0_31
cd CMSSW_8_0_31/src
eval `scram runtime -sh`
scram b
cd ../../

cp ${BASEDIR}/input/pu_files2016.py ./
cp ${BASEDIR}/input/aod_template2016.py ./${outfilename}_cfg.py

sed -i 's/XX-GENSIM-XX/'${outfilename}'/g' ${outfilename}_cfg.py 
sed -i 's/XX-AODFILE-XX/'${outfilename}'/g' ${outfilename}_cfg.py 

cmsRun ${outfilename}_cfg.py

cmsDriver.py step2 --filein file:${outfilename}_step1.root --fileout ${outfilename}_aod.root --mc --eventcontent AODSIM --runUnscheduled --datatier AODSIM --conditions 80X_mcRun2_asymptotic_2016_TrancheIV_v6 --step RAW2DIGI,RECO,EI --nThreads 2 --era Run2_2016 --python_filename ${outfilename}_aod_cfg.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n 500

#Run
cmsRun ${outfilename}_aod_cfg.py

ls -ltrh

#
############
############
# Generate MiniAOD

export SCRAM_ARCH=slc6_amd64_gcc630
scram p CMSSW CMSSW_9_4_9
cd CMSSW_9_4_9/src
eval `scram runtime -sh`
scram b
cd ../../

cmsDriver.py step3 --filein file:${outfilename}_aod.root --fileout file:${outfilename}_miniaod.root --mc --eventcontent MINIAODSIM --runUnscheduled --datatier MINIAODSIM --conditions 94X_mcRun2_asymptotic_v3 --step PAT --nThreads 2 --era Run2_2016,run2_miniAOD_80XLegacy --python_filename ${outfilename}_miniaod_cfg.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n 500

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

cp ${BASEDIR}/input/nanotools.tar ./
tar xvaf nanotools.tar 

scram b -j 1
mv ../../${outfilename}_miniaod.root ./${outfilename}_miniaod.root

cp ${BASEDIR}/input/mc_NANO_2016.py ./${outfilename}_nanoaod_cfg.py

sed -i 's/XX-MINI-XX/'${outfilename}'/g' ${outfilename}_nanoaod_cfg.py 
sed -i 's/XX-NANO-XX/'${outfilename}'/g' ${outfilename}_nanoaod_cfg.py

#Run
cmsRun ${outfilename}_nanoaod_cfg.py

ls -ltrh

###########
###########
# Stage out #v1
copypath=$(readlink -f ./${outfilename}_nano.root)
echo "${copypath} will be copied to EOS"

xrdcp file://${copypath} root://cmseos.fnal.gov//store/user/jongho/temp/${outfilename}_nano.root

echo "DONE."
