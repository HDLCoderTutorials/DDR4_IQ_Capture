classdef Presets
  methods(Static)
        
    function output = originalScript()
    % Generates structure of initialization objects using pl_config package

    %% Synthesis Config Initialization
    scStruct.fpga_clock_rate_hz = 128e6;
    scStruct.sample_rate_hz = 512e6;
    scStruct.N_accumulator = 14;
    output.synthesisConfig = pl_config.SynthesisConfig(scStruct);
    assert(output.synthesisConfig.isValid(),'Sythesis Config Failed validation.')

    %% Radar Setup Initialization
    rsStruct.pulses_per_cpi = 128;
    rsStruct.pulse_width_sec = 5e-6;
    rsStruct.prf_hz = 10e3;
    rsStruct.scene_start_m = (rsStruct.pulse_width_sec + ...
        1/output.synthesisConfig.fpga_clock_rate_hz) * pl_config.RadarSetup.c/2 ;
    rsStruct.range_swath_m =  4 * (rsStruct.pulse_width_sec) * pl_config.RadarSetup.c ;
    rsStruct.chirp_start_frequency_hz = 0e6;
    rsStruct.chirp_stop_frequency_hz = 140e6;
    rsStruct.pl_synthesis_config = output.synthesisConfig;
    output.radarSetup = pl_config.RadarSetup(rsStruct);
    assert(output.radarSetup.isValid(),'Radar Setup Failed validation.')

    % output.radarSetup.getRadarPerformance()
    % output.radarSetup.plot()
    %% Register Config Initialization
    % This pl_config is the output for programming the fpga programable logic.
    output.registerConfig = output.radarSetup.getRegisterConfig();
    assert(output.registerConfig.isValid(),'PL Register Config Failed validation.')
    end
    
    
    function output = chirp_400MHz_baseband()
    % Generates structure of initialization objects using pl_config package

    %% Synthesis Config Initialization
    scStruct.fpga_clock_rate_hz = 128e6;
    scStruct.sample_rate_hz = 512e6;
    scStruct.N_accumulator = 14;
    output.synthesisConfig = pl_config.SynthesisConfig(scStruct);
    assert(output.synthesisConfig.isValid(),'Sythesis Config Failed validation.')

    %% Radar Setup Initialization
    rsStruct.pulses_per_cpi = 128;
    rsStruct.pulse_width_sec = 5e-6;
    rsStruct.prf_hz = 10e3;
    rsStruct.scene_start_m = (rsStruct.pulse_width_sec + ...
        1/output.synthesisConfig.fpga_clock_rate_hz) * pl_config.RadarSetup.c/2 ;
    rsStruct.range_swath_m =  4 * (rsStruct.pulse_width_sec) * pl_config.RadarSetup.c ;
    rsStruct.chirp_start_frequency_hz = -200e6;
    rsStruct.chirp_stop_frequency_hz = 200e6;
    rsStruct.pl_synthesis_config = output.synthesisConfig;
    output.radarSetup = pl_config.RadarSetup(rsStruct);
    assert(output.radarSetup.isValid(),'Radar Setup Failed validation.')

    % output.radarSetup.getRadarPerformance()
    % output.radarSetup.plot()
    %% Register Config Initialization
    % This pl_config is the output for programming the fpga programable logic.
    output.registerConfig = output.radarSetup.getRegisterConfig();
    assert(output.registerConfig.isValid(),'PL Register Config Failed validation.')
    end
    
  end   
end