classdef RadarSetup < handle & pl_config.Validator
    %RadarSetup Takes desired radar settings and calculates pulse delays.
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
        pl_synthesis_config % object containing fpga clock rate and sample rate, in Hz
        pulses_per_cpi % Sets the number of contiguous pulses to capture in memeory per CPI trigger.
        pri_sec % Define either prf_hz or pri_sec, not both. Must be long enough to allow ADC capture to complete.
        pulse_width_sec
        range_swath_m % Range swath in meters, note that this must be added to the pulse width in calculating the number of ADC samples.
        range_delay_m % Start of range swath. Must be greater delay than the pulse width.
        chirp_start_frequency_hz
        chirp_stop_frequency_hz
        % Output/Generated properties
        pl_register_config % Object with config parameters for programable logic.
    end

    properties (Dependent)
        prf_hz % Calculate PRI in steps from this value.
        chirp_bandwidth_hz
        chirp_center_frequency_hz
    end

    
    methods
        function obj = RadarSetup(varargin)
            %SynthesisConfig Construct an instance of this class
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
            if (obj.isPropertySingleton('chirp_start_frequency_hz',false) && ...
                    obj.isPropertySingleton('chirp_stop_frequency_hz',false))
                % Both Defined
               center_freq_hz = obj.chirp_center_frequency_hz; 
                obj.chirp_start_frequency_hz = center_freq_hz - chirp_bandwidth_value/2;
                obj.chirp_stop_frequency_hz  = center_freq_hz + chirp_bandwidth_value/2;
            elseif (~obj.isPropertySingleton('chirp_start_frequency_hz',false) && ...
                    ~obj.isPropertySingleton('chirp_stop_frequency_hz',false))
                % Neither Defined
                obj.chirp_start_frequency_hz = -chirp_bandwidth_value/2;
                obj.chirp_stop_frequency_hz  = chirp_bandwidth_value/2;
            else % One defined, either start or stop frequency
                if obj.isPropertySingleton('chirp_start_frequency_hz',false) 
                    % Only start frequency is defined, calculate the stop
                    obj.chirp_stop_frequency_hz  = obj.chirp_start_frequency_hz ...
                        + chirp_bandwidth_value;
                elseif obj.isPropertySingleton('chirp_stop_frequency_hz',false)
                    % Only the stop frequency is defined, calculate the start
                    obj.chirp_start_frequency_hz = obj.chirp_stop_frequency_hz ...
                        - chirp_bandwidth_value;
                else
                    error('Error should not be possible, start or stop frequency should be defined here.')
                end
            end
        end

        function chirp_bandwidth_value = get.chirp_bandwidth_hz(obj)
            if (obj.isPropertySingleton('chirp_start_frequency_hz',false) && ...
                    obj.isPropertySingleton('chirp_stop_frequency_hz',false))
                % Both Defined
                chirp_bandwidth_value = (obj.chirp_stop_frequency_hz - obj.chirp_start_frequency_hz);
            elseif (~obj.isPropertySingleton('chirp_start_frequency_hz',false) && ...
                    ~obj.isPropertySingleton('chirp_stop_frequency_hz',false))
                % Neither Defined
                chirp_bandwidth_value = [];
            else % One defined, either start or stop frequency
                chirp_bandwidth_value = [];
            end
        end

        function set.chirp_center_frequency_hz(obj,chirp_center_frequency_hz_value)
            if (obj.isPropertySingleton('chirp_start_frequency_hz',false) && ...
                    obj.isPropertySingleton('chirp_stop_frequency_hz',false))
                % Both Defined
                chirp_bandwidth_hz_value = obj.chirp_bandwidth_hz;
                obj.chirp_start_frequency_hz = chirp_center_frequency_hz_value ...
                    - chirp_bandwidth_hz_value/2;
                obj.chirp_stop_frequency_hz  = chirp_center_frequency_hz_value ...
                    + chirp_bandwidth_hz_value/2;
            elseif (~obj.isPropertySingleton('chirp_start_frequency_hz',false) && ...
                    ~obj.isPropertySingleton('chirp_stop_frequency_hz',false))
                % Neither Defined
                chirp_bandwidth_value = 100e3; % Arbitrary default value.
                obj.chirp_start_frequency_hz = chirp_center_frequency_hz_value ...
                    - chirp_bandwidth_value/2;
                obj.chirp_stop_frequency_hz  = chirp_center_frequency_hz_value ...
                    + chirp_bandwidth_value/2;
            else % One defined, either start or stop frequency
                if obj.isPropertySingleton('chirp_start_frequency_hz',false) 
                    % Only start frequency is defined, calculate the stop
                    chirp_bandwidth_value = 2*( chirp_center_frequency_hz_value ...
                        - obj.chirp_start_frequency_hz);
                    obj.chirp_stop_frequency_hz  = obj.chirp_start_frequency_hz ...
                        + chirp_bandwidth_value;
                elseif obj.isPropertySingleton('chirp_stop_frequency_hz',false)
                    % Only the stop frequency is defined, calculate the start
                    chirp_bandwidth_value = 2*( chirp_center_frequency_hz_value ...
                        - obj.chirp_start_frequency_hz);
                    obj.chirp_start_frequency_hz = obj.chirp_stop_frequency_hz ...
                        - chirp_bandwidth_value;
                else
                    error('Error should not be possible, start or stop frequency should be defined here.')
                end
            end
        end

        function chirp_center_frequency_hz_value = get.chirp_center_frequency_hz(obj)
            if (obj.isPropertySingleton('chirp_start_frequency_hz',false) && ...
                    obj.isPropertySingleton('chirp_stop_frequency_hz',false))
                % Both Defined
                chirp_center_frequency_hz_value = (obj.chirp_stop_frequency_hz + obj.chirp_start_frequency_hz)/2;
            elseif (~obj.isPropertySingleton('chirp_start_frequency_hz',false) && ...
                    ~obj.isPropertySingleton('chirp_stop_frequency_hz',false))
                % Neither Defined
                chirp_bandwidth_value = [];
            else % One defined, either start or stop frequency
                chirp_bandwidth_value = [];
            end
        end
        
        function valid = isValid(obj)
           valid = obj.isInputValid();
        end

        function valid = isInputValid(obj)
            %isValid Verifies that properties are defined and reasonable
            %   Returns true if properties are all defined, and if
            %   their magnitude and relationship is reasonable.
            %   Otherwise, provides a helpful error message.
            
            % Problem: Assert throws an error and halts execution.  It
            % would be more helpful to throw an error after displaying
            % warnings for ALL issues which fail validation.

            % Validate all properties except those excluded.
            assert(obj.allPropertiesAreSingletonAndDefined('exclude',obj.outputProperties),'Not all properties are both defined and singleton.')
            
            % Validate rfsoc_clock object
            assert(isa(obj.pl_synthesis_config,'pl_config.SynthesisConfig'),'pl_synthesis_config must be object of type pl_config.SynthesisConfig');
            assert(obj.pl_synthesis_config.isValid,'pl_synthesis_config object reported invalid settings.');

            % Validate Radar programable logic configuration object
            % (This is for output, so it doesn't need validation)
%             assert(isa(obj.radar_pl_configuration,'pl_config.Radar_pl_configuration'),'radar_pl_configuration must be object of type pl_config.Radar_pl_configuration');
%             assert(obj.radar_pl_configuration.isValid,'radar_pl_configuration object reported invalid settings.');



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
%             assert(obj.allPropertiesAreSingletonAndDefined('include',{'pri_sec','pulse_width_sec'}) && ...
%                 obj.allPropertiesAreDefined('include',{'pl_synthesis_config'}) && obj.pl_synthesis_config.isValid(), ...
%             'Additional parameters must be defined before calculation is possible.');
            % Intermediate parameters
            recoveryTime = 0;      
            ADC_sample_sec = (obj.pulse_width_sec + obj.range_swath_m / obj.c); % Pulse width time + range swath time
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
        
        function pl_register_config = getRadarPlConfig(obj)
           % Calculate Programable Logic radar configuration parameters
           % from class properties. Validate integrity of inputs and
           % outputs before and after calculations.
           % Round parameters as needed to fit limitations 
           % of Programable Logic.
           warning('getRadarPlConfig calculations are NOT complete. Proof of concept only.')
           
           assert(obj.isInputValid(),'Input parameters are not sufficient ')
           
           samplesPerClockCycles = obj.pl_synthesis_config.sample_rate_hz / obj.pl_synthesis_config.fpga_clock_rate_hz;           
           pl_register_config = pl_config.RegisterConfig(...
               'pulse_width_cycles',100,'tx_delay_cycles',100,...
                'adc_rx_samples',1000,'after_rx_pri_delay_cycles',200, ...
                'samples_per_clock_cycle',obj.pl_synthesis_config.samples_per_clock_cycle);
            
            N = obj.pl_synthesis_config.N_accumulator;       
            pl_register_config.start_inc_steps = ...
                round (((obj.chirp_start_frequency_hz*2^N)...
                /obj.pl_synthesis_config.fpga_clock_rate_hz)/...
                obj.pl_synthesis_config.samples_per_clock_cycle); 
            pl_register_config.end_inc_steps  = ...
                round (((obj.chirp_stop_frequency_hz*2^N)...
                /obj.pl_synthesis_config.fpga_clock_rate_hz)/...
                obj.pl_synthesis_config.samples_per_clock_cycle); 
            
            %Pulse width and frequencies must be chosen so that LFM_counter_inc is an
            %integer, will use floor here which changes end freq to slightly less in
            %some cases
            LFM_counter_inc = floor((pl_register_config.end_inc_steps-pl_register_config.start_inc_steps)/...
                pl_register_config.pulse_width_cycles);
            % adjust end_inc for counter limitation
            end_inc = pl_register_config.start_inc_steps + LFM_counter_inc*pl_register_config.pulse_width_cycles;
            pl_register_config.end_inc_steps = end_inc/(2^(N-1)-1)*256;
            fprintf('Calculated chirp frequencies based on integer counter limitation:\n');
            fprintf('%.0fMHz %.0fMHz\n', obj.chirp_start_frequency_hz/1e6, ...
                pl_register_config.end_inc_steps);
            
            assert(pl_register_config.isValid(),'Radar Programable Logic Configuration object is not valid')           
            obj.pl_register_config = pl_register_config;
        end
        
    end
    
    methods
        plot(obj)
    end
    
    methods (Static)
        
    end
    
end
