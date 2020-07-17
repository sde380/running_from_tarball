#!/bin/bash

###########
# setup
export BASEDIR=`pwd`


############
# inputs

export VO_CMS_SW_DIR=/cvmfs/cms.cern.ch
source $VO_CMS_SW_DIR/cmsset_default.sh
source inputs.sh

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
# generate LHEs

export SCRAM_ARCH=slc6_amd64_gcc630
CMSSWRELEASE=CMSSW_9_3_8
scram p CMSSW $CMSSWRELEASE
cd $CMSSWRELEASE/src
eval `scram runtime -sh`
cd -

tar xvaf ${BASEDIR}/input/${TARBALL}

sed -i 's/exit 0//g' runcmsgrid.sh

ls -lhrt

RANDOMSEED=`od -vAn -N4 -tu4 < /dev/urandom`

#Sometimes the RANDOMSEED is too long for madgraph
RANDOMSEED=`echo $RANDOMSEED | rev | cut -c 3- | rev`

#Run
. runcmsgrid.sh 300 ${RANDOMSEED} 1

TempNumber=${RANDOMSEED}
outfilename_tmp="$PROCESS"'_'"$RANDOMSEED"
outfilename="${outfilename_tmp//[[:space:]]/}"

mv cmsgrid_final.lhe ${outfilename}.lhe
export LHEDIR=`pwd`

ls -lhrt
#
#############
#############
# Generate GEN-SIM

export SCRAM_ARCH=slc6_amd64_gcc700
scram p CMSSW CMSSW_10_2_3
cd CMSSW_10_2_3/src
eval `scram runtime -sh`
mkdir -p Configuration/GenProduction/python/
cp ${BASEDIR}/input/${HADRONIZER} Configuration/GenProduction/python/
scram b -j 1
mv ${LHEDIR}/${outfilename}.lhe ./

cmsDriver.py Configuration/GenProduction/python/${HADRONIZER} --filein file:${outfilename}.lhe --fileout file:${outfilename}_gensim.root --mc --eventcontent RAWSIM --customise Configuration/DataProcessing/Utils.addMonitoring --datatier GEN-SIM --conditions 102X_upgrade2018_realistic_v11 --beamspot Realistic25ns13TeVEarly2018Collision --step GEN,SIM --nThreads 2 --geometry DB:Extended --era Run2_2018 --python_filename ${outfilename}_gensim.py --no_exec -n 500

#Make each file unique to make later publication possible
linenumber=`grep -n 'process.source' ${outfilename}_gensim.py | awk '{print $1}'`
linenumber=${linenumber%:*}
total_linenumber=`cat ${outfilename}_gensim.py | wc -l`
bottom_linenumber=$((total_linenumber - $linenumber ))
tail -n $bottom_linenumber ${outfilename}_gensim.py > tail.py
head -n $linenumber ${outfilename}_gensim.py > head.py
echo "    firstRun = cms.untracked.uint32(1)," >> head.py
echo "    firstLuminosityBlock = cms.untracked.uint32($RANDOMSEED)," >> head.py
cat tail.py >> head.py
mv head.py ${outfilename}_gensim.py
rm -rf tail.py

#Run
cmsRun ${outfilename}_gensim.py

#
############
############
# Generate AOD

cp ${BASEDIR}/input/pu_files2018.py .
cp ${BASEDIR}/input/aod_template2018.py .

sed -i 's/XX-GENSIM-XX/'${outfilename}'/g' aod_template2018.py
sed -i 's/XX-AODFILE-XX/'${outfilename}'/g' aod_template2018.py

mv aod_template2018.py ${outfilename}_1_cfg.py

cmsRun ${outfilename}_1_cfg.py

cmsDriver.py step2 --filein file:${outfilename}_step1.root --fileout file:${outfilename}_aod.root --mc --eventcontent AODSIM --runUnscheduled --datatier AODSIM --conditions 102X_upgrade2018_realistic_v15 --step RAW2DIGI,L1Reco,RECO,RECOSIM,EI --procModifiers premix_stage2 --nThreads 2 --era Run2_2018 --python_filename ${outfilename}_2_cfg.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n 500 

#Run
cmsRun ${outfilename}_2_cfg.py

#
###########
###########
# Generate MiniAOD

cmsDriver.py step1 --filein file:${outfilename}_aod.root --fileout file:${outfilename}_miniaod.root --mc --eventcontent MINIAODSIM --runUnscheduled --datatier MINIAODSIM --conditions 102X_upgrade2018_realistic_v15 --beamspot Realistic25ns13TeVEarly2018Collision --step PAT --nThreads 2 --geometry DB:Extended --era Run2_2018 --python_filename ${outfilename}_miniaod_cfg.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n 500

#Run
cmsRun ${outfilename}_miniaod_cfg.py
###########
###########
# Stage out #v1

#xrdcp file:///$PWD/${outfilename}_miniaod.root root://cmseos.fnal.gov//store/user/jongho/DarkHiggs/MonoDarkHiggs/year2018/mHs50/MZprime_500_Mhs_50_Mchi_150/DarkHiggs_MonoHs_LO_MZprime_500_Mhs_50_Mchi_150_${TempNumber}_miniaod.root
#xrdcp file:///$PWD/${outfilename}_miniaod.root root://cmseos.fnal.gov//store/user/jongho/DarkHiggs/MonoDarkHiggs/year2018/mHs70/MZprime_500_Mhs_70_Mchi_150/DarkHiggs_MonoHs_LO_MZprime_500_Mhs_70_Mchi_150_${TempNumber}_miniaod.root
#xrdcp file:///$PWD/${outfilename}_miniaod.root root://cmseos.fnal.gov//store/user/jongho/DarkHiggs/MonoDarkHiggs/year2018/mHs90/MZprime_500_Mhs_90_Mchi_150/DarkHiggs_MonoHs_LO_MZprime_500_Mhs_90_Mchi_150_${TempNumber}_miniaod.root
#xrdcp file:///$PWD/${outfilename}_miniaod.root root://cmseos.fnal.gov//store/user/jongho/DarkHiggs/Monojet/year2018/MZprime_500_Mchi_150/DarkHiggs_MonoJet_LO_MZprime_500_Mchi_150_${TempNumber}_miniaod.root
#xrdcp file:///$PWD/${outfilename}_miniaod.root root://cmseos.fnal.gov//store/user/jongho/DarkHiggs/MonoV/MonoW/year2018/MZprime_500_Mchi_150/DarkHiggs_MonoW_LO_MZprime_500_Mchi_150_${TempNumber}_miniaod.root
xrdcp file:///$PWD/${outfilename}_miniaod.root root://cmseos.fnal.gov//store/user/jongho/DarkHiggs/MonoV/MonoZ/year2018/MZprime_500_Mchi_150/DarkHiggs_MonoZ_LO_MZprime_500_Mchi_150_${TempNumber}_miniaod.root
echo "DONE."


