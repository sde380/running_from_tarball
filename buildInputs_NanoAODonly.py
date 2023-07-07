import re
import shutil
import subprocess
import sys
import os

def replace_patterns(file_path, replacements):
    with open(file_path, 'r') as file:
        content = file.read()

    for pattern, replacement in replacements.items():
        content = re.sub(pattern, replacement, content)

    with open(file_path, 'w') as file:
        file.write(content)

def main():
    with open(sys.argv[1], 'r') as infile:
            flist = [line.strip() for line in infile.readlines()]

    home = os.getcwd()

    source_file = 'inputs/mc_NANO_2016.py'
    nanoaod_tool = 'inputs/nanotools.tar'
    bash_script = 'scripts/runEventGeneration2016_NanoAODonly.sh'
    execute_script = './exec2016_NanoAODonly.sh'

    files = [source_file, nanoaod_tool, bash_script,  execute_script]

    for f in flist:
        tag = f.split('/')[-1].split('-')[0]
        name = f.split('/')[7]
        outdir = './{}_{}'.format(name, tag)
        os.makedirs(outdir, exist_ok=True)
        submit_dir = os.path.join(outdir, 'submit')
        os.makedirs(submit_dir, exist_ok=True)

        shutil.copy(files[0], submit_dir+'/{}_{}.py'.format(name, tag))
        shutil.copy(files[1], submit_dir)
        shutil.copy(files[2], submit_dir)
        shutil.copy(files[3], outdir)

        replacements = {
                r'file:XX-MINI-XX_miniaod.root': '{}'.format(f),
                r'file:XX-NANO-XX_nano': '{}_{}_nano'.format(name, tag)
            }
        replace_patterns(os.path.join(submit_dir, '{}_{}.py'.format(name, tag)), replacements)

        replacements = {
                r'nanoaod_cfg': '{}_{}'.format(name, tag),
                r'changeME': '{}_{}'.format(name, tag)
            }
        replace_patterns(os.path.join(submit_dir, 'runEventGeneration2016_NanoAODonly.sh'), replacements)

        os.chdir(outdir)
        subprocess.run(['tar', '-chzf', './submit.tgz', './submit'])
        os.chdir(home)
        shutil.rmtree(submit_dir)

if __name__ == '__main__':
    main()
