#!/usr/bin/env python

from sys import argv
import os

workpath=os.getcwd()+'/'+str(argv[1])
uid=os.getuid()
logpath=f'/uscmst1b_scratch/lpc1/3DayLifetime/{uid}'

if not os.path.exists(logpath):
    os.mkdir(logpath)

njobs = argv[2]
classad='''
universe = vanilla
executable = {0}/exec2016.sh
should_transfer_files = YES
when_to_transfer_output = ON_EXIT
transfer_input_files = {0}/submit.tgz
transfer_output_files = ""
input = /dev/null
output = {1}/$(Cluster)_$(Process).out
error = {1}/$(Cluster)_$(Process).err
log = {1}/$(Cluster)_$(Process).log
arguments = $(Process)
+SingularityImage = "/cvmfs/singularity.opensciencegrid.org/cmssw/cms:rhel6"
request_memory = 2800
queue {3}
'''.format(workpath,logpath,uid,njobs)

with open(logpath+'/condor.jdl','w') as jdlfile:
  jdlfile.write(classad)

os.system('condor_submit %s/condor.jdl'%logpath)
