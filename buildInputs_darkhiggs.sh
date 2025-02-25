#!/bin/bash
BASEDIR=${PWD}

##### Change mass point ####
year=${1}
mZ=${2}
mHS=${3}
mCHI=${4}

mkdir -p ./submit/input/
cp ./inputs/nanotools.tar ./submit/input/

dname=DarkHiggs_MonoHs_LO_${year}
gridpack=DarkHiggs_MonoHs_LO_MZprime-${mZ}_Mhs-${mHS}_Mchi-${mCHI}_gSM-0p25_gDM-1p0_th-0p01_13TeV-madgraph_slc7_amd64_gcc630_CMSSW_9_3_8_tarball.tar.xz 

echo "You're producing mono dark Higgs sample!"
cp ${BASEDIR}/hadronizer/${dname}_hadronizer.py ${BASEDIR}/hadronizer/${dname}_MZprime-${mZ}_Mhs-${mHS}_Mchi-${mCHI}_hadronizer.py

sed -i "s/mz/${mZ}/g" ${BASEDIR}/hadronizer/${dname}_MZprime-${mZ}_Mhs-${mHS}_Mchi-${mCHI}_hadronizer.py
sed -i "s/mhs/${mHS}/g" ${BASEDIR}/hadronizer/${dname}_MZprime-${mZ}_Mhs-${mHS}_Mchi-${mCHI}_hadronizer.py
sed -i "s/mchi/${mCHI}/g" ${BASEDIR}/hadronizer/${dname}_MZprime-${mZ}_Mhs-${mHS}_Mchi-${mCHI}_hadronizer.py

##### Check parameters are properly changed #####
cat ${BASEDIR}/hadronizer/${dname}_MZprime-${mZ}_Mhs-${mHS}_Mchi-${mCHI}_hadronizer.py | grep "gridpack ="
echo ""

#copying necessary inputs
echo "HADRONIZER=${dname}_MZprime-${mZ}_Mhs-${mHS}_Mchi-${mCHI}_hadronizer.py" > ./submit/inputs.sh
echo "PROCESS=${dname}_MZprime-${mZ}_Mhs-${mHS}_Mchi-${mCHI}" >> ./submit/inputs.sh
echo "USERNAME=${USER}" >> ./submit/inputs.sh

echo "Directory name: work_${dname}_MZprime-${mZ}_Mhs-${mHS}_Mchi-${mCHI}"
rm -r work_${dname}_MZprime-${mZ}_Mhs-${mHS}_Mchi-${mCHI}
mkdir -p work_${dname}_MZprime-${mZ}_Mhs-${mHS}_Mchi-${mCHI}
SUBMIT_WORKDIR=${BASEDIR}/work_${dname}_MZprime-${mZ}_Mhs-${mHS}_Mchi-${mCHI}
outdirname=Mz${mZ}_mhs${mHS}_Mdm${mCHI}


if [ ${year} -eq 2016 ]; then
    mv ${BASEDIR}/hadronizer/${dname}_MZprime-${mZ}_Mhs-${mHS}_Mchi-${mCHI}_hadronizer.py ./submit/input/
    cp gridpacks/gridpack2016/${gridpack} ./submit/input
    cp inputs/aod_template2016.py ./submit/input/
    cp inputs/pu_files2016.py ./submit/input/
    cp inputs/mc_NANO_2016.py ./submit/input/
    cp ${BASEDIR}/exec2016.sh $SUBMIT_WORKDIR
    # Change output dir
    cp scripts/runEventGeneration2016_v2.sh ./submit/ 
    sed -i "s/changeME/${outdirname}/g" ./submit/runEventGeneration2016_v2.sh
    eos root://cmseos.fnal.gov mkdir -p /store/user/jongho/DarkHiggs/NanoAODv6/${year}/${outdirname}
    eos root://cmseos.fnal.gov ls /store/user/jongho/DarkHiggs/NanoAODv6/${year} | grep --color=auto "${outdirname}"
fi

if [ ${year} -eq 2017 ]; then
    mv ${BASEDIR}/hadronizer/${dname}_MZprime-${mZ}_Mhs-${mHS}_Mchi-${mCHI}_hadronizer.py ./submit/input/
    cp gridpacks/gridpack2017_2018/${gridpack} ./submit/input
    cp inputs/aod_template2017.py ./submit/input/
    cp inputs/pu_files2017.py ./submit/input/
    cp inputs/mc_NANO_2017.py ./submit/input/
    cp ${BASEDIR}/exec2017.sh $SUBMIT_WORKDIR
    # Change output dir
    cp scripts/runEventGeneration2017_slc7.sh ./submit/ 
    sed -i "s/changeME/${outdirname}/g" ./submit/runEventGeneration2017_slc7.sh
    eos root://cmseos.fnal.gov mkdir -p /store/user/jongho/DarkHiggs/NanoAODv6/${year}/${outdirname}
    eos root://cmseos.fnal.gov ls /store/user/jongho/DarkHiggs/NanoAODv6/${year} | grep --color=auto "${outdirname}"
fi

if [ ${year} -eq 2018 ]; then
    mv ${BASEDIR}/hadronizer/${dname}_MZprime-${mZ}_Mhs-${mHS}_Mchi-${mCHI}_hadronizer.py ./submit/input/
    cp gridpacks/gridpack2017_2018/${gridpack} ./submit/input
    cp inputs/aod_template2018.py ./submit/input/
    cp inputs/pu_files2018.py ./submit/input/
    cp inputs/mc_NANO_2018.py ./submit/input/
    cp ${BASEDIR}/exec2018.sh $SUBMIT_WORKDIR
    # Change output dir
    cp scripts/runEventGeneration2018_slc7.sh ./submit/ 
    sed -i "s/changeME/${outdirname}/g" ./submit/runEventGeneration2018_slc7.sh
    eos root://cmseos.fnal.gov mkdir -p /store/user/jongho/DarkHiggs/NanoAODv6/${year}/${outdirname}
    eos root://cmseos.fnal.gov ls /store/user/jongho/DarkHiggs/NanoAODv6/${year} | grep --color=auto "${outdirname}"
fi

#creating tarball
echo "Tarring up submit..."
echo ""
tar -chzf submit.tgz submit 
rm -r ${BASEDIR}/submit/input/*

mv submit.tgz $SUBMIT_WORKDIR

#does everything look okay?
ls -lh $SUBMIT_WORKDIR
