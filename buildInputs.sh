#!/bin/bash
export TARBALLDIR="/uscms_data/d1/jongho/running_from_tarball"
export BASEDIR=${PWD}
rm -r work_${1}
mkdir work_${1}
export SUBMIT_WORKDIR=${PWD}/work_${1}
year=${2}

#copying necessary inputs
echo "TARBALL=${1}_tarball.tar.xz" > ./submit/inputs.sh
echo "HADRONIZER=${1}_hadronizer.py" >> ./submit/inputs.sh
echo "PROCESS=${1}" >> ./submit/inputs.sh
echo "USERNAME=${USER}" >> ./submit/inputs.sh

if [ -z "$3" ]
    then
    echo "MERGE=0" >> ./submit/inputs.sh
    echo "You want to produce events for $1. Good luck!"
else
    echo "MERGE=1" >> ./submit/inputs.sh
    echo "You want to merge the T2 files for $1? Ok."
fi


if [ ${year} -eq 2016 ]; then
    mkdir -p ./submit/input/
    cp ${TARBALLDIR}/inputs/${1}_tarball.tar.xz ./submit/input/
    cp ${TARBALLDIR}/inputs/${1}_hadronizer.py ./submit/input/
    cp inputs/copy.tar ./submit/input/
    cp inputs/aod_template.py ./submit/input/
    cp inputs/pu_files.py ./submit/input/
    cp ${BASEDIR}/exec.sh $SUBMIT_WORKDIR
fi

if [ ${year} -eq 2017 ]; then
    mkdir -p ./submit/input/
    cp ${TARBALLDIR}/inputs/${1}_tarball.tar.xz ./submit/input/
    cp ${TARBALLDIR}/inputs/${1}_hadronizer.py ./submit/input/
    cp inputs/copy.tar ./submit/input/
    cp inputs/aod_template2017.py ./submit/input/
    cp inputs/pu_files2017.py ./submit/input/
    cp ${BASEDIR}/exec2017.sh $SUBMIT_WORKDIR
fi

if [ ${year} -eq 2018 ]; then
    mkdir -p ./submit/input/
    cp ${TARBALLDIR}/inputs/${1}_tarball.tar.xz ./submit/input/
    cp ${TARBALLDIR}/inputs/${1}_hadronizer.py ./submit/input/
    cp inputs/copy.tar ./submit/input/
    cp inputs/aod_template2018.py ./submit/input/
    cp inputs/pu_files2018.py ./submit/input/
    cp ${BASEDIR}/exec2018.sh $SUBMIT_WORKDIR
fi

#x509
#voms-proxy-init -voms cms -valid 172:00
#cp /tmp/x509up_u$UID $SUBMIT_WORKDIR/x509up
#cp ${HOME}/x509up_u$UID $SUBMIT_WORKDIR

#creating tarball
echo "Tarring up submit..."
tar -chzf submit.tgz submit 
rm -r ${BASEDIR}/submit/input/*

mv submit.tgz $SUBMIT_WORKDIR

#cp ${BASEDIR}/exec.sh $SUBMIT_WORKDIR

#does everything look okay?
ls -l $SUBMIT_WORKDIR
