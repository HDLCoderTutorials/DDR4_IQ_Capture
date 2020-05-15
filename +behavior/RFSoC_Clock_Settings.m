classdef RFSoC_Clock_Settings < handle
    %RFSoCSettings Holds fpga and ADC/DAC clock speeds
    %   Data class for fpga clock rate and ADC/DAC sample rate.
    
    properties
        fpga_clock_rate_hz
        sample_rate_hz
    end
    
    methods
        function obj = RFSoC_Clock_Settings(fpga_clock_rate_hz,sample_rate_hz)
            %RFSoC_Clock_Settings Construct an instance of this class
            %   Detailed explanation goes here
            obj.fpga_clock_rate_hz = fpga_clock_rate_hz;
            obj.sample_rate_hz = sample_rate_hz;
        end
        
        function valid = isValid(obj)
            %isValid Verifies that properties are defined and reasonable
            %   Returns true if properties are all defined, and if 
            %   their magnitude and relationship is reasonable.
            %   Otherwise, provides a helpful error message.
                      
            % Assert that all properties are defined
            assert(~isempty(obj.fpga_clock_rate_hz),'fpga_clock_rate_hz must be defined.');
            assert(~isempty(obj.sample_rate_hz),'sample_rate_hz must be defined.');
            
            
            % Assert that all properties are singleton
            assert(numel(obj.fpga_clock_rate_hz) == 1,'fpga_clock_rate_hz must be a single element.');
            assert(numel(obj.sample_rate_hz) == 1,'sample_rate_hz must be a single element.');

            % Valid if we get to this line without errors.
            valid = true;

        end
        
    end
end

