% Test Script

clear all;

pl = behavior.Radar_pl_configuration('pulse_width_cycles',100, ...
'tx_delay_cycles',200,'adc_rx_samples',500,'after_rx_pri_delay',600, ...
'samples_per_clock_cycle',4)

%% RadarSetup
% prf_hz is a dependent property

r = behavior.RadarSetup('prf_hz',2)
