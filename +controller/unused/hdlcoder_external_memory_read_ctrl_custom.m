function [valid_out, count_out, ddr_read_done, rd_addr, rd_len, rd_avalid,ToggleTLAST,debug_state] = ...
    hdlcoder_external_memory_read_ctrl_custom(burst_len, start, rd_aready, rd_dvalid)
%% hdlcoder_external_memory_read_ctrl_custom
%
% % State-machine behavior for reading DDR4

%   Copyright 2017 The MathWorks, Inc.

%% state machine encoding
IDLE               = fi(0, 0, 4, 0);
READ_BURST_START   = fi(1, 0, 4, 0);
READ_BURST_REQUEST = fi(2, 0, 4, 0);
DATA_COUNT         = fi(3, 0, 4, 0);

%% counter settings
fm = coder.const(fimath('RoundingMethod','Floor','OverflowAction','Wrap'));
u32dt = coder.const(numerictype(0,32,0));

%% create persistent variables (registers)
persistent rstate burst_stop burst_count
if isempty(rstate)
    rstate      = IDLE;
    burst_stop  = fi(0, u32dt, fm);
    burst_count = fi(0, u32dt, fm);
end
debug_state = rstate;

%% state machine logic
ToggleTLAST = false;
switch (rstate)
    case IDLE
        % output to AXI4 Master
        rd_addr   = uint32(0);
        rd_len    = uint32(0);
        rd_avalid = false;
        
        % output to DUT logic
        valid_out = false;
        count_out = uint32(0);
        ddr_read_done = true;
        
        % State vars
        burst_stop(:)  = burst_len;
        burst_count(:) = 0;
        
        if start
            rstate(:) = READ_BURST_START;
        else
            rstate(:) = IDLE;
        end
        
    case READ_BURST_START
        % Daren Notes: the two pieces of information below is a read request
        %
        % rd_addr: Starting address for the read transaction that is sampled at 
        %          the first cycle of the transaction.
        % rd_len: The number of data values that you want to read, 
        %         sampled at the first cycle of the transaction.
        %
        % We only move to READ_BURST_REQUST if rd_aready is HIGH to confirm
        % DDR is ready for a readback request
        
        % output to AXI4 Master
        rd_addr   = uint32(0);  
        rd_len    = uint32(burst_stop);
        rd_avalid = false;
        
        % output to DUT logic
        valid_out = false;
        count_out = uint32(0);
        ddr_read_done = false;
        
        if rd_aready
            rstate(:) = READ_BURST_REQUEST;
        else
            rstate(:) = READ_BURST_START;
        end
        
    case READ_BURST_REQUEST
        % Daren Notes: read request
        %
        % rd_avalid: Control signal that specifies whether the read request is valid.
        %
        %
        
        % output to AXI4 Master
        rd_addr   = uint32(0);
        rd_len    = uint32(burst_stop);
        rd_avalid = true;
        
        % output to DUT logic
        valid_out = false;
        count_out = uint32(0);
        ddr_read_done = false;
        
        rstate(:) = DATA_COUNT;
        
    case DATA_COUNT
        % output to AXI4 Master
        rd_addr   = uint32(0);
        rd_len    = uint32(burst_stop);
        rd_avalid = false;
        
        % output to DUT logic
        valid_out = rd_dvalid;
        count_out = uint32(burst_count);
        ddr_read_done = false;
        
        % State vars
        if ( rd_dvalid )
            burst_count(:) = burst_count + 1;
        end
        
        if ( burst_count == burst_stop )
            rstate(:) = IDLE;
            if rd_dvalid
                ToggleTLAST = true;
            end
        else
            rstate(:) = DATA_COUNT;
        end
        
    otherwise
        % output to AXI4 Master
        rd_addr   = uint32(0);
        rd_len    = uint32(0);
        rd_avalid = false;
        
        % output to DUT logic
        valid_out = false;
        count_out = uint32(0);
        ddr_read_done = false;
        
        rstate(:) = IDLE;
end

end

% LocalWords:  AXI
