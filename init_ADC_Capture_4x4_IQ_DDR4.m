clearvars
% ConverterSamplingRate = 2048e6;
% DDC_DUC_factor = 4;

%% OOP Initialization
config = initialize.original_140MHz_chirp;
% config.radar.plot;
config.radar
% config.radar.getRadarPerformance

%% DDR plant model param - might be acceptable, should be in a structure
DDR.DataWidth = 128;
DDR.Depth = (config.register.range_swath_cycles ...
    * config.radar.pulses_per_cpi) ...
    / (DDR.DataWidth/(2*16)) * 1.25; % Number of 16 bit I and Q samples collect + 25%
DDR.DataType = fixdt(0,DDR.DataWidth,0);
DDR.InitData = fi(zeros(1,DDR.Depth),DDR.DataType);

%% Sim parameters - should be replaced by a second config structure
% with simulation specific changes.
% Simulation specific parameters are fine, but they should be passed in 
% through a uniform interface, instead of being another random global var.
sim_CaptureLength = config.register.ddr4_samples;
sim_RdFrameSize = 64;
sim_RdNumFrames = ceil(sim_CaptureLength/sim_RdFrameSize);

% ADC_Capture_4x4_IQ_DDR4([], [], [], 'compile') % Compile slx