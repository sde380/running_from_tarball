#!/bin/bash
BASEDIR=${PWD}

##### Change mass point ####
year=${2}
mZ=${3}
mHS=${4}
mCHI=${5}

mkdir -p ./submit/input/
cp ./inputs/nanotools.tar ./submit/input/

data=${1}

if [ ${data} = "MonoHs" ]; then

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

    
    if [ ${year} -eq 2016 ]; then
        mv ${BASEDIR}/hadronizer/${dname}_MZprime-${mZ}_Mhs-${mHS}_Mchi-${mCHI}_hadronizer.py ./submit/input/
        cp gridpacks/gridpack2016/${gridpack} ./submit/input
        cp inputs/aod_template2016.py ./submit/input/
        cp inputs/pu_files2016.py ./submit/input/
        cp inputs/mc_NANO_2016.py ./submit/input/
        cp ${BASEDIR}/exec2016.sh $SUBMIT_WORKDIR
    fi

    if [ ${year} -eq 2017 ]; then
        mv ${BASEDIR}/hadronizer/${dname}_MZprime-${mZ}_Mhs-${mHS}_Mchi-${mCHI}_hadronizer.py ./submit/input/
        cp gridpacks/gridpack2017_2018/${gridpack} ./submit/input
        cp inputs/aod_template2017.py ./submit/input/
        cp inputs/pu_files2017.py ./submit/input/
        cp inputs/mc_NANO_2017.py ./submit/input/
        cp ${BASEDIR}/exec2017.sh $SUBMIT_WORKDIR
    fi

    if [ ${year} -eq 2018 ]; then
        mv ${BASEDIR}/hadronizer/${dname}_MZprime-${mZ}_Mhs-${mHS}_Mchi-${mCHI}_hadronizer.py ./submit/input/
        cp gridpacks/gridpack2017_2018/${gridpack} ./submit/input
        cp inputs/aod_template2018.py ./submit/input/
        cp inputs/pu_files2018.py ./submit/input/
        cp inputs/mc_NANO_2018.py ./submit/input/
        cp ${BASEDIR}/exec2018.sh $SUBMIT_WORKDIR
    fi
    
    #creating tarball
    echo "Tarring up submit..."
    echo ""
    tar -chzf submit.tgz submit 
    rm -r ${BASEDIR}/submit/input/*

    mv submit.tgz $SUBMIT_WORKDIR

    #does everything look okay?
    ls -lh $SUBMIT_WORKDIR
fi

if [ ${data} = "MonoJet" ]; then

    echo "You're producing monojet sample!"
    cp ${BASEDIR}/inputs/${1}_hadronizer.py ${BASEDIR}/inputs/${1}_MZprime-${mZ}_Mchi-${mCHI}_hadronizer.py

    sed -i "s/mz/${mZ}/g" ${BASEDIR}/inputs/${1}_MZprime-${mZ}_Mchi-${mCHI}_hadronizer.py
    sed -i "s/mhs/${mHS}/g" ${BASEDIR}/inputs/${1}_MZprime-${mZ}_Mchi-${mCHI}_hadronizer.py
    sed -i "s/mchi/${mCHI}/g" ${BASEDIR}/inputs/${1}_MZprime-${mZ}_Mchi-${mCHI}_hadronizer.py

    ##### Check parameters are properly changed #####
    cat ${BASEDIR}/inputs/${1}_MZprime-${mZ}_Mchi-${mCHI}_hadronizer.py | grep "gridpack ="
    echo ""

    #copying necessary inputs
    echo "HADRONIZER=${1}_MZprime-${mZ}_Mchi-${mCHI}_hadronizer.py" > ./submit/inputs.sh
    echo "PROCESS=${1}_MZprime-${mZ}_Mchi-${mCHI}" >> ./submit/inputs.sh
    echo "USERNAME=${USER}" >> ./submit/inputs.sh

    rm -r work_${1}_MZprime-${mZ}_Mchi-${mCHI}
    mkdir -p work_${1}_MZprime-${mZ}_Mchi-${mCHI}
    SUBMIT_WORKDIR=${BASEDIR}/work_${1}_MZprime-${mZ}_Mchi-${mCHI}
    
    if [ ${year} -eq 2016 ]; then
        mv ${BASEDIR}/inputs/${1}_MZprime-${mZ}_Mchi-${mCHI}_hadronizer.py ./submit/input/
        cp inputs/aod_template2016.py ./submit/input/
        cp inputs/pu_files2016.py ./submit/input/
        cp inputs/mc_NANO_2016.py ./submit/input/
        cp ${BASEDIR}/exec2016.sh $SUBMIT_WORKDIR
    fi

    if [ ${year} -eq 2017 ]; then
        mv ${BASEDIR}/inputs/${1}_MZprime-${mZ}_Mchi-${mCHI}_hadronizer.py ./submit/input/
        cp inputs/aod_template2017.py ./submit/input/
        cp inputs/pu_files2017.py ./submit/input/
        cp inputs/mc_NANO_2017.py ./submit/input/
        cp ${BASEDIR}/exec2017.sh $SUBMIT_WORKDIR
    fi

    if [ ${year} -eq 2018 ]; then
        mv ${BASEDIR}/inputs/${1}_MZprime-${mZ}_Mchi-${mCHI}_hadronizer.py ./submit/input/
        cp inputs/aod_template2018.py ./submit/input/
        cp inputs/pu_files2018.py ./submit/input/
        cp inputs/mc_NANO_2018.py ./submit/input/
        cp ${BASEDIR}/exec2018.sh $SUBMIT_WORKDIR
    fi
    
    #creating tarball
    echo "Tarring up submit..."
    echo ""
    tar -chzf submit.tgz submit 
    rm -r ${BASEDIR}/submit/input/*

    mv submit.tgz $SUBMIT_WORKDIR

    #does everything look okay?
    ls -lh $SUBMIT_WORKDIR
fi
