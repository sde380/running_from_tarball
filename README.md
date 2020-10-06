# Running from Tarball

This is a small framework to privately generate RunII MC events from a standard CMS gridpack (i.e. the output has to be a cmsgrid_final.lhe file).

## Installation

1. Prepare your hadronizer including "externalLHEproducer" module and put into the `inputs/` folder
2. Modify `submit_slc7.py`, determining where you want to store logs etc.  
3. Adjust the desired number of events per job here: https://github.com/Quantumapple/running_from_tarball/blob/jongho/hadronizer/DarkHiggs_MonoHs_LO_2017_hadronizer.py#L13 
4. Modify your output location and site identifier, which is currently set to LPC cluster:
MiniAOD: https://github.com/Quantumapple/running_from_tarball/blob/jongho/submit/runEventGeneration2018_slc7.sh#L116
NanoAOD: https://github.com/Quantumapple/running_from_tarball/blob/jongho/submit/runEventGeneration2018_slc7.sh#L144

## Run

```bash
bash buildInputs.sh DarkHiggs_MonoHs_LO_2017 mhs/mjet 2016/2017/2018
python submit_slc7.py work_DarkHiggs_MonoHs_LO_2017_Mass_points $njobs
```
