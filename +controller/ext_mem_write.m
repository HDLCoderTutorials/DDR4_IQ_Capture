classdef ext_mem_write  < Simulink.IntEnumType
% ext_mem_write
%
% enumeration for DDR4 write
    enumeration
      IDLE (0)
      WRITE_BURST_START (1)
      DATA_COUNT (2)
      ACK_WAIT (3)
   end
end

