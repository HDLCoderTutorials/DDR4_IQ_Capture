classdef RegisterConfig < handle & pl_config.Validator
    %RegisterConfig radar parameters for programable logic.
    %   All parameters required at runtime by the fpga/
    %   programable logic of the radar. Most parameters are in
    %   integers, with time in fpga clock cycles.
    %
    %   Class properties should be exactly what the fpga logic requires
    %   for configuration, without further conversions.
    %
    %   Properties are generated by the RadarSetup.getRegisterConfig() method.

    properties
        % pulses_per_cpi - Sets the number of contiguous pulses to capture in memeory per CPI trigger.
        % Copied right from RadarSetup
        pulses_per_cpi {mustBeInteger, mustBeGreaterThan(pulses_per_cpi,0)}
        % pri_cycles - Pulse Repitition Interval in fpga cycles
        pri_cycles {mustBeInteger}
        % pulse_width_cycles - DAC/Tx width in fpga cycles
        pulse_width_cycles {mustBeInteger}
        % rx_delay_cycles - time between tx_start and rx_start in fpga_cycles
        rx_delay_cycles {mustBeInteger}
        % range_swath_cycles - rx time in fpga cycles, range swath + pulse width
        range_swath_cycles {mustBeInteger}  % receive_time_cycles - alternate name.
        % after_rx_pri_delay_cycles - entire PRI interval
        after_rx_pri_delay_cycles {mustBeInteger}
        % tx_end_to_rx_start_delay_cycles - Gap between end of tx and start
        % of rx, in fpga cycles.  Gives redundant information with 
        % pulse_width_cycles and rx_delay_cycles.
        tx_end_to_rx_start_delay_cycles {mustBeInteger}
        % samples_per_clock_cycle - Samples processed per clock cycle.
        samples_per_clock_cycle  {mustBeInteger, mustBeGreaterThan(samples_per_clock_cycle,0)}
        start_inc_steps {mustBeInteger} % Initial NCO LFM increment
        end_inc_steps {mustBeInteger}   % Final NCO LFM increment
        % lfm_counter_inc - lfm NCO phase increment counter increment
        % NCO increment shows the phase rate for constant frequency
        % lfm_counter_inc gives the increment rate for the phase increment 
        % to describe a Linear Frequency Modulation (LFM)
        lfm_counter_inc {mustBeInteger}
        % ddr4_samples - number of samples to read from shared memory
        % this depends on whether the PL and PS data types match, how many 
        % samples per fpga cycle, and how many channels are packed in the
        % stream.
        ddr4_samples {mustBeInteger}
        % ddr4_data_type - data type to read from ddr4 memory.  The size of
        % the data type is important, since memory will be travesed faster
        % with larger data types.
        ddr4_data_type = 'int16'
        
    end

    methods
        function obj = RegisterConfig(varargin)
        % Constructor accepts name/value pairs for all properties,
        % or can be called without arguments for an empty object.
            if (nargin>0)
                obj.parseConstructorInputForClassProperties(varargin);
            end
        end

        function valid = isValid(obj)
            %isValid validate before using on FPGA radar
            valid = obj.allPropertiesAreSingletonAndDefined('exclude','ddr4_data_type');
        end

    end
end

