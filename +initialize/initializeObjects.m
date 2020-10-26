function output = initializeObjects()
% Generates structure of initialization objects using pl_config package
synthesisCellArray = {...
    'fpga_clock_rate_hz',128e6,...
    'sample_rate_hz',512e6,...
    'N_accumulator',14};
output.synthesisConfig = pl_config.SynthesisConfig(synthesisCellArray{:});
assert(output.synthesisConfig.isValid(),'Sythesis Config Failed validation.')

radarSetupCellArray = {...
    'pulses_per_cpi',128,...
    'pulse_width_sec',5e-6,...
    'prf_hz',10e3,...
    'scene_start_m',200,... % pulse width plus 1 cycle to match original
    'range_swath_m',1000,...
    'chirp_start_frequency_hz',0e6,...
    'chirp_stop_frequency_hz',140e6,...
    'pl_synthesis_config',output.synthesisConfig};
output.radarSetup = pl_config.RadarSetup(radarSetupCellArray{:});
assert(output.radarSetup.isValid(),'Radar Setup Failed validation.')

% output.radarSetup.getRadarPerformance()
% output.radarSetup.plot()
% This pl_config is the output for programming the fpga programable logic.
output.pl_register_config = output.radarSetup.getRegisterConfig();
assert(output.pl_register_config.isValid(),'PL Register Config Failed validation.')



% Convert name value cell aray argument lists into structures.
synthesisStruct = cell2struct(synthesisCellArray(2:2:end),synthesisCellArray(1:2:end),2);
radarSetupStruct = cell2struct(radarSetupCellArray(2:2:end),radarSetupCellArray(1:2:end),2);
