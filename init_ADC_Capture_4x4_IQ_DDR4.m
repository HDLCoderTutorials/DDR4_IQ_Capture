%% Initialize parameters

ConverterSamplingRate = 2048e6;
DDC_DUC_factor = 4;

Fs = ConverterSamplingRate/DDC_DUC_factor;
Ts = 1/Fs; 

VectorSamplingFactor = 4;

fpga_clk_rate = Fs/VectorSamplingFactor;

fpga_Ts = 1/fpga_clk_rate;


%% Pulse parameters
CPILength = 4; % pulses per CPI
PRF = 100000; %Hz
PulseWidth = 5e-6; % seconds
RngGateDelay = 1/fpga_clk_rate; % time in seconds to delay after Tx start before Rx start
RngSwathLength = PulseWidth * 1.25; % time in seconds of RX data to save each pulse, for now set to match PulseWidth + 25%

%% CHIRP parameters

f0 = -256e6;
f1 = 256e6; 

N = 14;    % accum WL

PRF_period = 1/PRF; % seconds
PRI_count = PRF_period*fpga_clk_rate;

PulseWidth_count = PulseWidth*fpga_clk_rate;

RngGateDelay_count =RngGateDelay*fpga_clk_rate; % seconds 
RngSwathLength_count = RngSwathLength*fpga_clk_rate;

CaptureLength = CPILength*RngSwathLength_count;

start_inc = round (((f0*2^N)/fpga_clk_rate)/VectorSamplingFactor);
end_inc = round (((f1*2^N)/fpga_clk_rate)/VectorSamplingFactor);


%Pulse width and frequencies must be chosen so that LFM_counter_inc is an
%integer, will use floor here which changes end freq to slightly less in
%some cases

LFM_counter_inc = floor((end_inc-start_inc)/PulseWidth_count);

% adjust end_inc for counter limitation

end_inc = start_inc + LFM_counter_inc*PulseWidth_count;

actual_end_freq = end_inc/(2^(N-1)-1)*256;

fprintf('Calculated chirp frequencies based on integer counter limitation:\n');
fprintf('%.0fMHz %.0fMHz\n', f0/1e6, actual_end_freq);

% LFM Counter setup
% These are the parameters to the masked subsystem HDL Counter
issigned = 1; % 0 - unsigned, 1 - signed
CountInit = 0;
CountFracLen = 0;
CountWordLen = N;
freerun=1;
CountFrom = 0;
CountDir = 0; % 0-up, 1-down


%% DDR plant model param
DDRDataWidth = 128;
DDRDepth = (RngSwathLength_count * CPILength) / (DDRDataWidth/(2*16)) * 1.25; % Number of 16 bit I and Q samples collect + 25%
DDRDataType = fixdt(0,DDRDataWidth,0);
DDRInitData = fi(zeros(1,DDRDepth),DDRDataType);

%% Sim parameters
sim_CaptureLength = CaptureLength;
sim_RdFrameSize = 64;
sim_RdNumFrames = ceil(sim_CaptureLength/sim_RdFrameSize);