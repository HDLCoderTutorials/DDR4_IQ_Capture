function plot(obj)
    % Provide pulse timing illustration
    %
    % I think this implementation is a bit ineficcient and silly

    assert(obj.isPulseTimingValid(),'Pulse timing is not realizable, cannot plot.')
    clf

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
    
    
    % Example Annotations, figure normalized coordinates
    % https://www.mathworks.com/help/releases/R2019b/matlab/ref/annotation.html
    annotation('textarrow',[.4,.7],[.85, .85],'String','Example Arrow')
    annotation('textarrow',[.1,.9],[.8, .8],'String','PRI')
    annotation('textarrow',[.1,.3],[.75, .75],'String','pulse')
    anArrow = annotation('arrow') ;
    
    % Annotate in data coordinate units
    % https://www.mathworks.com/matlabcentral/answers/346297-how-to-draw-an-arrow-using-non-normalized-coordinates        
    anArrow.Parent = gca;  % or any other existing axes or figure
    x_start = normalizedRxStart; delta_x = normalizedRxStop - normalizedRxStart;  
    y_start = 1.1; delta_y = 0;
    anArrow.Position = [x_start, y_start, delta_x, delta_y] ;
    
    % Or, convert from data units to figure normalized units
    % https://www.mathworks.com/matlabcentral/fileexchange/10656-data-space-to-figure-units-conversion
    % https://www.mathworks.com/matlabcentral/fileexchange/9615-plotboxpos
    
    
end