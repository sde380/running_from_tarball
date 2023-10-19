#!/bin/bash
BASEDIR=${PWD}

##### Change mass point ####
data=${1}
mZ=${2}
mCHI=${3}
year=${4}

mkdir -p ./submit/input/
cp ./inputs/nanotools.tar ./submit/input/

if [ ${data} = "zpbaryonic" ]; then

    dname=ZpBaryonic_MZp${mZ}_MChi${mCHI}
    echo "You're producing mono Higgs sample with ZpBaryonic model!"

    #copying necessary inputs
    echo "HADRONIZER=hadronizer_${dname}.py" > ./submit/inputs.sh
    echo "PROCESS=${dname}" >> ./submit/inputs.sh
    echo "USERNAME=${USER}" >> ./submit/inputs.sh

    echo "Directory name: work_${dname}"
    rm -r work_${dname}
    mkdir -p work_${dname}
    SUBMIT_WORKDIR=${BASEDIR}/work_${dname}

    
    if [ ${year} -eq 2016 ]; then
        cp ${BASEDIR}/hadronizer/zpbaryonic/hadronizer_${dname}.py ./submit/input/
        cp inputs/aod_template2016.py ./submit/input/
        cp inputs/pu_files2016.py ./submit/input/
        cp inputs/mc_NANO_2016.py ./submit/input/
        cp ${BASEDIR}/exec2016.sh $SUBMIT_WORKDIR
        # Change output dir
        cp scripts/runEventGeneration2016_gridpack.sh ./submit/ 
        sed -i "s/changeME/${dname}/g" ./submit/runEventGeneration2016_gridpack.sh
        eos root://cmseos.fnal.gov mkdir -p /store/user/${USER}/monoHiggs/NanoAODv6/${year}/${dname}
        eos root://cmseos.fnal.gov ls /store/user/${USER}/monoHiggs/NanoAODv6/${year} | grep -w --color=auto "${dname}"
    fi

    #if [ ${year} -eq 2017 ]; then
    #    mv ${BASEDIR}/hadronizer/${dname}_MZprime-${mZ}_Mhs-${mHS}_Mchi-${mCHI}_hadronizer.py ./submit/input/
    #    cp gridpacks/gridpack2017_2018/${gridpack} ./submit/input
    #    cp inputs/aod_template2017.py ./submit/input/
    #    cp inputs/pu_files2017.py ./submit/input/
    #    cp inputs/mc_NANO_2017.py ./submit/input/
    #    cp ${BASEDIR}/exec2017.sh $SUBMIT_WORKDIR
    #    # Change output dir
    #    cp scripts/runEventGeneration2017_slc7.sh ./submit/ 
    #    sed -i "s/changeME/${outdirname}/g" ./submit/runEventGeneration2017_slc7.sh
    #    eos root://cmseos.fnal.gov mkdir -p /store/user/jongho/DarkHiggs/NanoAODv6/${year}/${outdirname}
    #    eos root://cmseos.fnal.gov ls /store/user/jongho/DarkHiggs/NanoAODv6/${year} | grep --color=auto "${outdirname}"
    #fi

    #if [ ${year} -eq 2018 ]; then
    #    mv ${BASEDIR}/hadronizer/${dname}_MZprime-${mZ}_Mhs-${mHS}_Mchi-${mCHI}_hadronizer.py ./submit/input/
    #    cp gridpacks/gridpack2017_2018/${gridpack} ./submit/input
    #    cp inputs/aod_template2018.py ./submit/input/
    #    cp inputs/pu_files2018.py ./submit/input/
    #    cp inputs/mc_NANO_2018.py ./submit/input/
    #    cp ${BASEDIR}/exec2018.sh $SUBMIT_WORKDIR
    #    # Change output dir
    #    cp scripts/runEventGeneration2018_slc7.sh ./submit/ 
    #    sed -i "s/changeME/${outdirname}/g" ./submit/runEventGeneration2018_slc7.sh
    #    eos root://cmseos.fnal.gov mkdir -p /store/user/jongho/DarkHiggs/NanoAODv6/${year}/${outdirname}
    #    eos root://cmseos.fnal.gov ls /store/user/jongho/DarkHiggs/NanoAODv6/${year} | grep --color=auto "${outdirname}"
    #fi
    
    #creating tarball
    echo "Tarring up submit..."
    echo ""
    tar -chzf submit.tgz submit 
    rm -r ${BASEDIR}/submit/input/*

    mv submit.tgz $SUBMIT_WORKDIR

    #does everything look okay?
    ls -lh $SUBMIT_WORKDIR
fi
