function output = initializeFunction(input)

%% Initialize parameters
% clearvars requiredVars
requiredVars = {};

% ConverterSamplingRate = 2048e6;
% DDC_DUC_factor = 4;

requiredVars{end+1} = 'Fs';
Fs = input.ConverterSamplingRate/input.DDC_DUC_factor;
% Ts = 1/Fs; 

requiredVars{end+1} = 'VectorSamplingFactor';
VectorSamplingFactor = input.VectorSamplingFactor; % VectorSamplingFactor = 4;

fpga_clk_rate = Fs/input.VectorSamplingFactor;
fpga_Ts = 1/fpga_clk_rate;

%% Pulse parameters
requiredVars{end+1} = 'CPILength';
CPILength = input.CPILength; % CPILength = 128; % pulses per CPI

PRF = input.PRF; % PRF = 10000; %Hz
PulseWidth = input.PulseWidth; % PulseWidth = 5e-6; % seconds
RngGateDelay = 1/fpga_clk_rate; % time in seconds to delay after Tx start before Rx start
RngSwathLength = 4*PulseWidth * 1.25; % time in seconds of RX data to save each pulse, for now set to match 4*PulseWidth + 25%

%% CHIRP parameters

f0 = input.f0; % f0 = 0;
f1 = input.f1; % f1 = 140e6; 

requiredVars{end+1} = 'N'; % HDL Counter max values 2^(N-1)-1
N = input.N; % N = 14;    % accum WL

requiredVars{end+1} = 'CaptureLength';
CaptureLength = CPILength*RngSwathLength;

PRF_period = 1/PRF; % seconds
requiredVars{end+1} = 'PRI_count';
PRI_count = PRF_period*fpga_clk_rate;

requiredVars{end+1} = 'PulseWidth_count';
PulseWidth_count = PulseWidth*fpga_clk_rate;

requiredVars{end+1} = 'RngGateDelay_count';
RngGateDelay_count =RngGateDelay*fpga_clk_rate; % seconds 
requiredVars{end+1} = 'RngSwathLength_count';
RngSwathLength_count = RngSwathLength*fpga_clk_rate;

CaptureLength = CPILength*RngSwathLength_count;

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
requiredVars{end+1} = 'plConfig';
plConfig = pl_config.RegisterConfig;

% This clearvars line is used to clear all variables from the workspace
% that aren't found in the clearvars cellarray. The objective is to verify
% that the requiredVars array has correctly identified ALL variables
% required for initialization and synthesis, which means these are the only
% vairables that a object oriented interface must provide in order to run
% everything.  Once these variables are understood, initialization
% functionality, including error checking and performance prediction, 
% will be moved to the +pl_config.RadarSetup Class and this
% script will be cleaned up.

%clearvars('-except',requiredVars{:}) 


for iVar = 1:numel(requiredVars)
    variableName = requiredVars{iVar};
    assert(exist(variableName,'var') == 1, ['Required variable ', variableName,' does not exist.'])
    output.(variableName) = eval(variableName)
end            

