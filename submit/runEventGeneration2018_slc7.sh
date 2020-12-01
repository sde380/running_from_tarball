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

export SCRAM_ARCH=slc7_amd64_gcc700
scram p CMSSW CMSSW_10_2_18
cd CMSSW_10_2_18/src
eval `scram runtime -sh`

mkdir -p Configuration/GenProduction/python/
cp ${BASEDIR}/input/${HADRONIZER} Configuration/GenProduction/python/

scram b

cmsDriver.py Configuration/GenProduction/python/${HADRONIZER} --fileout file:${outfilename}_gensim.root --mc --eventcontent RAWSIM,LHE --datatier GEN-SIM,LHE --conditions 102X_upgrade2018_realistic_v11 --beamspot Realistic25ns13TeVEarly2018Collision --step LHE,GEN,SIM --geometry DB:Extended --era Run2_2018 --python_filename ${outfilename}_gensim.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring --customise_commands process.RandomNumberGeneratorService.externalLHEProducer.initialSeed="${RANDOMSEED}" -n 300

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

cp ${BASEDIR}/input/pu_files2018.py ./
cp ${BASEDIR}/input/aod_template2018.py ./${outfilename}_cfg.py

sed -i 's/XX-GENSIM-XX/'${outfilename}'/g' ${outfilename}_cfg.py 
sed -i 's/XX-AODFILE-XX/'${outfilename}'/g' ${outfilename}_cfg.py 

cmsRun ${outfilename}_cfg.py

cmsDriver.py step2 --filein file:${outfilename}_step1.root --fileout file:${outfilename}_aod.root --mc --eventcontent AODSIM --runUnscheduled --datatier AODSIM --conditions 102X_upgrade2018_realistic_v15 --step RAW2DIGI,L1Reco,RECO,RECOSIM,EI --procModifiers premix_stage2 --nThreads 2 --era Run2_2018 --python_filename ${outfilename}_aod_cfg.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n 500

#Run
cmsRun ${outfilename}_aod_cfg.py

ls -ltrh

#
############
############
# Generate MiniAOD

cmsDriver.py step3 --filein file:${outfilename}_aod.root --fileout file:${outfilename}_miniaod.root --mc --eventcontent MINIAODSIM --runUnscheduled --datatier MINIAODSIM --conditions 102X_upgrade2018_realistic_v15 --step PAT --nThreads 2 --geometry DB:Extended --era Run2_2018 --python_filename ${outfilename}_miniaod_cfg.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n 500 

#Run
cmsRun ${outfilename}_miniaod_cfg.py

ls -ltrh *miniaod.root

### mono-hs samples ###
#OUTDIR=root://cmseos.fnal.gov//store/user/jongho/DarkHiggs/MonoDarkHiggs/mhs50GeV_2017/Mz2000_Mdm500
#OUTDIR=root://cmseos.fnal.gov//store/user/jongho/DarkHiggs/MonoDarkHiggs/mhs70GeV_2017/Mz2000_Mdm500
#OUTDIR=root://cmseos.fnal.gov//store/user/jongho/DarkHiggs/MonoDarkHiggs/mhs90GeV_2017/Mz2000_Mdm500

### mono-jet sample ###
OUTDIR=root://cmseos.fnal.gov//store/user/jongho/DarkHiggs/MonoJet/2018/Mz200_Mdm100

echo ""
echo "xrdcp output to ${OUTDIR}"

for FILE in *miniaod.root
do
    echo "command: xrdcp -f ${FILE} ${OUTDIR}/${FILE}"
    xrdcp -f ${FILE} ${OUTDIR}/${FILE} 2>&1
    XRDEXIT=$?
    if [[ $XRDEXIT -ne 0 ]]; then
        echo "exit code $XRDEXIT, failure in xrdcp"
    fi
done

###########
###########
# Generate NanoAOD

cd CMSSW_10_2_18/src
cp ${BASEDIR}/input/nanotools.tar ./
tar xvaf nanotools.tar 

scram b -j 1
mv ../../${outfilename}_miniaod.root ./${outfilename}_miniaod.root

cp ${BASEDIR}/input/mc_NANO_2018.py ./${outfilename}_nanoaod_cfg.py

sed -i 's/XX-MINI-XX/'${outfilename}'/g' ${outfilename}_nanoaod_cfg.py 
sed -i 's/XX-NANO-XX/'${outfilename}'/g' ${outfilename}_nanoaod_cfg.py

#Run
cmsRun ${outfilename}_nanoaod_cfg.py

ls -ltrh *nano.root

### mono-hs samples ###
#OUTDIRnano=root://cmseos.fnal.gov//store/user/jongho/DarkHiggs/NanoAODv6/2018/Mz2000_mhs50_Mdm500
#OUTDIRnano=root://cmseos.fnal.gov//store/user/jongho/DarkHiggs/NanoAODv6/2018/Mz2000_mhs70_Mdm500
#OUTDIRnano=root://cmseos.fnal.gov//store/user/jongho/DarkHiggs/NanoAODv6/2018/Mz2000_mhs90_Mdm500

### mono-jet sample ###
OUTDIRnano=root://cmseos.fnal.gov//store/user/jongho/DarkHiggs/NanoAODv6/2018/Mz200_mj_Mdm100

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

echo "DONE."
