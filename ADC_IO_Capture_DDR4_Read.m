clearvars
init_ADC_Capture_4x4_IQ_DDR4
%% Common Params
IPAddr = 'ip:192.168.1.101';
DDR4_ReadLen = initObjects.registerConfig.ddr4_samples;

% Debug mode:
% If set to true, we capture counter data which is a ramp from 1 to N
% If false we capture ADC data
DebugMode = 0; 
rd_sharedmem = pspshared.libiio.sharedmem.read('IPAddress',IPAddr,'DataType',initObjects.registerConfig.ddr4_data_type);
scopeStruct = setupScopes(DebugMode,initObjects,DDR4_ReadLen);
writeAXI = setupWriteRegisters(IPAddr,DebugMode,DDR4_ReadLen,initObjects);
[readAXI, DiagnosticRd] = setupReadRegisters(IPAddr);
data_rd_1 = captureLoop(struct('AXI4_CPIStart',writeAXI.CPIStart,...
    'DDR4_ReadLen',DDR4_ReadLen,'rd',rd_sharedmem,'DiagnosticRd',DiagnosticRd,...
    'hScope',scopeStruct.hScope,'hSpecAn',scopeStruct.hSpecAn,...
    'isDone',scopeStruct.isDone));


%% Local Function Definitions

function scopeStruct = setupScopes(DebugMode,initObjects,DDR4_ReadLen)

    if DebugMode
        YScale = [-DDR4_ReadLen*2, DDR4_ReadLen*2];
    else
        YScale = [-3500, 3500];
    end
    hScope = dsp.TimeScope(1, initObjects.synthesisConfig.sample_rate_hz,...
                        'TimeSpanSource', 'Auto', ...
                        'AxesScaling', 'Manual',...
                        'YLimits', YScale,...
                        'LayoutDimensions', [1 1]);
    hSpecAn = dsp.SpectrumAnalyzer( ...
                        'SampleRate', initObjects.synthesisConfig.sample_rate_hz);
    hSpecAn.FrequencyResolutionMethod = 'Windowlength';
    hSpecAn.PlotMaxHoldTrace = false;
    hSpecAn.PlotNormalTrace = true;
    % Capturelength/CPILength is the first pulse, just look at first 4
    hSpecAn.WindowLength = DDR4_ReadLen/initObjects.radarSetup.pulses_per_cpi*4; 
    hSpecAn.Window = 'Rectangular';
    hSpecAn.ViewType  = 'Spectrum and spectrogram'

    %These 4 lines capture the scope or spectrum analyzer plots closing so we
    %can punt out of while loop with done=true
    isDone = utilities.Reference(false);

    frmWrk = hScope.getFramework;
    addlistener(frmWrk.Parent,'Close', @setIsDone);
    frmWrk = hSpecAn.getFramework;
    addlistener(frmWrk.Parent,'Close', @setIsDone);
    
    scopeStruct = utilities.v2struct();
    
    function setIsDone(src,event)
        % local function holds reference to the local variables, 
        % including the isDone Reference object.  This allows the 
        % callback  to @setIsDone to modify the variable in THIS context
        % rather than using evalin('base',@(~,~)'isDone.value=true') which 
        % requires isDone to be in the base workspace.
        isDone.value = true;
    end    

end



function writeReg = setupWriteRegisters(IPAddr,DebugMode,DDR4_ReadLen,initObjects)

% Name,Adr,Type,InitialValue
WriteNameAdrTypeValue_cell = {...
    'ADC_SelectCh',hex2dec('11C'),uint32(0),0;...
    'CPIStart',hex2dec('100'),boolean(0),false;...
    'DebugCaptureRegister',hex2dec('108'),boolean(0),DebugMode;...
    'ADC_CaptureLength',hex2dec('104'),uint32(0),DDR4_ReadLen;...
    'DDR4_ReadFrameLen',hex2dec('10C'),uint32(0),DDR4_ReadLen;...
    'DDR4_ReadAddress',hex2dec('110'),uint32(0),0;...
    'DDR4_ReadTrigger',hex2dec('114'),boolean(0),false;...
    'CPILength',hex2dec('120'),uint32(0),initObjects.registerConfig.pulses_per_cpi;...
    'PulseWidth',hex2dec('124'),uint32(0),initObjects.registerConfig.pulse_width_cycles;...
    'PRI',hex2dec('128'),uint32(0),initObjects.registerConfig.pri_cycles;...
    'RngGateDelay',hex2dec('12C'),uint32(0),initObjects.registerConfig.tx_end_to_rx_start_delay_cycles;...
    'NCO_incr',hex2dec('118'),int32(0),initObjects.registerConfig.start_inc_steps;...
    'NCO_DAC_I_Gain',hex2dec('130'),fi(0,numerictype('ufix8_En7')),1;...
    'NCO_DAC_Q_Gain',hex2dec('134'),fi(0,numerictype('ufix8_En7')),1;...
    'NCO_end_incr',hex2dec('138'),int32(0),initObjects.registerConfig.end_inc_steps;...
    'NCO_step_value',hex2dec('140'),int32(0),initObjects.registerConfig.lfm_counter_inc;...
    'RngSwathLength',hex2dec('13C'),uint32(0),initObjects.registerConfig.range_swath_cycles;...
    };


    for iWriteReg = 1:size(WriteNameAdrTypeValue_cell,1)
        writeReg.(WriteNameAdrTypeValue_cell{iWriteReg,1}) = ...
            pspshared.libiio.aximm.write(...
                'IPAddress',IPAddr,...
                 'AddressOffset',WriteNameAdrTypeValue_cell{iWriteReg,2});
    % setup register data type
        setup(writeReg.(WriteNameAdrTypeValue_cell{iWriteReg,1}),...
            (WriteNameAdrTypeValue_cell{iWriteReg,3}));
    % initialize register value
        step(writeReg.(WriteNameAdrTypeValue_cell{iWriteReg,1}),...
            WriteNameAdrTypeValue_cell{iWriteReg,4});
    end
    
end


function [readReg, DiagnosticRd] = setupReadRegisters(IPAddr)

    ReadNameAdrType_cell = {...
    'S2MM_TreadyLowCount',hex2dec('140'),'uint32';...
    'AXI4S_TlastCheck',hex2dec('134'),'int32';...
    'FIFOCapture_Overflow',hex2dec('138'),'uint32';...
    'FIFODMA_Overflow',hex2dec('13C'),'uint32';...
    'WriteCompleteCount',hex2dec('144'),'uint32';...
    'ReadCompleteCount',hex2dec('148'),'uint32';...
    'AccumulatedWrRdyCount',hex2dec('14C'),'uint32';...
    'WastedWriteCycles',hex2dec('150'),'uint32';...
    'AckLow_Count',hex2dec('154'),'uint32';...
    'CaptureFIFONum',hex2dec('158'),'uint32'};

    readReg = [];
    for iReadReg = 1:size(ReadNameAdrType_cell,1)
        readReg.(ReadNameAdrType_cell{iReadReg,1}) = ...
            pspshared.libiio.aximm.read(...
                'IPAddress',IPAddr,...
                 'AddressOffset',ReadNameAdrType_cell{iReadReg,2},...
                 'DataType',ReadNameAdrType_cell{iReadReg,3});
        readReg.(ReadNameAdrType_cell{iReadReg,1}).setup();
    end

    DiagnosticRd.S2MM_TreadyLowCount = {readReg.S2MM_TreadyLowCount ,'TReadyLow Count = %d \n'};
    DiagnosticRd.AXI4S_TlastCheck = {readReg.AXI4S_TlastCheck, 'TlastCheck  : %d (If ~= 0 then DMA transaction is broken) \n'};
    DiagnosticRd.FIFOCapture_Overflow = {readReg.FIFOCapture_Overflow, 'Samples thrown on the floor (lost): %d (If > 0 then data was lost in capture)  \n'};
    DiagnosticRd.FIFODMA_Overflow = {readReg.FIFODMA_Overflow, 'DMA FIFO Almost Full Count :  %d (If >0 if AXI4-Stream DMA exerted backpressure. \n This does NOT necessarily mean that data was lost)  \n'};
    DiagnosticRd.WriteCompleteCount = {readReg.WriteCompleteCount, 'WriteCompleteCount = %d \n'};
    DiagnosticRd.ReadCompleteCount= {readReg.ReadCompleteCount,'ReadCompleteCount = %d \n'};
    DiagnosticRd.AccumulatedWrRdyCount = {readReg.AccumulatedWrRdyCount, 'Accumulated !write-ready count = %d \n'};
    DiagnosticRd.WastedWriteCycles = {readReg.WastedWriteCycles, 'Wasted write-cycles (increments) = %d \n'};
    DiagnosticRd.AckLow_Count = {readReg.AckLow_Count, 'FIFO Ack Backpressure count= %d \n'};
    DiagnosticRd.CaptureFIFONum = {readReg.CaptureFIFONum, 'FIFO Num value = %d \n'};

end


function data_rd_1 = captureLoop(inputStruct)
    utilities.v2struct(inputStruct)
    disp('Close the scope to stop the example...');
    
    assert(isa(isDone,'utilities.Reference'),'isDone Reference object not present in local workspace.')
    isDone.value = false;
    frameIdx = 0;
    ToneUpdateRate = 5; % Change tone every 40 frames
    prevLostSampleCount = 0;

    while ~isDone.value

       AXI4_CPIStart(1);
       AXI4_CPIStart(0);

        % Perform shared mem retreival
        data_rd_1 = rd(0,DDR4_ReadLen*8); % read 2 gigs out, 8 or how many int16 samples in 128

        % Unpack data from word-ordering in memory 
        % (set in ADC_Capture_4x4_IQ_DDR4/HDL_IP/DDR_Capture_Logic/DataBusBreakout)
        % will no longer work
        temp = reshape(data_rd_1, 4, []);
        data_i = reshape(temp(:,1:2:end),[],1);
        data_q = reshape(temp(:,2:2:end),[],1);
        data = complex(data_i,data_q);


        hScope(data); % Plot data
        hSpecAn(data); % Plot freq response
        frameIdx = frameIdx + 1;

        PrintDiagnostics(DiagnosticRd)

    % 	pause(1);
    end
    %return

    release(rd) %releases shared memory object reader
    % StreamEn(0) % disable stream
end

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
