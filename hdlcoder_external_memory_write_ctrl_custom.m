function [ram_addr, ddr_write_done, wr_addr, wr_len, wr_valid, wasted_cycle_cnt] = ...
    hdlcoder_external_memory_write_ctrl_custom(burst_len, start, data_avail, wr_ready, wr_complete)
%% hdlcoder_external_memory_write_ctrl_custom
%
% % State-machine behavior for writing to DDR4

%   Copyright 2017 The MathWorks, Inc.

%% state machine encoding
IDLE              = fi(0, 0, 4, 0);
WRITE_BURST_START = fi(1, 0, 4, 0);
DATA_COUNT        = fi(2, 0, 4, 0);
ACK_WAIT          = fi(3, 0, 4, 0);

%% counter settings
fm = coder.const(fimath('RoundingMethod','Floor','OverflowAction','Wrap'));
u32dt = coder.const(numerictype(0,32,0));

%% create persistent variables (registers)
persistent wstate burst_stop burst_count wasted_cycle_count
if(isempty(wstate))
    wstate      = IDLE;
    burst_stop  = fi(0, u32dt, fm);
    burst_count = fi(0, u32dt, fm);
    wasted_cycle_count = fi(0, u32dt, fm);    
end
wasted_cycle_cnt = wasted_cycle_count;

%% state machine logic
switch (wstate)
    case IDLE
        % output to AXI4 Master
        wr_addr  = uint32(0);
        wr_len   = uint32(0);
        wr_valid = false;
        
        % output to DUT logic
        ram_addr = uint32(0);
        ddr_write_done = true;
        
        % state variables
        burst_stop(:) = burst_len;
        burst_count(:) = 0;
        
        if start
            wstate(:) = WRITE_BURST_START;
        else
            wstate(:) = IDLE;
        end
        
        
    case WRITE_BURST_START
        % output to AXI4 Master
        wr_addr  = uint32(0);
        wr_len   = uint32(burst_stop);
        wr_valid = false;
        
        % output to DUT logic
        ram_addr = uint32(burst_count);
        ddr_write_done = false;
    
        
        if wr_ready
            wstate(:) = DATA_COUNT;
        else
            wstate(:) = WRITE_BURST_START;
            wasted_cycle_count(:) = wasted_cycle_count+1;
        end
        
        
    case DATA_COUNT
        % output to AXI4 Master
        wr_addr  = uint32(0);
        wr_len   = uint32(burst_stop);
        wr_valid = data_avail;
        
        % state variables
        if data_avail
            burst_count(:) = burst_count + 1;
        end
        
        % output to DUT logic
        ram_addr = uint32(burst_count);
        ddr_write_done = false;
        
        if ( burst_count == burst_stop )
            wstate(:) = ACK_WAIT;
        else
            if ( wr_ready )
                wstate(:) = DATA_COUNT;
            else
                wstate(:) = WRITE_BURST_START;
            end
        end
        
        
    case ACK_WAIT
        % output to AXI4 Master
        wr_addr  = uint32(0);
        wr_len   = uint32(0);
        wr_valid = false;
        
        % output to DUT logic
        ram_addr = uint32(0);
        ddr_write_done = false;
        
        if wr_complete
            wstate(:) = IDLE;
        else
            wstate(:) = ACK_WAIT;
        end
        
    otherwise
        % output to AXI4 Master
        wr_addr = uint32(0);
        wr_len = uint32(0);
        wr_valid = false;
        
        % output to DUT logic
        ram_addr = uint32(0);
        ddr_write_done = false;
        
        wstate(:) = IDLE;
        
end

end

% LocalWords:  AXI
