%% Initialize parameters
clearvars
clearvars requiredVars
requiredVars = {};

ConverterSamplingRate = 2048e6;
DDC_DUC_factor = 4;

requiredVars{end+1} = 'Fs';
Fs = ConverterSamplingRate/DDC_DUC_factor;
Ts = 1/Fs; 

requiredVars{end+1} = 'VectorSamplingFactor';
VectorSamplingFactor = 4;

fpga_clk_rate = Fs/VectorSamplingFactor;
fpga_Ts = 1/fpga_clk_rate;

%% Pulse parameters
requiredVars{end+1} = 'CPILength';
CPILength = 128; % pulses per CPI
PRF = 10000; %Hz
PulseWidth = 5e-6; % seconds
RngGateDelay = 1/fpga_clk_rate; % time in seconds to delay after Tx start before Rx start
RngSwathLength = 4*PulseWidth * 1.25; % time in seconds of RX data to save each pulse, for now set to match 4*PulseWidth + 25%

%% CHIRP parameters

% f0 = -250e6;
% f1 = 250e6; 
f0 = 0e6;
f1 = 140e6; 

requiredVars{end+1} = 'N'; % HDL Counter max values 2^(N-1)-1
N = 14;    % accum WL

PRF_period = 1/PRF; % seconds
requiredVars{end+1} = 'PRI_count';
PRI_count = PRF_period*fpga_clk_rate;

requiredVars{end+1} = 'PulseWidth_count';
PulseWidth_count = PulseWidth*fpga_clk_rate;

requiredVars{end+1} = 'RngGateDelay_count';
RngGateDelay_count =RngGateDelay*fpga_clk_rate; % seconds 
requiredVars{end+1} = 'RngSwathLength_count';
RngSwathLength_count = RngSwathLength*fpga_clk_rate; % seconds * clocks per sec = fpga clock cycles

requiredVars{end+1} = 'CaptureLength';
CaptureLength = CPILength*RngSwathLength_count; % pulse_count * fpgaClockCycle_count

requiredVars{end+1} = 'start_inc'; % NCO increments for fo and f1
start_inc = round (((f0*2^N)/fpga_clk_rate)/VectorSamplingFactor);
requiredVars{end+1} = 'end_inc';
end_inc = round (((f1*2^N)/fpga_clk_rate)/VectorSamplingFactor);


%Pulse width and frequencies must be chosen so that LFM_counter_inc is an
%integer, will use floor here which changes end freq to slightly less in
%some cases

requiredVars{end+1} = 'LFM_counter_inc';
LFM_counter_inc = floor((end_inc-start_inc)/PulseWidth_count);

% adjust end_inc for counter limitation

end_inc = start_inc + LFM_counter_inc*PulseWidth_count;

actual_end_freq = end_inc/(2^(N-1)-1)*256;

fprintf('Calculated chirp frequencies based on integer counter limitation:\n');
fprintf('%.0fMHz %.0fMHz\n', f0/1e6, actual_end_freq);

% LFM Counter setup
% These are the parameters to the masked subsystem HDL Counter
requiredVars={requiredVars{:},'issigned','CountInit','CountFracLen',...
    'CountWordLen','freerun','CountFrom','CountDir'};
issigned = 1; % 0 - unsigned, 1 - signed
CountInit = 0;
CountFracLen = 0;
CountWordLen = N;
freerun=1;
CountFrom = 0;
CountDir = 0; % 0-up, 1-down

%% DDR plant model param
requiredVars={requiredVars{:},'DDRDataWidth','DDRDepth','DDRDataType','DDRInitData'};
DDRDataWidth = 128;
DDRDepth = (RngSwathLength_count * CPILength) / (DDRDataWidth/(2*16)) * 1.25; % Number of 16 bit I and Q samples collect + 25%
DDRDataType = fixdt(0,DDRDataWidth,0);
DDRInitData = fi(zeros(1,DDRDepth),DDRDataType);

%% Sim parameters
requiredVars={requiredVars{:},'sim_CaptureLength', 'sim_RdFrameSize', 'sim_RdNumFrames'};
sim_CaptureLength = CaptureLength;
sim_RdFrameSize = 64;
sim_RdNumFrames = ceil(sim_CaptureLength/sim_RdFrameSize);

%% Cleanup parameters, testing to see which parameters are required.

requiredVars{end+1} = 'requiredVars'; % To aid debugging
% requiredVars{end+1} = 'plConfig';
% plConfig = pl_config.RegisterConfig;

% This clearvars line is used to clear all variables from the workspace
% that aren't found in the clearvars cellarray. The objective is to verify
% that the requiredVars array has correctly identified ALL variables
% required for initialization and synthesis, which means these are the only
% vairables that a object oriented interface must provide in order to run
% everything.  Once these variables are understood, initialization
% functionality, including error checking and performance prediction, 
% will be moved to the +pl_config.RadarSetup Class and this
% script will be cleaned up.

% Clears all non-required vars
clearvars('-except',requiredVars{:})

% Clear some required vars, show name and value of last cleared var
replacedRequiredVars = requiredVars(1:7);
disp('Last prelacement varaible:   ')
eval(replacedRequiredVars{end})
clearvars(replacedRequiredVars{:})
% Generates all object oriented initialization objects, though 
% not guaranteed to have the same input/initialization
initObjects = initialize.initializeObjects();


Fs = initObjects.synthesisConfig.sample_rate_hz; % Read.m
VectorSamplingFactor = initObjects.synthesisConfig.samples_per_clock_cycle; % slx  'factor' in 'ADC_Capture_4x4_IQ_DDR4/HDL_IP/NCO_Transmit1/Vectorized NCO'
CPILength = initObjects.radarSetup.pulses_per_cpi; % Read,  'Value' in 'ADC_Capture_4x4_IQ_DDR4/Constant2,  'Value' in 'ADC_Capture_4x4_IQ_DDR4/HDL_IP/DefaultRegister6/Constant5' 
N = initObjects.synthesisConfig.N_accumulator; % all over slx,
PRI_count = initObjects.pl_register_config.pri_cycles;
PulseWidth_count = initObjects.pl_register_config.pulse_width_cycles;
RngGateDelay_count = initObjects.pl_register_config.rx_delay_cycles ...
    - initObjects.pl_register_config.pulse_width_cycles;


CaptureLength = initObjects.pl_register_config.range_swath_cycles; % Read.m, 

% Compile slx
% ADC_Capture_4x4_IQ_DDR4([], [], [], 'compile')
