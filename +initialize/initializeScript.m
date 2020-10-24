clearvars


%% Function wrapped initialization
input=struct('ConverterSamplingRate',2048e6,'DDC_DUC_factor',4,...
    'VectorSamplingFactor',4,'CPILength', 128,'PRF' , 10000,...
    'PulseWidth' , 5e-6,'f0' , 0,'f1' , 140e6,'N' , 14);

output = initialize.initializeFunction(input)


%% Object Oriented Init

% Input argument name/value pairs are stored as cell arrays and converted 
% to structures to make input comparisons to the functional initialization 
% more convenient.
synthesisCellArray = {'fpga_clock_rate_hz',128e6,'sample_rate_hz',512e6,'N_accumulator',14};
synthesisStruct = cell2struct(synthesisCellArray(2:2:end),synthesisCellArray(1:2:end),2);
synthesisConfig = pl_config.SynthesisConfig(synthesisCellArray{:})
assert(synthesisConfig.isValid(),'Sythesis Config Failed validation.')



radarSetupCellArray = {'pulses_per_cpi',1024,'pulse_width_sec',1e-6,'prf_hz',20e3,...
    'scene_start_m',200,'range_swath_m',1000,...
    'chirp_start_frequency_hz',-100e6,'chirp_stop_frequency_hz',100e6,...
    'pl_synthesis_config',synthesisConfig};
radarSetupStruct = cell2struct(radarSetupCellArray(2:2:end),radarSetupCellArray(1:2:end),2);
radarSetup = pl_config.RadarSetup(radarSetupCellArray{:});
assert(radarSetup.isValid(),'Radar Setup Failed validation.')

radarSetup.getRadarPerformance()
radarSetup.plot()
% This pl_config is the output for programming the fpga programable logic.
pl_register_config = radarSetup.getRadarPlConfig() 
assert(pl_register_config.isValid(),'PL Register Config Failed validation.')
