function SET_chirp_center_frequency_hz(obj,chirp_center_frequency_hz_value)
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
