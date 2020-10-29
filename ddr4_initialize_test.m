% Reference ZCU111 RFSoC HW/SW Co-design PDF
% Pg 20-23
% Libiio 
% Reference ADC_IO_Capture_DDR4_Read.m for PSP commands

% Clears the workspace:
clear

% Creates a DATA vector from 1 to 1000; this is the devName (name of IIO device):
dataLength = 100;
CaptureLength = dataLength*8;
% DATA = (1:dataLength);
DATA = zeros(1,dataLength);
% DATA = rand(1,dataLength);

AddressOffset = 0;
% Address which is the starting address offset:
IPAddr = 'ip:192.168.1.101';
rd = pspshared.libiio.sharedmem.read('IPAddress',IPAddr,'DataType','int16');
wr = pspshared.libiio.sharedmem.write('IPAddress',IPAddr);

%% Write to DDR4 Memory, step 1
wr(AddressOffset,DATA)

%% Read directly from DDR4 Memory, step 2a
% Reference ZCU111 RFSoC HW/SW Co-design PDF
data_rd_1 = rd(AddressOffset,CaptureLength); % read 2 gigs out, 8 or how many int16 samples in 128


%% Cleanup Data and plot

% Example from ADC_IO_Capture_DDR4_Read.m
% Unpack data from word-ordering in memory 
% (set in ADC_Capture_4x4_IQ_DDR4/HDL_IP/DDR_Capture_Logic/DataBusBreakout)
% will no longer work
% temp = reshape(data_rd_1, 4, []);
% data_i = reshape(temp(:,1:2:end),[],1);
% data_q = reshape(temp(:,2:2:end),[],1);
% data = complex(data_i,data_q);

figure(1)
subplot(2,1,1)
plot(DATA,'*')
title('Input Data')
subplot(2,1,2)
plot(data_rd_1,'*')
title('Output Data')

%% Cleanup
release(rd) %releases shared memory object reader

%{
% AXI4 MM IIO Write registers
AXI4_ADC_SelectCh =  pspshared.libiio.aximm.write(...
                   'IPAddress',IPAddr,...
                   'AddressOffset',hex2dec('11C')); 
                        

ADDR = 'ip:192.168.1.101';

% Returns a Shared Memory Write system object (AXI4_DDR4_Write), that provides access to a
% shared memory region (DDR4?) using LibIIO:
AXI4_DDR4_Write = pspshared.libiio.sharedmem.write(...
                'IPAddress',ADDR,...   % IP Address property     - Hostname or IP address of remote IIO device
                'AddressOffset',hex2dec('032')); % Address offset property - Address offset within the memory region in bytes

% Copies a buffer of data (txSignal), to the memory region starting at
% address offset ADDR:
step(AXI4_DDR4_Write, ADDR, DATA) % how does this compare to the release method?
%}

