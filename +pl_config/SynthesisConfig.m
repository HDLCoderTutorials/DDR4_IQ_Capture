classdef SynthesisConfig < handle & pl_config.Validator
    %SynthesisConfig Holds fpga and ADC/DAC clock speeds
    %   Data class for fpga parameters that are sythesized into the
    %   bitstream. As such, parameters changed here to not generally have
    %   an effect until the bitstream is rebuilt.

    properties
        fpga_clock_rate_hz
        sample_rate_hz
        N_accumulator
    end
    
    properties (Dependent)
        samples_per_clock_cycle
        Ts % Sample period
    end

    methods
        function obj = SynthesisConfig(varargin)
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
        
        function Ts_value = get.Ts(obj)
            Ts_value = 1/obj.sample_rate_hz;
        end
        
        function set.Ts(obj,Ts_value)
            obj.sample_rate_hz = 1/Ts_value;
        end
        
        function valid = isValid(obj)
            % isValid validate before use
            valid = obj.allPropertiesAreSingletonAndDefined();
        end

    end
end

