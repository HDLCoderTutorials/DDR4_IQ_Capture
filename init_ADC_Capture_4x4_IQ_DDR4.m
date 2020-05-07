%% Initialize parameters
%
% % For DAC NCO definition

% NCO parameters
Fo = 200.7e6;  % tone freq
% Ts = 1e-3; % sample time
Ts = 1/512e6; % ADC running at 62.5
N = 14;    % accum WL

Fs = 1/Ts;      
incrScale = (2^N)/Fs;
incr = round(Fo*incrScale/4); % phase increment


CPILength = 4; % pulses per CPI
pulseLength = 16; % samples per pulse
rngGateLength = 30; % samples to ignore after Tx start
rngCaptureLength = 50;
pulsePeriod = rngGateLength+rngCaptureLength;

CaptureLength = CPILength*rngCaptureLength;

%% DDR plant model param
DDRDepth = 1024;
DDRDataWidth = 128;
DDRDataType = fixdt(0,DDRDataWidth,0);
DDRInitData = fi(zeros(1,DDRDepth),DDRDataType);

%% Sim parameters
sim_CaptureLength = CaptureLength;
sim_RdFrameSize = 64;
sim_RdNumFrames = ceil(sim_CaptureLength/sim_RdFrameSize);