function SET_chirp_bandwidth_hz(obj,chirp_bandwidth_value)
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
