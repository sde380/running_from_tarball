# Running from Tarball

This is a small framework to privately generate RunII MC events from a standard CMS gridpack (i.e. the output has to be a cmsgrid_final.lhe file).

## Installation

1. Prepare your hadronizer including "externalLHEproducer" module and put into the `inputs/` folder
2. Modify `submit_slc7.py`, determining where you want to store logs etc.  
3. Adjust the desired number of events per job here:  
https://github.com/Quantumapple/running_from_tarball/blob/jongho/submit/runEventGeneration2017_slc7.sh#L63  
```cmsDriver.py Configuration/GenProduction/python/${HADRONIZER} --fileout file:${outfilename}_gensim.root --mc --eventcontent RAWSIM,LHE --datatier GEN-SIM,LHE --conditions 93X_mc2017_realistic_v3 --beamspot Realistic25ns13TeVEarly2017Collision --step LHE,GEN,SIM --geometry DB:Extended --era Run2_2017 --python_filename ${outfilename}_gensim.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring --customise_commands process.RandomNumberGeneratorService.externalLHEProducer.initialSeed="int(${seed})" -n $nevents
```
4. Modify your output location and site identifier, which is currently set to LPC cluster:  
https://github.com/Quantumapple/running_from_tarball/blob/jongho/submit/runEventGeneration2017_slc7.sh#L113

## Run

```bash
bash buildInputs.sh DarkHiggs_MonoHs/Jet_LO_2017/2018 mhs/mjet 2016/2017/2018
python submit_slc7.py $work_directory $njobs
```
