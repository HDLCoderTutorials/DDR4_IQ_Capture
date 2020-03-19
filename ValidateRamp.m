DataSignal = out.logsout.find('AXIS_Master_Data');
DataValid = out.logsout.find('AXIS_Master_Valid');
s2mm_data = DataSignal.Values.Data;
s2mm_valid = DataValid.Values.Data;

data_extract = double(s2mm_data(s2mm_valid));

plot(data_extract)


get_slope = diff(data_extract);
if any(get_slope ~= 1)
    warning('Ramp is disjointed! Sample dropped or mis-read');
end