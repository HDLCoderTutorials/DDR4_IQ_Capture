classdef RadarSetup < handle & behavior.Validator
    %RadarSetup Takes desired radar settings and calculates pulse delays.
    %   Calculate all state machine, ADC, DAC delays in terms of sample delays.
    %   Provide basic validation, as well as estimate of the data rate and
    %   storage required per pulse and per CPI.
    %
    %   Eventually could provide plots to illustrate timing and pulse characteristics.

    properties (Hidden,Constant)
        c = 3e8
        % These properties are not required inputs for producing pl_config.
        generatedProperties = {'radar_pl_configuration','blindRange','cpi_data_bits','cpi_data_bits_per_second'}
    end

    properties (Hidden)
        originalInputs % For when parameters are changed during rounding
        is_calculated = false % Have input parameters be rounded and converted to integer sample delays?
        blindRange
        cpi_data_bits
        cpi_data_bits_per_second
    end

    properties
        rfsoc_clock_rates % object containing fpga clock rate and sample rate, in Hz
        pulses_per_cpi % Sets the number of contiguous pulses to capture in memeory per CPI trigger.
        pri_sec % Define either prf_hz or pri_sec, not both. Must be long enough to allow ADC capture to complete.
        pulse_width_sec
        range_swath_m % Range swath in meters, note that this must be added to the pulse width in calculating the number of ADC samples.
        range_delay_m % Start of range swath. Must be greater delay than the pulse width.
        % Output/Generated properties
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

        function valid = isValid(obj)
           valid = obj.isInputValid();
        end

        function valid = isInputValid(obj)
            %isValid Verifies that properties are defined and reasonable
            %   Returns true if properties are all defined, and if
            %   their magnitude and relationship is reasonable.
            %   Otherwise, provides a helpful error message.

            % Validate rfsoc_clock object
            assert(isa(obj.rfsoc_clock_rates,'behavior.RFSoC_Clock_Settings'),'rfsoc_clock_rates must be object of type behavior.RFSoC_Clock_Settings');
            assert(obj.rfsoc_clock_rates.isValid,'rfsoc_clock_rates object reported invalid settings.');

            % Validate Radar programable logic configuration
            assert(isa(obj.radar_pl_configuration,'behavior.Radar_pl_configuration'),'radar_pl_configuration must be object of type behavior.Radar_pl_configuration');
            assert(obj.radar_pl_configuration.isValid,'radar_pl_configuration object reported invalid settings.');


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

        function valid = isPulseTimingValid(obj)
           valid = true;
           warning('No validation logic exists')
        end

        function plot(obj)
            % Provide pulse timing illustration
            assert(obj.isPulseTimingValid(),'Pulse timing is not realizable, cannot plot.')

            normalizedMax = 1000;
            time = 1:normalizedMax;
            tx_pulse = zeros(size(time));
            rx_window = zeros(size(time));

            normalizedTxLength = ceil(normalizedMax*obj.pulse_width_sec/obj.pri_sec);
            % give 1 way range, get 2 way delay
            oneWayRangeMetersToTwoWayDelaySec = @(range_m) 2*range_m/obj.c;
            normalizedRxStart = ceil(oneWayRangeMetersToTwoWayDelaySec(obj.range_delay_m)*normalizedMax/obj.pri_sec);
            normalizedRxStop = floor((oneWayRangeMetersToTwoWayDelaySec( ...
                obj.range_delay_m + obj.range_swath_m)...
                + obj.pulse_width_sec)*normalizedMax/obj.pri_sec);

            tx_pulse(1:normalizedTxLength) = 1;
            rx_window(normalizedRxStart:normalizedRxStop) = 1;
            plot(time,tx_pulse,time,rx_window)
            ylim([0 1.5]);
            title('Pulse Tx and Rx Timing')
        end

    end
end
