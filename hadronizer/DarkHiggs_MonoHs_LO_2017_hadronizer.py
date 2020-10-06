import FWCore.ParameterSet.Config as cms

from Configuration.Generator.Pythia8CommonSettings_cfi import *
from Configuration.Generator.MCTunes2017.PythiaCP5Settings_cfi import *
#from Configuration.Generator.PSweightsPythia.PythiaPSweightsSettings_cfi import *

import sys

print('Mass point is', sys.argv[0], 'for mediator', sys.argv[1], 'for dark matter and', sys.argv[2], 'for dark Higgs')
print('Number of events are', sys.argv[3])

gridpack = '/cvmfs/cms.cern.ch/phys_generator/gridpacks/2017/13TeV/madgraph/V5_2.6.0/DarkHiggs/MonoHs/DarkHiggs_MonoHs_LO_MZprime-'+str(sys.argv[0])+'_Mhs-'+str(sys.argv[2])+'_Mchi-'+str(sys.argv[1])+'_gSM-0p25_gDM-1p0_th-0p01_13TeV-madgraph_slc6_amd64_gcc630_CMSSW_9_3_8_tarball.tar.xz'

externalLHEProducer = cms.EDProducer("ExternalLHEProducer",
        #args = cms.vstring('/cvmfs/cms.cern.ch/phys_generator/gridpacks/2017/13TeV/madgraph/V5_2.6.0/DarkHiggs/MonoHs/DarkHiggs_MonoHs_LO_MZprime-195_Mhs-70_Mchi-100_gSM-0p25_gDM-1p0_th-0p01_13TeV-madgraph_slc6_amd64_gcc630_CMSSW_9_3_8_tarball.tar.xz'),
        args = cms.vstring(gridpack),
        nEvents = cms.untracked.uint32(sys.argv[3]),
        numberOfParameters = cms.uint32(1),
        outputFile = cms.string('cmsgrid_final.lhe'),
        scriptName = cms.FileInPath('GeneratorInterface/LHEInterface/data/run_generic_tarball_cvmfs.sh')
)


generator = cms.EDFilter("Pythia8HadronizerFilter",
    maxEventsToPrint = cms.untracked.int32(1),
    pythiaPylistVerbosity = cms.untracked.int32(1),
    filterEfficiency = cms.untracked.double(1.0),
    pythiaHepMCVerbosity = cms.untracked.bool(False),
    comEnergy = cms.double(13000.),
    PythiaParameters = cms.PSet(
        pythia8CommonSettingsBlock,
        pythia8CP5SettingsBlock,
        #pythia8PSweightsSettingsBlock,
        processParameters = cms.vstring(
            'JetMatching:setMad = off',
            'JetMatching:scheme = 1',
            'JetMatching:merge = on',
            'JetMatching:jetAlgorithm = 2',
            'JetMatching:etaJetMax = 5.',
            'JetMatching:coneRadius = 1.',
            'JetMatching:slowJetPower = 1',
            'JetMatching:qCut = 20.', #this is the actual merging scale
            'JetMatching:nQmatch = 4', #5 for 5-flavour scheme (matching of b-quarks)
            'JetMatching:nJetMax = 1', #number of partons in born matrix element for highest multiplicity
            'JetMatching:doShowerKt = off', #off for MLM matching, turn on for shower-kT matching
        ),
        parameterSets = cms.vstring('pythia8CommonSettings',
                                    'pythia8CP5Settings',
                                    #'pythia8PSweightsSettings',
                                    'processParameters',
                                    )
    )
)
