import re
import shutil
import subprocess
import sys
import os

with open(sys.argv[1], 'r') as infile:
    flist = [line.strip() for line in infile.readlines()]

source_file = 'inputs/mc_NANO_2016.py'
nanoaod_tool = 'inputs/nanotools.tar'
bash_script = 'scripts/runEventGeneration2016_NanoAODonly.sh'
execute_script = './exec2016_NanoAODonly.sh'

for i, f in enumerate(flist):

    tag = f.split('/')[-1].split('-')[0]
    name = f.split('/')[7]
    print(name, tag)
    outdir = './' + 'work_{}_{}'.format(name, tag)
    os.makedirs(outdir, exist_ok=True)
    submit_dir = outdir + '/submit'
    os.makedirs(submit_dir, exist_ok=True)
    destination_file = submit_dir + '/mc_NANO.py'
    shutil.copy(source_file, destination_file)
    destination = submit_dir
    shutil.copy(nanoaod_tool, destination)
    shutil.copy(bash_script, destination)
    shutil.copy(execute_script, outdir)

    with open(destination_file, 'r') as nanoConfig:
        content = nanoConfig.read()

    replacements = {
        r'file:XX-MINI-XX_miniaod.root': '{}'.format(f),
        r'file:XX-NANO-XX_nano': '{}_{}_nano'.format(name, tag)
    }

    new_content = content
    for pattern, replacement in replacements.items():
        new_content = re.sub(pattern, replacement, new_content)

    final_file = submit_dir + '/{}_{}.py'.format(name, tag)

    with open(final_file, 'w') as outfile:
        outfile.write(new_content)

    os.unlink(destination_file)

    replacements = {
        r'nanoaod_cfg': '{}_{}'.format(name, tag),
        r'changeME': '{}_{}'.format(name, tag)
    }

    # Read the content of the file
    with open(destination + '/runEventGeneration2016_NanoAODonly.sh') as bash:
        content = bash.read()

    # Perform replacements
    for pattern, replacement in replacements.items():
        content = re.sub(pattern, replacement, content)

    # Overwrite the file with the modified content
    with open(destination + '/runEventGeneration2016_NanoAODonly.sh', 'w') as bash:
        bash.write(content)

    subprocess.run(['tar', '-chzf', outdir+'/submit.tgz', submit_dir])
    shutil.rmtree(submit_dir)
