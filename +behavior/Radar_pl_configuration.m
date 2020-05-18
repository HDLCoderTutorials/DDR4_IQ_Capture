classdef Radar_pl_configuration < handle
    %Radar_pl_config radar parameters for programable logic.
    %   All parameters required at runtime by the fpga/
    %   programable logic of the radar. Most parameters are in 
    %   integers, with time in fpga clock cycles.
    
    properties
        pulse_width_cycles % DAC/Tx width
        tx_delay_cycles % time between tx and rx
        adc_rx_samples % rx samples, range swath + pulse width
        
        
    end
        
    
    methods
        function obj = Radar_pl_configuration(pulse_width_cycles)
            %Radar_pl_configuration Construct an instance of this class
            %   
            
        end
        
        function valid = isValid(obj)
            %isValid validate before using on FPGA radar
            %   Detailed explanation goes here
            
            % Assert that all properties are defined
                        
            if isempty(obj.pulse_width_cycles)
                valid=false; display('pulse_width_cycles must be defined.');
            end
            assert(~isempty(obj.sample_rate_hz),'sample_rate_hz must be defined.');
            
            
            % Assert that all properties are singleton
            assert(numel(obj.fpga_clock_rate_hz) == 1,'fpga_clock_rate_hz must be a single element.');
            assert(numel(obj.sample_rate_hz) == 1,'sample_rate_hz must be a single element.');
        end
        
        function defined = isPropertyDefined(obj,propertyName)
            defined = true; % Default
            propertyName = convertStringsToChars(propertyName);
            props = properties(obj);
            if ismember(propertyName,props)
                propertyValue = obj.(propertyName);
                if isempty(propertyValue)
                    defined = false;
                    warning([propertyName,' is not defined.']);
                end
            else % property not found
                defined = false;
                warning([propertyName,' is not a member of this class.']);
            end
        end
        
        % TODO: Fix bugs and cleanup this nest of if statements
        function singleton = isPropertySingleton(obj,propertyName)
            singleton = true; % Default
            propertyName = convertStringsToChars(propertyName);
            props = properties(obj);
            if ismember(propertyName,props)
                propertyValue = obj.(propertyName);
                if ~isPropertyDefined(propetyName)
                    singleton = false;
                elseif ~(numel(obj.(propertyName)) == 1)
                    singleton = false;
                    warning([propertyName,' is not singleton.']);
                    
                end
            else % property not found
                singleton = false;
                warning([propertyName,' is not a member of this class.']);
            end
        end        
        
        
        function defined = allPropertiesAreDefined(obj) 
            defined = true;
            props = properties(obj);            
            for iprop = 1:length(props)
              thisprop = props{iprop};
              %thisprop_value = obj.(thisprop);
              defined = defined & obj.isPropertyDefined(thisprop);              
            end
        end        
        
        function singleton = allPropertiesAreSingleton(obj) 
            singleton = true;
            props = properties(obj);            
            for iprop = 1:length(props)
              thisprop = props{iprop};
              thisprop_value = obj.(thisprop);
              if ~(numel(obj.sample_rate_hz) == 1)
                 singleton = false;
                 warning([thisprop,' must be defined.']);
              end              
            end
        end
        
        
    end
end

