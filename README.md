# Running from Tarball

This is a small tool to privately generate RunIISummer16MiniAODv2 events from a standard CMS gridpack (i.e. the output has to be a cmsgrid_final.lhe file).

## Installation

1. Put your tarball/gridpack into the `inputs/` folder together with an appropriate hadronizer that has the same name.
2. Modify `submit.py`, determining where you want to store logs etc.  
3. Adjust the desired number of events per job here: https://github.com/maierbenedikt/running_from_tarball/blob/master/submit/runEventGeneration.sh#L59
4. Modify your output location and site identifier, which is currently set to MIT: https://github.com/maierbenedikt/running_from_tarball/blob/master/submit/runEventGeneration.sh#L151-L162

## Run

```bash
sh buildInputs.sh EWKZ2Jets_ZToLL_M-50_13TeV-madgraph-pythia8
python submit.py work_EWKZ2Jets_ZToLL_M-50_13TeV-madgraph-pythia8 $njobs
```

