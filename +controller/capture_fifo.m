function [count_out, DDRCaptureFIFOPush, DDRCaptureFIFOActive, FIFODropCount] = ...
    capture_fifo(ADC_Valid, RxStart, CaptureLength, FIFO_Full)

%% state machine encoding
STATE_IDLE      = coder.const(fi(0, 0,2,0));
STATE_ACTIVE	= coder.const(fi(1, 0,2,0));
STATE_FLUSH     = coder.const(fi(2, 0,2,0));

%% counter settings
fm = coder.const(fimath('RoundingMethod','Floor','OverflowAction','Wrap'));
u32dt = coder.const(numerictype(0,32,0));

%% create persistent variables (registers)

persistent ADC_Valid_count_reg valid_out_count_reg count_max_reg FIFODropCount_reg
if isempty(ADC_Valid_count_reg)
    ADC_Valid_count_reg = fi(0, u32dt, fm);
    valid_out_count_reg = fi(0, u32dt, fm);
    count_max_reg = fi(0, u32dt, fm);
    FIFODropCount_reg = fi(0, u32dt, fm);
end

persistent state_next
if isempty(state_next)
    state_next = STATE_IDLE;
end

%% Internal signals
state = state_next;
ADC_Valid_count = ADC_Valid_count_reg;
valid_out_count = valid_out_count_reg;
count_max = count_max_reg;
FIFODropCount = FIFODropCount_reg;

%% state machine logic
DDRCaptureFIFOPush = false;
switch state
    case STATE_IDLE
        
        if RxStart
            state_next = STATE_ACTIVE;
            ADC_Valid_count_reg(:) = 1;
            valid_out_count_reg(:) = 1;
            count_max_reg(:) = CaptureLength;
            FIFODropCount_reg(:) = 0;
        end
        
    case STATE_ACTIVE
        
        if ADC_Valid
            ADC_Valid_count_reg(:) = ADC_Valid_count + 1;
            if ~FIFO_Full
                DDRCaptureFIFOPush = true;
                valid_out_count_reg(:) = valid_out_count + 1;
            else
                FIFODropCount_reg(:) = FIFODropCount + 1;
            end
            
            if ADC_Valid_count == count_max
                if FIFODropCount == 0
                    % no dropped samples, capture is done
                    state_next = STATE_IDLE;
                else
                    % dropped samples, force write data to FIFO so DDR 
                    % controller can complete the burst
                    state_next = STATE_FLUSH;
                end
            end
        end
        
    case STATE_FLUSH
        
        if ~FIFO_Full
            DDRCaptureFIFOPush = true;
            valid_out_count_reg(:) = valid_out_count + 1;
            if valid_out_count == count_max
                state_next = STATE_IDLE;
            end
        end
        
        
    otherwise
        state_next = STATE_IDLE;
end

count_out = valid_out_count;
DDRCaptureFIFOActive = (state ~= STATE_IDLE);
