% Test Script

clear all;
pl = pl_config.RegisterConfig('pulse_width_cycles',100, ...
'rx_delay_cycles',200,'range_swath_cycles',500,'after_rx_pri_delay_cycles',600, ...
'samples_per_clock_cycle',4)
pl.isValid()
metaclass(pl)
%% RadarSetup
% prf_hz is a dependent property
clear radarSetup
radarSetup = pl_config.RadarSetup('prf_hz',2) % works fine, prf_hz is dependent...

%% pri_sec is an independent property
clear radarSetup
radarSetup = pl_config.RadarSetup('pri_sec',1e-3)

%%
% The problem is any time the dependent property is not called in the
% name/value initialization, because even if pri is defined, prf is going
% to be searched for, and the default value of prf_hz wich is [] will be
% inserted into prf_hz, and pri_sec = 1/prf_hz, which will throw an error.
clear radarSetup
radarSetup = pl_config.RadarSetup('pulses_per_cpi',1024,'pulse_width_sec',1e-6,'prf_hz',5e3)
% warning('An error is expected here because radarSetup.isValid() is run without all required fields populated.')
% radarSetup.isValid();


% Need to do two things... only parse non-constant, non-hidden properties
% When handling dependent properties, the result should not be assigned to 
% the class property if the parsed value is still the default null.
% it is empty.


%% Test radar setup with supporting objects

clear all
synthesisConfig = pl_config.SynthesisConfig('fpga_clock_rate_hz',128e6,...
    'sample_rate_hz',512e6,'N_accumulator',14)
synthesisConfig.isValid();

radarSetup = pl_config.RadarSetup('pulses_per_cpi',1024,'pulse_width_sec',1e-6,'prf_hz',20e3,...
    'scene_start_m',200,'range_swath_m',1000,...
    'chirp_start_frequency_hz',-100e6,'chirp_stop_frequency_hz',100e6,...
    'pl_synthesis_config',synthesisConfig)
    
radarSetup.isValid()
radarSetup.getRadarPerformance()
radarSetup.plot()
% This pl_config is the output for programming the fpga programable logic.
pl_register_config = radarSetup.getRegisterConfig() 
pl_register_config.isValid()


% Manual way of making a programable logic configuration object:
% pl_register_config = pl_config.Radar_pl_configuration('pulse_width_cycles',100,'tx_delay_cycles',100,...
%     'adc_rx_samples',1000,'after_rx_pri_delay_cycles',200,'samples_per_clock_cycle',4)



% Should add calculation and verification for the blind range from pulse width to validate range delay, 
% and the range swath with the pri.
% Calculate info on duty cycle, doppler resolution, CPI data size , 
% and CPI*PRF data rate.

% It would be good to modify Validator.parseConstructorInputForClassProperties
% to accept 3 inputs, {varargin}, an parsing rule, 'all', 'include',
% 'exclude', then a third argument, the property cell array, which
% specifies which properties to include or exclude from input parsing.
% The purpose is that some properties may be intended as intermediate
% calculations, or as a result of a calculation, and shouldn't be searched
% for while the object is being constructed.
% At present, the main way to accomplish this is to make properties hidden,
% which may be sufficent.  When other parameters are requested they could be
% gathered from their hidden properties and returned as a structure.

%% Test property filtering with arrayfun and discriminatorFcn
props = radarSetup.getNonconstantNonhiddenProperties();
discriminatorFcn = radarSetup.getDiscriminator('exclude',{'radar_pl_configuration'})
props = props(arrayfun(discriminatorFcn,props))

%%
r = pl_config.RadarSetup('chirp_start_frequency_hz',0,'chirp_bandwidth_hz',100e6)



