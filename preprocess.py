import subprocess
import os
from glob import glob
import argparse

parser = argparse.ArgumentParser(
    prog='prepare condor jobs!',
    description='Control them!',
)

parser.add_argument(
    '-m',
    '--model',
    metavar = 'NAME',
    type = str,
    help = 'MonoHiggs model name: zpbaryonic, 2hdma (supported), or zp2hdma (not supported)',
    required = True,
    dest = 'model',
)

args = parser.parse_args()

files = glob(f'hadronizer/monoHiggsToBB_{args.model}/*py')
files = sorted(files)

for ifile in files:
    dname = ifile.split('hadronizer_')[1].split('.py')[0]
    run_args = ['bash', 'buildInputs_monohiggs.sh', args.model, dname, '2016']
    print(run_args, '\n')
    subprocess.run(run_args)

### For DarkHiggs ###
#for mhs in ['110', '130', '150']:
#    for key in mass_dict.keys():
#        dirname = 'done_work_DarkHiggs_MonoHs_LO_2017_MZprime-%s_Mhs-%s_Mchi-%s' % (str(mass_dict[key]['mz']), mhs, str(mass_dict[key]['mdm']))
#        isExist = os.path.exists(dirname)
#        gridpack = 'gridpacks/gridpack2017_2018/DarkHiggs_MonoHs_LO_MZprime-%s_Mhs-%s_Mchi-%s_gSM-0p25_gDM-1p0_th-0p01_13TeV-madgraph_slc7_amd64_gcc630_CMSSW_9_3_8_tarball.tar.xz' % (str(mass_dict[key]['mz']), mhs, str(mass_dict[key]['mdm']))
#        isGridpack = os.path.exists(gridpack)
#        if isExist:
#            continue
#        else:
#            if isGridpack:
#                args = ['bash', 'buildInputs.sh', 'MonoHs', '2017', str(mass_dict[key]['mz']), mhs, str(mass_dict[key]['mdm'])]
#                print(args, '\n')
#                subprocess.run(args)
#            else:
#                print('Gridpack not found! %s %s %s \n' % (str(mass_dict[key]['mz']), mhs, str(mass_dict[key]['mdm'])))
