function [tx_active, rx_active, rx_start, prf_rst] = ...
    system_controller(cpi_start, cpi_len, pulse_width, pri, rng_gate_delay, rng_swath_length)

%% state machine encoding
STATE_IDLE          = coder.const(fi(0, 0,2,0));
STATE_ACTIVE        = coder.const(fi(1, 0,2,0));
STATE_DONE          = coder.const(fi(2, 0,2,0));

%% counter settings
fm = coder.const(fimath('RoundingMethod','Floor','OverflowAction','Wrap'));
u32dt = coder.const(numerictype(0,32,0));

%% create persistent variables (registers)

persistent count_reg count_max_reg pulse_count_reg pulse_count_last_reg
if isempty(count_reg)
    count_reg = fi(0, u32dt, fm);
    count_max_reg = fi(0, u32dt, fm);
    pulse_count_reg = fi(0, u32dt, fm);
    pulse_count_last_reg = fi(0, u32dt, fm);
end

persistent state_next
if isempty(state_next)
    state_next = STATE_IDLE;
end

%% Internal signals
state = state_next;
count = count_reg;                          % count samples in a pulse period
count_max = count_max_reg;                  % count value for last sample in a pulse period
pulse_count = pulse_count_reg;              % count number of pulse periods completed
pulse_count_last = pulse_count_last_reg;    % count value for last pulse in CPI

%% state machine logic

% output defaults
tx_active = false;
rx_active = false;
rx_start = false;
prf_rst = false;

switch state
    
    case STATE_IDLE
        if cpi_start
            state_next = STATE_ACTIVE;
            count_reg(:) = 0;
            pulse_count_reg(:) = 0;
            count_max_reg(:) = pri-1;
            pulse_count_last_reg(:) = cpi_len-1;
            prf_rst = true;
        end
        
    case STATE_ACTIVE
        if count == count_max    %end of pulse period?
            count_reg(:) = 0;    
            if pulse_count == pulse_count_last    %end of cpi?
                state_next = STATE_DONE; 
            else
                pulse_count_reg(:) = pulse_count + 1;
            end
        else
            count_reg(:) = count + 1;
        end
        
        % Outputs
        if (count < pulse_width)
            tx_active = true;
        end        
        if (count >= rng_gate_delay) && (count < (rng_gate_delay + rng_swath_length))  %only capture from range delay to end of swath
            rx_active = true; 
        end
        if (count == rng_gate_delay) && (pulse_count == 0)    %start of first pulse
            rx_start = true;
        end
        if (count == count_max)       %end of pulse_width, reset NCO logic
            prf_rst = true;
        end
        
    case STATE_DONE
        if ~cpi_start
            state_next = STATE_IDLE;
        end
        
    otherwise
        state_next = STATE_IDLE;
end
