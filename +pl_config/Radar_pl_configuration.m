classdef Radar_pl_configuration < handle & pl_config.Validator
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
        start_inc_steps
        end_inc_steps
    end

    methods
        function obj = Radar_pl_configuration(varargin)
        % Constructor accepts name/value pairs for all properties,
        % or can be called without arguments for an empty object.
            if (nargin>0)
                obj.parseConstructorInputForClassProperties(varargin);
            end
        end

        function valid = isValid(obj)
            %isValid validate before using on FPGA radar
            valid = obj.allPropertiesAreSingletonAndDefined;
        end

    end
end

