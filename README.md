# Running from Tarball

This is a small framework to privately generate RunII MC events from a standard CMS gridpack (i.e. the output has to be a cmsgrid_final.lhe file).

### MonoHiggs model
[model] = 'zpbaryonic', '2hdma'
```
python3 preprocess.py -m [model]
```
Then, replace [njobs] to 200.
```
python3 submit_slc6.py work_[mass point] [njobs]
```
