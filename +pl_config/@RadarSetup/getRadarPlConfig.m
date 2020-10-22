function pl_register_config = getRadarPlConfig(obj)
% Calculate Programable Logic radar configuration parameters
% from class properties. Validate integrity of inputs and
% outputs before and after calculations.
% Round parameters as needed to fit limitations
% of Programable Logic.
warning('getRadarPlConfig calculations are NOT complete. Proof of concept only.')
assert(obj.isInputValid(),'Input parameters are not sufficient ')
synthConfig = obj.pl_synthesis_config; % Make local copy to shorten name.

regConfigInput.pulse_width_cycles = obj.pulse_width_sec * synthConfig.fpga_clock_rate_hz;
% tx_delay_cycles is the delay between transmit and 
regConfigInput.tx_delay_cycles = 100;
regConfigInput.range_swath_cycles = ...
    (obj.range_swath_m/3e8 + obj.pulse_width_sec) * synthConfig.fpga_clock_rate_hz;
regConfigInput.after_rx_pri_delay_cycles = 200;
regConfigInput.samples_per_clock_cycle = synthConfig.samples_per_clock_cycle;
% Convert regConfigInput to cell name/value pairs, then to RegisterConfig object.
regConfCell = pl_config.Validator.struct2NameValuePairCellArray(regConfigInput);
pl_register_config = pl_config.RegisterConfig(regConfCell{:});

N = synthConfig.N_accumulator;
pl_register_config.start_inc_steps = round (((obj.chirp_start_frequency_hz*2^N)...
    /synthConfig.fpga_clock_rate_hz)/synthConfig.samples_per_clock_cycle);
pl_register_config.end_inc_steps  = round (((obj.chirp_stop_frequency_hz*2^N)...
    /synthConfig.fpga_clock_rate_hz)/synthConfig.samples_per_clock_cycle);

%Pulse width and frequencies must be chosen so that LFM_counter_inc is an
%integer, will use floor here which changes end freq to slightly less in
%some cases
LFM_counter_inc = floor((pl_register_config.end_inc_steps-pl_register_config.start_inc_steps)/...
    pl_register_config.pulse_width_cycles);
% adjust end_inc for counter limitation
end_inc = pl_register_config.start_inc_steps + LFM_counter_inc*pl_register_config.pulse_width_cycles;
pl_register_config.end_inc_steps = end_inc/(2^(N-1)-1)*256;
fprintf('Calculated chirp frequencies based on integer counter limitation:\n');
fprintf('%.0fMHz %.0fMHz\n', obj.chirp_start_frequency_hz/1e6, ...
    pl_register_config.end_inc_steps);

assert(pl_register_config.isValid(),'Radar Programable Logic Configuration object is not valid')
obj.pl_register_config = pl_register_config;
end
