#!/usr/bin/env python

from sys import argv
from os import system,getenv,getuid,getcwd

workpath=getcwd()+'/'+str(argv[1])
uid=getuid()
logpath=f'/uscmst1b_scratch/lpc1/3DayLifetime/{uid}'

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
request_memory = 4096
queue {3}
'''.format(workpath,logpath,uid,njobs)

with open(logpath+'/condor.jdl','w') as jdlfile:
  jdlfile.write(classad)

system('condor_submit %s/condor.jdl'%logpath)
#+SingularityImage = "/cvmfs/singularity.opensciencegrid.org/bbockelm/cms:rhel6"
