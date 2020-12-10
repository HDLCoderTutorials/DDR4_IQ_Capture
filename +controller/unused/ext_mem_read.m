classdef ext_mem_read  < Simulink.IntEnumType
%% ext_mem_read
%
% DDR4 external memory read 
    enumeration
      IDLE (0)
      READ_BURST_START (1)
      READ_BURST_REQUEST (2)
      DATA_COUNT (3)
   end
end

