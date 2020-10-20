% Reference ZCU111 RFSoC HW/SW Co-design PDF
% Pg 20-23
% Libiio 
% Reference ADC_IO_Capture_DDR4_Read.m for PSP commands

% Clears the workspace:
clear

%% Write to DDR4 Memory, step 1

% Creates a DATA vector from 1 to 1000; this is the devName (name of IIO device):
DATA = 1:1000;

% Address which is the starting address offset:
ADDR = 'ip:192.168.1.101';

% Returns a Shared Memory Write system object (AXI4_DDR4_Write), that provides access to a
% shared memory region (DDR4?) using LibIIO:
AXI4_DDR4_Write = pspshared.libiio.sharedmem.write(...
                'IPAddress',ADDR,...   % IP Address property     - Hostname or IP address of remote IIO device
                'AddressOffset',hex2dec('032')); % Address offset property - Address offset within the memory region in bytes

% Copies a buffer of data (txSignal), to the memory region starting at
% address offset ADDR:
step(AXI4_DDR4_Write, ADDR, DATA) % how does this compare to the release method?



%% Read directly from DDR4 Memory, step 2a
% Reference ZCU111 RFSoC HW/SW Co-design PDF


