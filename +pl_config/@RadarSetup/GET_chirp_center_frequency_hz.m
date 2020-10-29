function chirp_center_frequency_hz_value = GET_chirp_center_frequency_hz(obj)
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
