function config = chirp_400MHz_baseband()
    % Generates structure of initialization objects using pl_config package

    %% Synthesis Config Initialization
    scStruct.fpga_clock_rate_hz = 128e6;
    scStruct.sample_rate_hz = 512e6;
    scStruct.N_accumulator = 14;
    config.synthesis = pl_config.SynthesisConfig(scStruct);
    assert(config.synthesis.isValid(),'Sythesis Config Failed validation.')

    %% Radar Setup Initialization
    rsStruct.pulses_per_cpi = 128;
    rsStruct.pulse_width_sec = 5e-6;
    rsStruct.prf_hz = 10e3;
    rsStruct.scene_start_m = 2000;
    rsStruct.range_swath_m =  1000 ;
    rsStruct.chirp_start_frequency_hz = -200e6;
    rsStruct.chirp_stop_frequency_hz = 200e6;
    rsStruct.pl_synthesis_config = config.synthesis;
    config.radar = pl_config.RadarSetup(rsStruct);
    assert(config.radar.isValid(),'Radar Setup Failed validation.')

    % config.radar.getRadarPerformance()
    % config.radar.plot()
    %% Register Config Initialization
    % This pl_config is the config for programming the fpga programable logic.
    config.register = config.radar.getRegisterConfig();
    assert(config.register.isValid(),'PL Register Config Failed validation.')
    end