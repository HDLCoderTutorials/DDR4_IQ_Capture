
%%clear
%% Common Params
IPAddr = 'ip:192.168.1.101';
CaptureSize = CaptureLength;
%CaptureSize = 1024;
DDR4_ReadLen = CaptureSize;

% Debug mode:
% If set to true, we capture counter data which is a ramp from 1 to N
% If false we capture ADC data
DebugMode = 0; 

% %% AXI4 Stream IIO Write 
% AXI4SReadObj = pspshared.libiio.axistream.read(...
%                   'IPAddress',IPAddr,...
%                   'SamplesPerFrame',DDR4_ReadLen,...
%                   'DataType','ufix128',...
%                   'Timeout',0);
% setup(AXI4SReadObj);

rd = pspshared.libiio.sharedmem.read('IPAddress',IPAddr,'DataType','int16');

%% Scopes

if DebugMode
    YScale = [-DDR4_ReadLen*2, DDR4_ReadLen*2];
else
    YScale = [-3500, 3500];
end
hScope = dsp.TimeScope(1, Fs,...
                    'TimeSpanSource', 'Auto', ...
                    'AxesScaling', 'Manual',...
                    'YLimits', YScale,...
                    'LayoutDimensions', [1 1]);
hSpecAn = dsp.SpectrumAnalyzer( ...
                    'SampleRate', Fs);
frmWrk = hScope.getFramework;
addlistener(frmWrk.Parent,'Close', @(~,~)evalin('base', 'done=true;'));
frmWrk = hSpecAn.getFramework;
addlistener(frmWrk.Parent,'Close', @(~,~)evalin('base', 'done=true;'));

%% AXI4 MM IIO Write registers
AXI4_ADC_SelectCh =  pspshared.libiio.aximm.write(...
                   'IPAddress',IPAddr,...
                   'AddressOffset',hex2dec('11C')); 
AXI4_CPIStart =  pspshared.libiio.aximm.write(...
                   'IPAddress',IPAddr,...
                   'AddressOffset',hex2dec('100')); 
AXI4_DebugCaptureRegister =  pspshared.libiio.aximm.write(...
                   'IPAddress',IPAddr,...
                   'AddressOffset',hex2dec('108')); 
AXI4_ADC_CaptureLength =  pspshared.libiio.aximm.write(...
                   'IPAddress',IPAddr,...
                   'AddressOffset',hex2dec('104')); 
AXI4_DDR4_ReadFrameLen =  pspshared.libiio.aximm.write(...
                   'IPAddress',IPAddr,...
                   'AddressOffset',hex2dec('10C')); 
AXI4_DDR4_ReadAddress =  pspshared.libiio.aximm.write(...
                   'IPAddress',IPAddr,...
                   'AddressOffset',hex2dec('110')); 
AXI4_DDR4_ReadTrigger =  pspshared.libiio.aximm.write(...
                   'IPAddress',IPAddr,...
                   'AddressOffset',hex2dec('114')); 
AXI4_CPILength =  pspshared.libiio.aximm.write(...
                   'IPAddress',IPAddr,...
                   'AddressOffset',hex2dec('120')); 
AXI4_PulseWidth =  pspshared.libiio.aximm.write(...
                   'IPAddress',IPAddr,...
                   'AddressOffset',hex2dec('124')); 
AXI4_PRI =  pspshared.libiio.aximm.write(...
                   'IPAddress',IPAddr,...
                   'AddressOffset',hex2dec('128')); 
AXI4_RngGateDelay =  pspshared.libiio.aximm.write(...
                   'IPAddress',IPAddr,...
                   'AddressOffset',hex2dec('12C')); 
AXI4_NCO_incr =  pspshared.libiio.aximm.write(...
                   'IPAddress',IPAddr,...
                   'AddressOffset',hex2dec('118')); 
AXI4_NCO_DAC_I_Gain =  pspshared.libiio.aximm.write(...
                   'IPAddress',IPAddr,...
                   'AddressOffset',hex2dec('130')); 
AXI4_NCO_DAC_Q_Gain =  pspshared.libiio.aximm.write(...
                   'IPAddress',IPAddr,...
                   'AddressOffset',hex2dec('134')); 
AXI4_NCO_end_incr =  pspshared.libiio.aximm.write(...
                   'IPAddress',IPAddr,...
                   'AddressOffset',hex2dec('138')); 
AXI4_NCO_step_value =  pspshared.libiio.aximm.write(...
                   'IPAddress',IPAddr,...
                   'AddressOffset',hex2dec('140')); 
AXI4_RngSwathLength =  pspshared.libiio.aximm.write(...
                   'IPAddress',IPAddr,...
                   'AddressOffset',hex2dec('13C')); 


%% AXI4 MM IIO Read debug registers
AXI4_S2MM_TreadyLowCount = pspshared.libiio.aximm.read(...
                 'IPAddress',IPAddr,...
                 'AddressOffset',hex2dec('140'),...
                 'DataType','uint32');
AXI4_AXI4S_TlastCheck = pspshared.libiio.aximm.read(...
                 'IPAddress',IPAddr,...
                 'AddressOffset',hex2dec('134'),...
                 'DataType','int32');
AXI4_FIFOCapture_Overflow = pspshared.libiio.aximm.read(...
                 'IPAddress',IPAddr,...
                 'AddressOffset',hex2dec('138'),...
                 'DataType','uint32');
AXI4_FIFODMA_Overflow = pspshared.libiio.aximm.read(...
                 'IPAddress',IPAddr,...
                 'AddressOffset',hex2dec('13C'),...
                 'DataType','uint32');
AXI4_WriteCompleteCount = pspshared.libiio.aximm.read(...
                 'IPAddress',IPAddr,...
                 'AddressOffset',hex2dec('144'),...
                 'DataType','uint32');
AXI4_ReadCompleteCount = pspshared.libiio.aximm.read(...
                 'IPAddress',IPAddr,...
                 'AddressOffset',hex2dec('148'),...
                 'DataType','uint32');
AXI4_AccumulatedWrRdyCount = pspshared.libiio.aximm.read(...
                 'IPAddress',IPAddr,...
                 'AddressOffset',hex2dec('14C'),...
                 'DataType','uint32');
AXI4_WastedWriteCycles = pspshared.libiio.aximm.read(...
                 'IPAddress',IPAddr,...
                 'AddressOffset',hex2dec('150'),...
                 'DataType','uint32');
AXI4_AckLow_Count = pspshared.libiio.aximm.read(...
                 'IPAddress',IPAddr,...
                 'AddressOffset',hex2dec('154'),...
                 'DataType','uint32');
AXI4_CaptureFIFONum = pspshared.libiio.aximm.read(...
                 'IPAddress',IPAddr,...
                 'AddressOffset',hex2dec('158'),...
                 'DataType','uint32');
clear DiagnosticRd;
DiagnosticRd.S2MM_TreadyLowCount = {AXI4_S2MM_TreadyLowCount ,'TReadyLow Count = %d \n'};
DiagnosticRd.AXI4S_TlastCheck = {AXI4_AXI4S_TlastCheck, 'TlastCheck  : %d (If ~= 0 then DMA transaction is broken) \n'};
DiagnosticRd.FIFOCapture_Overflow = {AXI4_FIFOCapture_Overflow, 'Samples thrown on the floor (lost): %d (If > 0 then data was lost in capture)  \n'};
DiagnosticRd.FIFODMA_Overflow = {AXI4_FIFODMA_Overflow, 'DMA FIFO Almost Full Count :  %d (If >0 if AXI4-Stream DMA exerted backpressure. \n This does NOT necessarily mean that data was lost)  \n'};
DiagnosticRd.WriteCompleteCount = {AXI4_WriteCompleteCount, 'WriteCompleteCount = %d \n'};
DiagnosticRd.ReadCompleteCount= {AXI4_ReadCompleteCount,'ReadCompleteCount = %d \n'};
DiagnosticRd.AccumulatedWrRdyCount = {AXI4_AccumulatedWrRdyCount, 'Accumulated !write-ready count = %d \n'};
DiagnosticRd.WastedWriteCycles = {AXI4_WastedWriteCycles, 'Wasted write-cycles (increments) = %d \n'};
DiagnosticRd.AckLow_Count = {AXI4_AckLow_Count, 'FIFO Ack Backpressure count= %d \n'};
DiagnosticRd.CaptureFIFONum = {AXI4_CaptureFIFONum, 'FIFO Num value = %d \n'};


%% Setup() AXI4 MM IIO Objects
% NOTE: These are placeholder values. Please update this section according to your design

% Setup AXI4MM Read IIO objects
setup(AXI4_S2MM_TreadyLowCount); 
setup(AXI4_AXI4S_TlastCheck); 
setup(AXI4_FIFOCapture_Overflow); 
setup(AXI4_FIFODMA_Overflow); 
setup(AXI4_WriteCompleteCount); 
setup(AXI4_ReadCompleteCount); 
setup(AXI4_AccumulatedWrRdyCount); 
setup(AXI4_WastedWriteCycles); 
setup(AXI4_AckLow_Count); 
setup(AXI4_CaptureFIFONum); 
% Setup AXI4MM Write IIO objects
setup(AXI4_ADC_SelectCh,uint32(0)); 
setup(AXI4_CPIStart,boolean(0)); 
setup(AXI4_DebugCaptureRegister,boolean(0)); 
setup(AXI4_ADC_CaptureLength,uint32(0)); 
setup(AXI4_DDR4_ReadFrameLen,uint32(0)); 
setup(AXI4_DDR4_ReadAddress,uint32(0)); 
setup(AXI4_DDR4_ReadTrigger,boolean(0)); 
setup(AXI4_CPILength,uint32(0)); 
setup(AXI4_PulseWidth,uint32(0)); 
setup(AXI4_PRI,uint32(0)); 
setup(AXI4_RngGateDelay,uint32(0)); 
setup(AXI4_NCO_incr,int32(0)); 
setup(AXI4_NCO_DAC_I_Gain,fi(0,numerictype('ufix8_En7'))); 
setup(AXI4_NCO_DAC_Q_Gain,fi(0,numerictype('ufix8_En7'))); 
setup(AXI4_NCO_end_incr,int32(0)); 
setup(AXI4_NCO_step_value,int32(0)); 
setup(AXI4_RngSwathLength,uint32(0));

%% Step() AXI4 MM IIO Objects - non-zero initial values
% Channel Select
step(AXI4_ADC_SelectCh,0); 
% NCO values 
AXI4_NCO_incr(start_inc);
AXI4_NCO_end_incr(end_inc);
AXI4_NCO_step_value(LFM_counter_inc);

AXI4_NCO_DAC_I_Gain(1);
AXI4_NCO_DAC_Q_Gain(1);

AXI4_DebugCaptureRegister(DebugMode); %  0 - will use default ADC data, 1 - will use counter values
AXI4_ADC_CaptureLength(CaptureSize);% setup frame-size
% DDR4 Read settings
AXI4_DDR4_ReadFrameLen(DDR4_ReadLen); 
AXI4_DDR4_ReadAddress(0); %offset in bytes of where we read from DDR4. NOTE: Since this is a 128-bit signal the stride is 16 bytes
AXI4_DDR4_ReadTrigger(false); % do not trigger
% Radar parameters
AXI4_CPILength(CPILength);
AXI4_PulseWidth(PulseWidth_count);
AXI4_PRI(PRI_count);
AXI4_RngGateDelay(RngGateDelay_count);
AXI4_RngSwathLength(RngSwathLength_count);

%% Capture loop
disp('Close the scope to stop the example...');
done = false;
frameIdx = 0;
ToneUpdateRate = 5; % Change tone every 40 frames
prevLostSampleCount = 0;

while ~done
   
   AXI4_CPIStart(1);
   AXI4_CPIStart(0);
   % The two lines below have been incorrect since we design was modified
   % for CPI's and radar pulses updated to CPIStart above, may have worked
   % in some version depending on address TriggerCapture was mapped to
   % TriggerCapture(1); % Trigger capture into DDR4 Memory
   % TriggerCapture(0);

%     AXI4_DDR4_ReadTrigger(1); % Read data out of DDR4
%     AXI4_DDR4_ReadTrigger(0);     
% 
%     ADC_Data = AXI4SReadObj();
%     if ~DebugMode
%         data = bitSlice128(ADC_Data);
%     else
%         data = ADC_Data;
%         % Check if data is mis-aligned
%         if any ( diff(double(data)) ~= 1)
%             warning('In debug capture, found mis-alignment in frame!');
%         end
%         
%     end
	
    % Perform shared mem retreival

    data_rd_1 = rd(0,CaptureSize*8); % read 2 gigs out, 8 or how many int16 samples in 128

    % Unpack data from word-ordering in memory 
    % (set in ADC_Capture_4x4_IQ_DDR4/HDL_IP/DDR_Capture_Logic/DataBusBreakout)
    % will no longer work
    temp = reshape(data_rd_1, 4, []);
    data_i = reshape(temp(:,1:2:end),1,[]);
    data_q = reshape(temp(:,2:2:end),1,[]);
    data = complex(data_i,data_q);
    
    disp('1')
%     plot(data_i)
    hScope(data_i); % Plot data
    disp('2')
    hSpecAn(data_i);
    frameIdx = frameIdx + 1;
    disp('3')
    PrintDiagnostics(DiagnosticRd)
    disp('4')
	pause(1);
end
%return

release(AXI4SReadObj)
% StreamEn(0) % disable stream

function PrintDiagnostics(DiagnosticRd)
    disp('------------- Diagnostic Read -------------')
    fieldsArr = fields(DiagnosticRd);
    Values = cellfun(@(x)DiagnosticRd.(x){1}.step,fieldsArr,'UniformOutput',false);
    PrintStatements = cellfun(@(x)DiagnosticRd.(x){2},fieldsArr,'UniformOutput',false);
    for ii = 1:length(Values)
        fprintf(PrintStatements{ii},Values{ii})
    end
end


function output = bitSlice128(sample)
    Top = 16:16:64;
    Bottom = (16:16:64) - 15;

    sample1_I = bitsliceget(sample,Top(1),Bottom(1));
    sample2_I = bitsliceget(sample,Top(2),Bottom(2));
    sample3_I = bitsliceget(sample,Top(3),Bottom(3));
    sample4_I = bitsliceget(sample,Top(4),Bottom(4));
 
    Top = Top + 64;
    Bottom = Bottom + 64;

    sample1_Q = bitsliceget(sample,Top(1),Bottom(1));
    sample2_Q = bitsliceget(sample,Top(2),Bottom(2));
    sample3_Q = bitsliceget(sample,Top(3),Bottom(3));
    sample4_Q = bitsliceget(sample,Top(4),Bottom(4));

    i_sample_s  = [sample1_I sample2_I sample3_I sample4_I]';
    q_sample_s  = [sample1_Q sample2_Q sample3_Q sample4_Q]';


    i_sample_s  = reinterpretcast(i_sample_s,numerictype(1,16,0));
    q_sample_s  = reinterpretcast(q_sample_s,numerictype(1,16,0));
    output = complex(i_sample_s(:),q_sample_s(:));

end
