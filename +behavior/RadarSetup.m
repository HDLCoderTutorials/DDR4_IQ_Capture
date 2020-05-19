classdef RadarSetup < handle & behavior.Validator
    %RadarSetup Takes desired radar settings and calculates pulse delays.
    %   Calculate all state machine, ADC, DAC delays in terms of sample delays.
    %   Provide basic validation, as well as estimate of the data rate and 
    %   storage required per pulse and per CPI.
    %
    %   Eventually could provide plots to illustrate timing and pulse characteristics.

    properties (Hidden)
        OriginalInputs
        c = 3e8
    end
    
    properties
        is_validated = false % ?
        is_calculated = false % Have input parameters be rounded and converted to integer sample delays?
        rfsoc_clock_rates % object containing fpga clock rate and sample rate, in Hz
        pulses_per_cpi % Sets the number of contiguous pulses to capture in memeory per CPI trigger.
        pri_sec % Define either prf_hz or pri_sec, not both. Must be long enough to allow ADC capture to complete.
        pulse_width_seconds
        range_swath_m % Range swath in meters, note that this must be added to the pulse width in calculating the number of ADC samples.
        range_delay_m % Start of range swath. Must be greater delay than the pulse width.


        radar_pl_configuration % Object with config parameters for programable logic.

    end

    properties (Dependent)
        prf_hz % Calculate PRI in steps from this value. 
    end

    
    methods
        function obj = RadarSetup(varargin)
            %RFSoC_Clock_Settings Construct an instance of this class
            % Constructor accepts name/value pairs for all properties,
            % or can be called without arguments for an empty object.
            if (nargin>0)
                obj.parseConstructorInputForClassProperties(varargin{:});
            end
        end
        
        function set.prf_hz(obj,prf_hz_)
            obj.pri_sec = 1/prf_hz_;
        end
        
        function prf_hz_value = get.prf_hz(obj)
           prf_hz_value = 1/obj.pri_sec; 
        end
        
        function valid = isInputValid(obj)
            %isValid Verifies that properties are defined and reasonable
            %   Returns true if properties are all defined, and if 
            %   their magnitude and relationship is reasonable.
            %   Otherwise, provides a helpful error message.

            % Validate rfsoc_clock object
            assert(isa(rfsoc_clock_rates,'behavior.RFSoC_Clock_Settings'),'rfsoc_clock_rates must be object of type behavior.RFSoC_Clock_Settings'); 
            assert(rfsoc_clock_rates.isValid,'rfsoc_clock_rates object reported invalid settings.');
            
            % Validate Radar programable logic configuration
            assert(isa(radar_pl_configuration,'behavior.Radar_pl_configuration'),'radar_pl_configuration must be object of type behavior.Radar_pl_configuration'); 
            assert(radar_pl_configuration.isValid,'radar_pl_configuration object reported invalid settings.');            
            
                      
            assert(obj.allPropertiesAreSingletonAndDefined(),'Not all properties are both defined and singleton.')
%             % Assert that all properties are defined
%             assert(~isempty(obj.fpga_clock_rate_hz),'fpga_clock_rate_hz must be defined.');
%             assert(~isempty(obj.sample_rate_hz),'sample_rate_hz must be defined.');
%             
%             
%             % Assert that all properties are singleton
%             assert(numel(obj.fpga_clock_rate_hz) == 1,'fpga_clock_rate_hz must be a single element.');
%             assert(numel(obj.sample_rate_hz) == 1,'sample_rate_hz must be a single element.');

            % Valid if we get to this line without errors.
            valid = true;

        end

        function valid = isOutputValid(obj)


        end
        
    end
end

