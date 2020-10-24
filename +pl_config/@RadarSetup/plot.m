function plot(obj)
    % Provide pulse timing illustration
    %
    % I think this implementation is a bit ineficcient and silly

    assert(obj.isPulseTimingValid(),'Pulse timing is not realizable, cannot plot.')

    normalizedMax = 1000;
    time = 1:normalizedMax;
    tx_pulse = zeros(size(time));
    rx_window = zeros(size(time));

    normalizedTxLength = ceil(normalizedMax*obj.pulse_width_sec/obj.pri_sec);
    % give 1 way range, get 2 way delay
    oneWayRangeMetersToTwoWayDelaySec = @(range_m) 2*range_m/obj.c;
    normalizedRxStart = ceil(oneWayRangeMetersToTwoWayDelaySec(obj.scene_start_m)*normalizedMax/obj.pri_sec);
    normalizedRxStop = floor((oneWayRangeMetersToTwoWayDelaySec( ...
        obj.scene_start_m + obj.range_swath_m)...
        + obj.pulse_width_sec)*normalizedMax/obj.pri_sec);

    tx_pulse(1:normalizedTxLength) = 1;
    rx_window(normalizedRxStart:normalizedRxStop) = 1;
    plot(time,tx_pulse,time,rx_window)
    ylim([0 1.5]);
    title('Pulse Tx and Rx Timing')
end