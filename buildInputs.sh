#!/bin/bash
BASEDIR=${PWD}

##### Change mass point ####
mZ=1000
mHS=50
mCHI=150
year=${3}

mkdir -p ./submit/input/
cp ./inputs/copy.tar ./submit/input/

if [ $2 = "mhs" ]; then

    echo "You're producing mono dark Higgs sample!"
    cp ${BASEDIR}/inputs/${1}_hadronizer.py ${BASEDIR}/inputs/${1}_MZprime-${mZ}_Mhs-${mHS}_Mchi-${mCHI}_hadronizer.py

    sed -i "s/mz/${mZ}/g" ${BASEDIR}/inputs/${1}_MZprime-${mZ}_Mhs-${mHS}_Mchi-${mCHI}_hadronizer.py
    sed -i "s/mhs/${mHS}/g" ${BASEDIR}/inputs/${1}_MZprime-${mZ}_Mhs-${mHS}_Mchi-${mCHI}_hadronizer.py
    sed -i "s/mchi/${mCHI}/g" ${BASEDIR}/inputs/${1}_MZprime-${mZ}_Mhs-${mHS}_Mchi-${mCHI}_hadronizer.py

    ##### Check parameters are properly changed #####
    cat ${BASEDIR}/inputs/${1}_MZprime-${mZ}_Mhs-${mHS}_Mchi-${mCHI}_hadronizer.py | grep "gridpack ="
    echo ""

    #copying necessary inputs
    echo "HADRONIZER=${1}_MZprime-${mZ}_Mhs-${mHS}_Mchi-${mCHI}_hadronizer.py" > ./submit/inputs.sh
    echo "PROCESS=${1}_MZprime-${mZ}_Mhs-${mHS}_Mchi-${mCHI}" >> ./submit/inputs.sh
    echo "USERNAME=${USER}" >> ./submit/inputs.sh

    rm -r work_${1}_MZprime-${mZ}_Mhs-${mHS}_Mchi-${mCHI}
    mkdir -p work_${1}_MZprime-${mZ}_Mhs-${mHS}_Mchi-${mCHI}
    SUBMIT_WORKDIR=${BASEDIR}/work_${1}_MZprime-${mZ}_Mhs-${mHS}_Mchi-${mCHI}

    
    if [ ${year} -eq 2016 ]; then
        #cp ${TARBALLDIR}/inputs/${1}_tarball.tar.xz ./submit/input/
        #cp ${TARBALLDIR}/inputs/${1}_hadronizer.py ./submit/input/
        cp inputs/aod_template2016.py ./submit/input/
        cp inputs/pu_files2016.py ./submit/input/
        cp ${BASEDIR}/exec2016.sh $SUBMIT_WORKDIR
    fi

    if [ ${year} -eq 2017 ]; then
        mv ${BASEDIR}/inputs/${1}_MZprime-${mZ}_Mhs-${mHS}_Mchi-${mCHI}_hadronizer.py ./submit/input/
        cp inputs/aod_template2017.py ./submit/input/
        cp inputs/pu_files2017.py ./submit/input/
        cp inputs/mc_NANO_2017.py ./submit/input/
        cp ${BASEDIR}/exec2017.sh $SUBMIT_WORKDIR
    fi

    if [ ${year} -eq 2018 ]; then
        cp ${BASEDIR}/inputs/${1}_tarball.tar.xz ./submit/input/
        cp ${BASEDIR}/inputs/${1}_hadronizer.py ./submit/input/
        cp inputs/aod_template2018.py ./submit/input/
        cp inputs/pu_files2018.py ./submit/input/
        cp ${BASEDIR}/exec2018.sh $SUBMIT_WORKDIR
    fi
    
    #creating tarball
    echo "Tarring up submit..."
    echo ""
    tar -chzf submit.tgz submit 
    rm -r ${BASEDIR}/submit/input/*

    mv submit.tgz $SUBMIT_WORKDIR

    #does everything look okay?
    ls -l $SUBMIT_WORKDIR
fi

if [ $2 = "mjet" ]; then

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
        #cp ${TARBALLDIR}/inputs/${1}_tarball.tar.xz ./submit/input/
        #cp ${TARBALLDIR}/inputs/${1}_hadronizer.py ./submit/input/
        cp inputs/aod_template2016.py ./submit/input/
        cp inputs/pu_files2016.py ./submit/input/
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
        cp ${BASEDIR}/inputs/${1}_tarball.tar.xz ./submit/input/
        cp ${BASEDIR}/inputs/${1}_hadronizer.py ./submit/input/
        cp inputs/aod_template2018.py ./submit/input/
        cp inputs/pu_files2018.py ./submit/input/
        cp ${BASEDIR}/exec2018.sh $SUBMIT_WORKDIR
    fi
    
    #creating tarball
    echo "Tarring up submit..."
    echo ""
    tar -chzf submit.tgz submit 
    rm -r ${BASEDIR}/submit/input/*

    mv submit.tgz $SUBMIT_WORKDIR

    #does everything look okay?
    ls -l $SUBMIT_WORKDIR
fi
