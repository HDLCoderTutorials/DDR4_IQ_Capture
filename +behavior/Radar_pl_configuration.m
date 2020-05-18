classdef Radar_pl_configuration < handle & behavior.Validator
    %Radar_pl_config radar parameters for programable logic.
    %   All parameters required at runtime by the fpga/
    %   programable logic of the radar. Most parameters are in
    %   integers, with time in fpga clock cycles.
    %
    %   Class properties should be exactly what the fpga logic requires
    %   for configuration, without further conversions.

    properties
        pulse_width_cycles % DAC/Tx width
        tx_delay_cycles % time between tx and rx
            % Should adc rx be in samples or in fpga clock cycles?
        adc_rx_samples % rx samples, range swath + pulse width
        after_rx_pri_delay_cycles % entire PRI interval
        samples_per_clock_cycle
    end

    methods
        function obj = Radar_pl_configuration(pulse_width_cycles,tx_delay_cycles,adc_rx_samples,...
                after_rx_pri_delay_cycles,samples_per_clock_cycle)
            %Radar_pl_configuration Construct an instance of this class
            if (nargin>0)
                obj.pulse_width_cycles = pulse_width_cycles;
                obj.tx_delay_cycles = tx_delay_cycles;
                obj.adc_rx_samples = adc_rx_samples;
                obj.after_rx_pri_delay_cycles = after_rx_pri_delay_cycles;
                obj.samples_per_clock_cycle = samples_per_clock_cycle;
            end
        end

        function valid = isValid(obj)
            %isValid validate before using on FPGA radar
            valid = obj.allPropertiesAreSingletonAndDefined;
        end

    end
end

