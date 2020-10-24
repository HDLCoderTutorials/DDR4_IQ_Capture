function chirp_bandwidth_value = GET_chirp_bandwidth_hz(obj)
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
