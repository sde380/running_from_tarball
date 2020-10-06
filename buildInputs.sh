#!/bin/bash
BASEDIR=${PWD}

##### Change mass point ####
mZ=1000
mHS=50
mCHI=150

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
year=${2}

if [ -z "$3" ]
    then
    echo "MERGE=0" >> ./submit/inputs.sh
    echo "You want to produce events for $1. Good luck!"
    echo ""
else
    echo "MERGE=1" >> ./submit/inputs.sh
    echo "You want to merge the T2 files for $1? Ok."
fi

if [ ${year} -eq 2016 ]; then
    mkdir -p ./submit/input/
    #cp ${TARBALLDIR}/inputs/${1}_tarball.tar.xz ./submit/input/
    #cp ${TARBALLDIR}/inputs/${1}_hadronizer.py ./submit/input/
    cp inputs/copy.tar ./submit/input/
    cp inputs/aod_template2016.py ./submit/input/
    cp inputs/pu_files2016.py ./submit/input/
    cp ${BASEDIR}/exec.sh $SUBMIT_WORKDIR
fi

if [ ${year} -eq 2017 ]; then
    mkdir -p ./submit/input/
    mv ${BASEDIR}/inputs/${1}_MZprime-${mZ}_Mhs-${mHS}_Mchi-${mCHI}_hadronizer.py ./submit/input/
    cp inputs/copy.tar ./submit/input/
    cp inputs/aod_template2017.py ./submit/input/
    cp inputs/pu_files2017.py ./submit/input/
    cp ${BASEDIR}/exec2017.sh $SUBMIT_WORKDIR
fi

if [ ${year} -eq 2018 ]; then
    mkdir -p ./submit/input/
    cp ${BASEDIR}/inputs/${1}_tarball.tar.xz ./submit/input/
    cp ${BASEDIR}/inputs/${1}_hadronizer.py ./submit/input/
    cp inputs/copy.tar ./submit/input/
    cp inputs/aod_template2018.py ./submit/input/
    cp inputs/pu_files2018.py ./submit/input/
    cp ${BASEDIR}/exec2018.sh $SUBMIT_WORKDIR
fi

#creating tarball
echo "Tarring up submit..."
tar -chzf submit.tgz submit 
rm -r ${BASEDIR}/submit/input/*

mv submit.tgz $SUBMIT_WORKDIR

#does everything look okay?
ls -l $SUBMIT_WORKDIR
