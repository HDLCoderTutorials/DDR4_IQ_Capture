function register_config = getRegisterConfig(obj)
% Calculate Programable Logic radar configuration parameters
% from class properties. Validate integrity of inputs and
% outputs before and after calculations.
% Round parameters as needed to fit limitations
% of Programable Logic.
%
% Generate and populate pl_config.RegisterConfig object

warning(['getRegisterConfig calculations are NOT complete. Proof of concept only.',...
    'Note that all values must be rounded to integers,',...
    ' but it would be good to account for rounding errors somewhere.'])
% A dedicated Validator.round method might be helpful which both rounds to
% the nearest integer AND records the rounding error, and possibly back
% modifies the source properties to match the integer rounding.
assert(obj.isInputValid(),'Input parameters are not sufficient ')

%% Variable Setup
sc = obj.pl_synthesis_config; % Make local copy to shorten name.
clock_hz = sc.fpga_clock_rate_hz;
N = sc.N_accumulator;
isInteger = @(number) mod(number,1) == 0;
areParametersRounded = false; % flag can be flipped by functions below.

%% Parameter calculations
[rcIn.pri_cycles, rounded.pri_sec] = GET_pri_cycles();
[rcIn.pulse_width_cycles, rounded.pulse_width_sec] = GET_pulse_width_sec();

% tx_delay_cycles is the delay between transmit and 
rcIn.rx_delay_cycles = ...
    round( 2*obj.scene_start_m/obj.c * clock_hz );
rcIn.range_swath_cycles = ...
    round( (obj.range_swath_m/obj.c + obj.pulse_width_sec) * clock_hz);
rcIn.after_rx_pri_delay_cycles = rcIn.pri_cycles - rcIn.pulse_width_cycles - rcIn.rx_delay_cycles;
rcIn.tx_end_to_rx_start_delay_cycles = rcIn.rx_delay_cycles - rcIn.pulse_width_cycles;
rcIn.samples_per_clock_cycle = sc.samples_per_clock_cycle;
rcIn.pulses_per_cpi = obj.pulses_per_cpi; % pulses_per_cpi is copied right from RadarSetup


rcIn.start_inc_steps = round (((obj.chirp_start_frequency_hz*2^N)...
    /clock_hz)/sc.samples_per_clock_cycle);
rcIn.end_inc_steps  = round (((obj.chirp_stop_frequency_hz*2^N)...
    /clock_hz)/sc.samples_per_clock_cycle);

%Pulse width and frequencies must be chosen so that lfm_counter_inc is an
%integer, will use floor here which changes end freq to slightly less in
%some cases
rcIn.lfm_counter_inc = floor((rcIn.end_inc_steps-rcIn.start_inc_steps)/...
    rcIn.pulse_width_cycles);
% adjust end_inc for counter limitation
rcIn.end_inc_steps = rcIn.start_inc_steps + rcIn.lfm_counter_inc*rcIn.pulse_width_cycles;
end_inc_actual_MHz = round( rcIn.end_inc_steps/(2^(N-1)-1)*256 );
fprintf('Calculated chirp frequencies based on integer counter limitation:\n');
fprintf('%.0fMHz %.0fMHz\n', obj.chirp_start_frequency_hz/1e6, ...
    end_inc_actual_MHz);



%% DDR4 stuff
% Value copied from original script, but not really understood.
rcIn.ddr4_samples = rcIn.range_swath_cycles * obj.pulses_per_cpi;
rcIn.ddr4_data_type = 'int16';


% Create and validate register config object
register_config = pl_config.RegisterConfig(rcIn);
assert(register_config.isValid(),'Radar Programable Logic Configuration object is not valid')
obj.registerConfig = register_config; % reference register_config in RadarSetup

if(areParametersRounded)
    disp('Rounding was required to generate integer clock cycles.' ,...
        'Equivelent RadarSetup input parameters that would work without ',...
        'rounding have been recorded.')
    disp(rounded)
end

% end of main function.
%% Local Function Definitions

% [mapStruct mapCell] = mapParameters();


    function [mapStruct, mapCell] = mapParameters()
    % registerParam, toRegisterFcn, radarParam, toRadarFcn

    mapStruct=struct(...
        'registerParam','pri_cycles','toRegisterFcn',@(pri_sec) pri_sec*clock_hz,...
        'radarParam','pri_sec','toRadarFcn',@(pri_cycles) pri_cycles / clock_hz);


   mapCell = [ ... 
    {'registerParam','toRegisterFcn','radarParam','toRadarFcn'};
    {'pri_cycles',@(pri_sec) pri_sec*clock_hz,...
    'pri_sec',@(pri_cycles) pri_cycles / clock_hz};
    {'pulse_width_cycles',@(pulse_width_sec) pulse_width_sec * clock_hz,...
    'pulse_width_sec',@(pulse_width_cycles) pulse_width_cycles / clock_hz};...
    {'rx_delay_cycles',@(scene_start_m) scene_start_m / obj.c * clock_hz,...
    'scene_start_m',@(rx_delay_cycles)  rx_delay_cycles * obj.c / clock_hz};...
    {'range_swath_cycles',@(range_swath_m) (range_swath_m/obj.c + obj.pulse_width_sec) * clock_hz,...
    'range_swath_m',@(range_swath_cycles) (range_swath_cycles/clock_hz - obj.pulse_width_sec) * obj.c };...
    ];
    end

    function [pri_cycles, pri_sec] = GET_pri_cycles()
        pri_cycles = obj.pri_sec*clock_hz;
        if( isInteger( pri_cycles ))
            pri_sec = obj.pri_sec; % and pri_cycles doesnt need rounding
        else
            areParametersRounded = true; % Sloppy way to flag....
            pri_cycles = round( pri_cycles );
            pri_sec = pri_cycles / clock_hz;
        end
    end

    function [pulse_width_cycles, pulse_width_sec] = GET_pulse_width_sec()
        pulse_width_cycles = obj.pulse_width_sec * clock_hz;
        if( isInteger( pulse_width_cycles ))
            pulse_width_sec = obj.pulse_width_sec;
        else
            areParametersRounded = true;
            pulse_width_cycles = round( pulse_width_cycles );
            pulse_width_sec = pulse_width_cycles / clock_hz;            
        end
    end

    % New Function: Round and back propagate
    % Arguments:
    % output parameter for RegisterConfig, input parameter from RadarSetup
    % function handle to calculate destination RegisterConfig parameter (integer)
    % function handle to calculate source RadarSetup parameter (non-integer)
    % Behavior: 


    function [registerParamStruct, radarParamStruct] = ...
            convertRoundAndReflectRegisterConfigParams(conversionStruct)
    % Calculate RegisterConfig parameters from RadarSetup parameters, 
    % rounding as required to conform to the integer only interface of the FPGA
    % registers populated by RegisterConfig.
    % When rounding is required to enforce integer only parameters, a mismatch
    % occures between the real world meaning of the RegisterConfig and
    % RadarSetup parameters. To prevent this mismatch, the true rounded 
    % FPGA RegisterConfig value is converted back to the human readable
    % RadarSetup parameter so performance calculations are accurate.
    %
    % conversionStruct input parameters:
    % registerParam, toRegisterFcn, radarParam, toRadarFcn
    %
    % registerParam
    %   registerConfig parameter name, can be used to populate a struct.
    % toRegisterFcn
    %   function handle which converts radarParam to registerParam
    % radarParam
    %   RadarConfig object parameter name, 
    % toRadarFcn
    %   function handle which converts registerParam to radarParam
    %
    % Output Parameters
    % [registerParamStruct, radarParamStruct] output of conversion after rounding.
    % 
    % Self Validation
    % Inputs property names must members of RadarSetup or RegisterConfig
    % Conversion functions must be inverse functions of one another.

    end

end
