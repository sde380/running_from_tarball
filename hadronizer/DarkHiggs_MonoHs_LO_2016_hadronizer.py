import FWCore.ParameterSet.Config as cms

from Configuration.Generator.Pythia8CommonSettings_cfi import *
from Configuration.Generator.Pythia8CUEP8M1Settings_cfi import *

#print('Mass point is mz GeV for mediator, mchi GeV for dark matter, and mhs GeV for dark Higgs')
prefix = '/srv/tmp/'
gridpack = 'DarkHiggs_MonoHs_LO_MZprime-mz_Mhs-mhs_Mchi-mchi_gSM-0p25_gDM-1p0_th-0p01_13TeV-madgraph_slc7_amd64_gcc630_CMSSW_9_3_8_tarball.tar.xz'
fpath = prefix+gridpack

externalLHEProducer = cms.EDProducer("ExternalLHEProducer",
        args = cms.vstring(fpath),
        nEvents = cms.untracked.uint32(300),
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
        pythia8CUEP8M1SettingsBlock,
        processParameters = cms.vstring(
            "JetMatching:setMad = off",
            "JetMatching:scheme = 1",
            "JetMatching:merge = on",
            "JetMatching:jetAlgorithm = 2",
            "JetMatching:etaJetMax = 5.",
            "JetMatching:coneRadius = 1.",
            "JetMatching:slowJetPower = 1",
            "JetMatching:qCut = 20.",
            "JetMatching:nQmatch = 4",
            "JetMatching:nJetMax = 1",
            "JetMatching:doShowerKt = off"
        ),
        parameterSets = cms.vstring('pythia8CommonSettings',
                                    'pythia8CUEP8M1Settings',
                                    'processParameters',
                                    )
        )
)
