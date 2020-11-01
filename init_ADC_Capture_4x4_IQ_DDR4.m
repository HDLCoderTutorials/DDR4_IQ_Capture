%% Initialize parameters
clearvars
clearvars requiredVars
requiredVars = {};

ConverterSamplingRate = 2048e6;
DDC_DUC_factor = 4;

% requiredVars{end+1} = 'Fs';
Fs = ConverterSamplingRate/DDC_DUC_factor;
Ts = 1/Fs; 

% requiredVars{end+1} = 'VectorSamplingFactor';
VectorSamplingFactor = 4;

fpga_clk_rate = Fs/VectorSamplingFactor;
fpga_Ts = 1/fpga_clk_rate;

%% Pulse parameters
% requiredVars{end+1} = 'CPILength';
CPILength = 128; % pulses per CPI
PRF = 10000; %Hz
PulseWidth = 5e-6; % seconds
RngGateDelay = 1/fpga_clk_rate; % time in seconds to delay after Tx start before Rx start
RngSwathLength = 4*PulseWidth * 1.25; % time in seconds of RX data to save each pulse, for now set to match 4*PulseWidth + 25%

%% CHIRP parameters

% requiredVars{end+1} = 'PulseWidth_count';
PulseWidth_count = PulseWidth*fpga_clk_rate;

requiredVars{end+1} = 'RngGateDelay_count';
RngGateDelay_count =RngGateDelay*fpga_clk_rate; % seconds 
requiredVars{end+1} = 'RngSwathLength_count';
RngSwathLength_count = RngSwathLength*fpga_clk_rate; % seconds * clocks per sec = fpga clock cycles

requiredVars{end+1} = 'CaptureLength';
CaptureLength = CPILength*RngSwathLength_count; % pulse_count * fpgaClockCycle_count


%% Cleanup parameters, testing to see which parameters are required.

requiredVars{end+1} = 'requiredVars'; % To aid debugging
clearvars('-except',requiredVars{:}) % Clears all non-required vars
params.original = utilities.v2struct([{'fieldNames'},requiredVars]);
clearvars('-except','requiredVars','params')

% This clearvars line is used to clear all variables from the workspace
% that aren't found in the clearvars cellarray. The objective is to verify
% that the requiredVars array has correctly identified ALL variables
% required for initialization and synthesis, which means these are the only
% vairables that a object oriented interface must provide in order to run
% everything.  Once these variables are understood, initialization
% functionality, including error checking and performance prediction, 
% will be moved to the +pl_config.RadarSetup Class and this
% script will be cleaned up.



%% OOP Initialization
% Generates all object oriented initialization objects, though 
% not guaranteed to have the same input/initialization
initObjects = initialize.initializeObjects();

% Populate required variables from object oriented initialization
% Fs = initObjects.synthesisConfig.sample_rate_hz; % Read.m
% VectorSamplingFactor = initObjects.synthesisConfig.samples_per_clock_cycle; % slx  'factor' in 'ADC_Capture_4x4_IQ_DDR4/HDL_IP/NCO_Transmit1/Vectorized NCO'
% CPILength = initObjects.radarSetup.pulses_per_cpi; % Read,  'Value' in 'ADC_Capture_4x4_IQ_DDR4/Constant2,  'Value' in 'ADC_Capture_4x4_IQ_DDR4/HDL_IP/DefaultRegister6/Constant5' 
% N = initObjects.synthesisConfig.N_accumulator; % all over slx,
% PRI_count = initObjects.registerConfig.pri_cycles;
% PulseWidth_count = initObjects.registerConfig.pulse_width_cycles;
RngGateDelay_count = initObjects.registerConfig.rx_delay_cycles ...
    - initObjects.registerConfig.pulse_width_cycles;

% Seems redundant with CaptureLength... what was the difference?
RngSwathLength_count = initObjects.registerConfig.range_swath_cycles;
% What are CaptureLength's units?  fpga cycles? Samples?  IDK...
CaptureLength        = initObjects.registerConfig.range_swath_cycles ...
    * initObjects.radarSetup.pulses_per_cpi; % Read.m, 
start_inc = initObjects.registerConfig.start_inc_steps; % compare values?
end_inc = initObjects.registerConfig.end_inc_steps; % compare values?
LFM_counter_inc = initObjects.registerConfig.lfm_counter_inc; % Calculation seems to match


%% DDR plant model param - might be acceptable, should be in a structure
DDR.DataWidth = 128;
DDR.Depth = (initObjects.registerConfig.range_swath_cycles ...
    * initObjects.radarSetup.pulses_per_cpi) ...
    / (DDR.DataWidth/(2*16)) * 1.25; % Number of 16 bit I and Q samples collect + 25%
DDR.DataType = fixdt(0,DDR.DataWidth,0);
DDR.InitData = fi(zeros(1,DDR.Depth),DDR.DataType);

%% Sim parameters - should be replaced by a second initObjects structure
% with simulation specific changes.
% Simulation specific parameters are fine, but they should be passed in 
% through a uniform interface, instead of being another random global var.
sim_CaptureLength = CaptureLength;
sim_RdFrameSize = 64;
sim_RdNumFrames = ceil(sim_CaptureLength/sim_RdFrameSize);


%% Compare original and final parameter calculations
params.final = utilities.v2struct([{'fieldNames'},requiredVars]);
% Create comparison cell array
params.comparison = requiredVars;
params.unequal = {};
for ii=1:numel(requiredVars)
    params.comparison{2,ii} = params.original.(params.comparison{1,ii});
    params.comparison{3,ii} = params.final.(params.comparison{1,ii});
    if (isa(params.comparison{2,ii},'numeric') && isa(params.comparison{3,ii},'numeric'))
        if ( params.comparison{2,ii} ~= params.comparison{3,ii} )
            params.unequal(1:3,end+1) = params.comparison(1:3,ii);
        end
    end
end

disp(params.unequal)
% Compile slx
% ADC_Capture_4x4_IQ_DDR4([], [], [], 'compile')
