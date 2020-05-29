classdef RFSoC_Clock_Settings < handle & behavior.Validator
    %RFSoCSettings Holds fpga and ADC/DAC clock speeds
    %   Data class for fpga clock rate and ADC/DAC sample rate.

    properties
        fpga_clock_rate_hz
        sample_rate_hz
        N_accumulator
    end
    
    properties (Dependent)
        samples_per_clock_cycle
    end

    methods
        function obj = RFSoC_Clock_Settings(varargin)
        %RFSoC_Clock_Settings Construct an instance of this class
        % Constructor accepts name/value pairs for all properties,
        % or can be called without arguments for an empty object.
            if (nargin>0)
                obj.parseConstructorInputForClassProperties(varargin);
            end
        end

        function samples_per_clock_cycle_value = get.samples_per_clock_cycle(obj)
           samples_per_clock_cycle_value =  round( obj.sample_rate_hz / obj.fpga_clock_rate_hz );
        end
        
        function valid = isValid(obj)
            % isValid validate before use
            valid = obj.allPropertiesAreSingletonAndDefined();
        end

    end
end

