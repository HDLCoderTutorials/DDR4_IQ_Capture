function output = runHardware()
    ipaddress = '192.168.1.101';
    z = zynqrf;
    isBooted = utilities.Reference(false);
    isBooted.value = verifyBoardIsBooted(ipaddress,z);
    assert(isBooted.value,'Board boot could not be verified. Please reboot the board.');

    %% Program the board Programable Logic with bitstream    
    disp('Programing Device...')
    % If successful, this will cause a reboot.
    %evalin('base','hdlworkflow_ProgramTargetDevice')
    try
        error('test error')
        z.ProgramRFSoC('ModelName','ADC_Capture_4x4_IQ_DDR4')
    catch ME        
        warning(ME.message)
        warning('z.ProgramRFSoC() command failed, reverting to hdlworkflow_ProgramTargetDevice()')
        % For compatability with Sean's installation.
        hdlworkflowStruct = hdlworkflow_ProgramTargetDevice();    
    end
            

    
    %% Setup Board Mixers/Data Converter after boot, Use timer to wait
    isBooted.value = false;
    retriesLeft = 3;
    retryPeriod = 8;        
    
    function testIfBooted(src,event)
        booted = verifyBoardIsBooted(ipaddress,z);
        retriesLeft = retriesLeft - 1;
        if booted      
            stop(t)
            delete(t)
        elseif (retriesLeft <= 0)
            stop(t)
            delete(t)
            error('System did not reboot within the timout');
        else
            disp(['Failed to verify boot, ',num2str(retriesLeft),' retries left.']);
        end
        isBooted.value = booted; 
    end
    
    t = timer('StartFcn',@(~,~)disp('timer started.'),...
        'TimerFcn',@testIfBooted,...
        'ExecutionMode','fixedSpacing',...
        'period',retryPeriod,...
        'StartDelay',5);           
    start(t)
    
    while isBooted.value == false
        pause(5)                
    end
        
    % After boot, setup RF Data Converter mixers, etc.
    % Function wrapper for generated script
    mixerOutputStruct = HDL_IP_setup_rfsoc_fcn();
    disp('Bitstream loaded, board rebooted, RFTool run.');
    disp('Startup Complete.')
    
    output = utilities.v2struct();            
end

function isBootVerified = verifyBoardIsBooted(ipaddress,zynqRfObject)
    isBootVerified = false;
    %% Test Ping
    disp(['Attempting to ping IP: ',ipaddress]);
    [~,pingOutput] = system(['ping ',ipaddress],'-echo');
    
    regexp1 = 'Received\s=\s(?<received>\d+)';
    pingParse = regexp(pingOutput, regexp1,'names');        
    regexp_unreachable = '(?<Reply>Destination host unreachable.)';
    unreachedParse = regexp(pingOutput, regexp_unreachable,'names');
    packetsReceived = str2num(pingParse.received);
    packetsUnreached = numel(unreachedParse);
    % Check to see if we get 'Destination Unreachable' for every packet sent.
    if (packetsReceived > packetsUnreached)
        disp([pingParse.received,' packets received with ',num2str(packetsUnreached),...
            ' unreached from IP: ', ipaddress]);
    else
        disp(['No packets were receved when pinging IP: ',ipaddress]);
        return
    end

    %% Test zynqrf connection
    disp(['Attempting to connect to ZynqRF at IP: ',ipaddress]);
    try        
        response = '';
        response = zynqRfObject.checkConnection;        
    catch
        warning(['Unable to connect to Zynq Object at ',ipaddress]);
    end
    if strcmp(response,'Connection successful')
        disp(['Connection to ZynqRF successful at IP: ',ipaddress])
        isBootVerified = true;
    else
        warning('Connection to RFSoC failed.');
    end
end
