classdef RadarSetup < handle & pl_config.Validator
    % RadarSetup Takes desired radar settings and calculates pulse delays.
    %   Calculate all state machine, ADC, DAC delays in terms of sample delays.
    %   Provide basic validation, as well as estimate of the data rate and
    %   storage required per pulse and per CPI.
    %
    %   Eventually could provide plots to illustrate timing and pulse characteristics.

    properties (Hidden,Constant)
        c = 299792458
        % These properties are not required inputs for producing pl_config.
        outputProperties = {'pl_register_config'}
    end

    properties (Hidden)
        originalInputs % For when parameters are changed during rounding
    end

    properties
        % pl_synthesis_config - Object containing fpga clock rate and sample rate, in Hz
        pl_synthesis_config pl_config.SynthesisConfig
        % pl_register_config - Output object with config parameters for programable logic.
        pl_register_config pl_config.RegisterConfig
        % pulses_per_cpi - Sets the number of contiguous pulses to capture in memeory per CPI trigger.
        pulses_per_cpi {mustBeInteger, mustBeGreaterThan(pulses_per_cpi,0)}
        % pri_sec - Define either prf_hz or pri_sec, not both. 
        %   Must be long enough to allow ADC capture to complete.
        pri_sec(1,1) {mustBeNumeric} 
        pulse_width_sec(1,1) {mustBeNumeric} 
        % range_swath_m - Range swath in meters, 
        %    note that this must be added to the pulse width 
        %    in calculating the time to capture for.
        range_swath_m(1,1) {mustBeNumeric} 
        % scene_start_m - Start of range swath. Must be greater delay than the pulse width.
        scene_start_m(1,1) {mustBeNumeric} 
        chirp_start_frequency_hz(1,1) {mustBeNumeric} 
        chirp_stop_frequency_hz(1,1) {mustBeNumeric} 
    end

    properties (Dependent)
        prf_hz % Calculate PRI in steps from this value.
        chirp_bandwidth_hz
        chirp_center_frequency_hz
    end

    
    methods
        function obj = RadarSetup(varargin)
            % RadarSetup - Construct an instance of this class
            % Constructor accepts name/value pairs for all properties,
            % or can be called without arguments for an empty object.
            if (nargin>0)
                obj.parseConstructorInputForClassProperties(varargin,'exclude',obj.outputProperties);
            end
        end

        function set.prf_hz(obj,prf_hz_)
            obj.pri_sec = 1/prf_hz_;
        end

        function prf_hz_value = get.prf_hz(obj)
           prf_hz_value = 1/obj.pri_sec;
        end
        
        
        function set.chirp_bandwidth_hz(obj,chirp_bandwidth_value)
            SET_chirp_bandwidth_hz(obj,chirp_bandwidth_value);
        end

        function chirp_bandwidth_value = get.chirp_bandwidth_hz(obj)
            chirp_bandwidth_value = GET_chirp_bandwidth_hz(obj);
        end

        function set.chirp_center_frequency_hz(obj,chirp_center_frequency_hz_value)
            SET_chirp_center_frequency_hz(obj,chirp_center_frequency_hz_value);
        end

        function chirp_center_frequency_hz_value = get.chirp_center_frequency_hz(obj)
            chirp_center_frequency_hz_value = GET_chirp_center_frequency_hz(obj);
        end
        
        function valid = isValid(obj)
           valid = obj.isInputValid();
        end

        function valid = isInputValid(obj)
            %isValid Verifies that properties are defined and reasonable
            %   Returns true if properties are all defined, and if
            %   their magnitude and relationship is reasonable.
            %   Otherwise, provides a helpful error message.
            
            % Validate all properties except those excluded.
            assert(obj.allPropertiesAreSingletonAndDefined('exclude',obj.outputProperties),...
                'Not all properties are both defined and singleton.')
            
            % Validate rfsoc_clock object
            assert(isa(obj.pl_synthesis_config,'pl_config.SynthesisConfig'),...
                'pl_synthesis_config must be object of type pl_config.SynthesisConfig');
            assert(obj.pl_synthesis_config.isValid,...
                'pl_synthesis_config object reported invalid settings.');

            % Valid if we get to this line without errors.
            valid = true;
        end
       
        function valid = isPulseTimingValid(obj)
           valid = true;
           warning('No validation logic exists for the plot method')
        end

        function performanceParameters = getRadarPerformance(obj)
            % Calculate Radar performance parameters
            warning('These calculatioins have not been verified')
            % Should validate that required properties have been defined
            % assert(obj.allPropertiesAreSingletonAndDefined('include',...
            % {'pri_sec','pulse_width_sec'}) && obj.allPropertiesAreDefined('include',...
            % {'pl_synthesis_config'}) && obj.pl_synthesis_config.isValid(), ...
            % 'Additional parameters must be defined before calculation is possible.');

            % Intermediate parameters
            recoveryTime = 0;     
            % Pulse width time + range swath time 
            ADC_sample_sec = (obj.pulse_width_sec + obj.range_swath_m / obj.c); 
            samplesPerPulse = ADC_sample_sec  * obj.pl_synthesis_config.sample_rate_hz;
            bitsPerSample = 32; % Complex Samples
            % Generate outputs
            performanceParameters.blindRange = (obj.c * (obj.pri_sec + recoveryTime))/2;
            pulse_data_bits = samplesPerPulse * bitsPerSample;
            cpi_data_bits = pulse_data_bits * obj.pulses_per_cpi;
            cpi_data_bits_per_second = samplesPerPulse * bitsPerSample * obj.prf_hz;                                    
            
            performanceParameters.pulse_data_KB = pulse_data_bits /8/1e3;
            performanceParameters.cpi_data_MB = cpi_data_bits/8/1e6;
            performanceParameters.cpi_data_MB_per_second = cpi_data_bits_per_second /8/1e6;
        end       
        
    end
    
    methods
        plot(obj)
        pl_register_config = getRegisterConfig(obj)
    end

    methods (Hidden)
        SET_chirp_bandwidth_hz(obj,chirp_bandwidth_value)
        chirp_bandwidth_value = GET_chirp_bandwidth_hz(obj)
        SET_chirp_center_frequency_hz(obj,chirp_center_frequency_hz_value)
        chirp_center_frequency_hz_value = GET_chirp_center_frequency_hz(obj)
    end
    
    methods (Static)
        
    end
    
end
