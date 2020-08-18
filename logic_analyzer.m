logic_data = data_q(1:4:length(data_q)-3);
plot_data=zeros(1,length(logic_data));
for k = 1:length(logic_data)
    plot_data(k) = bitand(logic_data(k),1);
end
subplot(6,1,1),plot(plot_data);axis([1 length(logic_data) -.5 1.5]);title('prf-rst');
for k = 1:length(logic_data)
    plot_data(k) = bitand(logic_data(k),2)/2;
end
subplot(6,1,2),plot(plot_data);axis([1 length(logic_data) -.5 1.5]);title('count-reload');
for k = 1:length(logic_data)
    plot_data(k) = bitand(logic_data(k),4)/4;
end
subplot(6,1,3),plot(plot_data);axis([1 length(logic_data) -.5 1.5]);title('Tx-Active');
for k = 1:length(logic_data)
    plot_data(k) = bitand(logic_data(k),8)/8;
end
subplot(6,1,4),plot(plot_data);axis([1 length(logic_data) -.5 1.5]);title('Rx-Start');
for k = 1:length(logic_data)
    plot_data(k) = bitand(logic_data(k),16)/16;
end
subplot(6,1,5),plot(plot_data);axis([1 length(logic_data) -.5 1.5]);title('Rx-Active');
phase_dot_count = data_i(4:4:length(data_i));
subplot(6,1,6),plot(phase_dot_count);axis([1 length(logic_data) -8192 8192]);title('phase-dot-count');
fprintf('\nValues from H/W registers');
fprintf('\nstart_inc %g ', data_i(3));
fprintf('\nLFM_counter_inc %g ', data_i(2));
fprintf('\nend_inc %g \n', data_i(1));