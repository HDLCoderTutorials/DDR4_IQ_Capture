%--------------------------------------------------------------------------
% HDL Workflow Script
% Generated with MATLAB 9.7 (R2019b) at 00:55:33 on 27/03/2020
% This script was generated using the following parameter values:
%     Filename  : 'D:\MY_DATA\HDL_projects\DDR4_IQ_Capture\hdlworkflow.m'
%     Overwrite : true
%     Comments  : true
%     Headers   : true
%     DUT       : 'ADC_Capture_4x4_IQ_DDR4/HDL_IP'
% To view changes after modifying the workflow, run the following command:
% >> hWC.export('DUT','ADC_Capture_4x4_IQ_DDR4/HDL_IP');
%--------------------------------------------------------------------------

%% Load the Model
load_system('ADC_Capture_4x4_IQ_DDR4');

%% Restore the Model to default HDL parameters
%hdlrestoreparams('ADC_Capture_4x4_IQ_DDR4/HDL_IP');

%% Model HDL Parameters
%% Set Model 'ADC_Capture_4x4_IQ_DDR4' HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4', 'AdaptivePipelining', 'off');
hdlset_param('ADC_Capture_4x4_IQ_DDR4', 'ClockRatePipelining', 'off');
hdlset_param('ADC_Capture_4x4_IQ_DDR4', 'HDLSubsystem', 'ADC_Capture_4x4_IQ_DDR4/HDL_IP');
hdlset_param('ADC_Capture_4x4_IQ_DDR4', 'ReferenceDesign', 'ADC & DAC XM500 Balun Single-Ended 4x4 IQ Mode with DDR4');
hdlset_param('ADC_Capture_4x4_IQ_DDR4', 'ReferenceDesignParameter', {'MW_AXIS_DATA_WIDTH','128','MW_ADC_SAMPLE_RATE','2048','MW_ADC_DECIMATION_MODE','4','MW_ADC_SAMPLES_PER_CLOCK','4','MW_ADC_MIXER_TYPE','Fine','MW_PLL_REF_CLK','245.760','MW_DAC_SAMPLE_RATE','2048','MW_DAC_INTERPOLATION_MODE','4','MW_DAC_SAMPLES_PER_CLOCK','4','MW_DAC_MIXER_TYPE','Fine','MW_ADD_MTS','false','MW_TILE_CLK','128.000','DUTSynthFreqMHz','128.000','MW_ENABLE_WIDE_DATAWIDTH','false','MW_ADD_DDR4','true','MW_ADC_TILE0_ACTIVE','true','MW_ADC_TILE0_CHANNELS','0 1 2 3','MW_ADC_TILE1_ACTIVE','true','MW_ADC_TILE1_CHANNELS','0 1 2 3','MW_ADC_TILE2_ACTIVE','false','MW_ADC_TILE2_CHANNELS','0','MW_ADC_TILE3_ACTIVE','false','MW_ADC_TILE3_CHANNELS','0','MW_DAC_TILE0_ACTIVE','false','MW_DAC_TILE0_CHANNELS','0','MW_DAC_TILE1_ACTIVE','true','MW_DAC_TILE1_CHANNELS','0 1 2 3','HDLVerifierJTAGAXI','off'});
hdlset_param('ADC_Capture_4x4_IQ_DDR4', 'ResetType', 'Synchronous');
hdlset_param('ADC_Capture_4x4_IQ_DDR4', 'SynthesisTool', 'Xilinx Vivado');
hdlset_param('ADC_Capture_4x4_IQ_DDR4', 'SynthesisToolChipFamily', 'Zynq UltraScale+ RFSoC');
hdlset_param('ADC_Capture_4x4_IQ_DDR4', 'SynthesisToolDeviceName', 'xczu28dr-ffvg1517-2-e');
hdlset_param('ADC_Capture_4x4_IQ_DDR4', 'SynthesisToolPackageName', '');
hdlset_param('ADC_Capture_4x4_IQ_DDR4', 'SynthesisToolSpeedValue', '');
hdlset_param('ADC_Capture_4x4_IQ_DDR4', 'TargetDirectory', 'hdl_prj\hdlsrc');
hdlset_param('ADC_Capture_4x4_IQ_DDR4', 'TargetFrequency', 128);
hdlset_param('ADC_Capture_4x4_IQ_DDR4', 'TargetPlatform', 'Xilinx Zynq UltraScale+ RFSoC ZCU111 Evaluation Kit [Rev 1.0]');
hdlset_param('ADC_Capture_4x4_IQ_DDR4', 'Workflow', 'IP Core Generation');

% Set SubSystem HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP', 'AXI4SlaveIDWidth', '12');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP', 'ProcessorFPGASynchronization', 'Free running');

% Set Inport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/axi_mm2s_tdata', 'IOInterface', 'AXI4-Stream DMA Slave');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/axi_mm2s_tdata', 'IOInterfaceMapping', 'Data');

% Set Inport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/axi_mm2s_tvalid', 'IOInterface', 'AXI4-Stream DMA Slave');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/axi_mm2s_tvalid', 'IOInterfaceMapping', 'Valid');

% Set Inport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/axi_s2mm_tready', 'IOInterface', 'AXI4-Stream DMA Master');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/axi_s2mm_tready', 'IOInterfaceMapping', 'Ready (optional)');

% Set Inport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/axim_rd_data', 'IOInterface', 'AXI4 Master DDR4 Read');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/axim_rd_data', 'IOInterfaceMapping', 'Data');

% Set Inport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/axim_rd_s2m', 'IOInterface', 'AXI4 Master DDR4 Read');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/axim_rd_s2m', 'IOInterfaceMapping', 'Read Slave to Master Bus');

% Set Inport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/axim_wr_s2m', 'IOInterface', 'AXI4 Master DDR4 Write');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/axim_wr_s2m', 'IOInterfaceMapping', 'Write Slave to Master Bus');

% Set Inport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile1 ADC Mixer Ch1-I Data', 'IOInterface', 'Tile1 ADC Mixer Ch1-I Data [0:127]');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile1 ADC Mixer Ch1-I Data', 'IOInterfaceMapping', '[0:63]');

% Set Inport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile1 ADC Mixer Ch1-Q Data', 'IOInterface', 'Tile1 ADC Mixer Ch1-Q Data [0:127]');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile1 ADC Mixer Ch1-Q Data', 'IOInterfaceMapping', '[0:63]');

% Set Inport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile1 ADC Mixer Ch1-IQ Valid', 'IOInterface', 'Tile1 ADC Mixer Ch1-IQ Valid');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile1 ADC Mixer Ch1-IQ Valid', 'IOInterfaceMapping', '[0]');

% Set Inport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile1 ADC Mixer Ch2-I Data', 'IOInterface', 'Tile1 ADC Mixer Ch2-I Data [0:127]');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile1 ADC Mixer Ch2-I Data', 'IOInterfaceMapping', '[0:63]');

% Set Inport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile1 ADC Mixer Ch2-Q Data', 'IOInterface', 'Tile1 ADC Mixer Ch2-Q Data [0:127]');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile1 ADC Mixer Ch2-Q Data', 'IOInterfaceMapping', '[0:63]');

% Set Inport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile1 ADC Mixer Ch2-IQ Valid', 'IOInterface', 'Tile1 ADC Mixer Ch2-IQ Valid');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile1 ADC Mixer Ch2-IQ Valid', 'IOInterfaceMapping', '[0]');

% Set Inport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 ADC Mixer Ch1-I Data', 'IOInterface', 'Tile2 ADC Mixer Ch1-I Data [0:127]');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 ADC Mixer Ch1-I Data', 'IOInterfaceMapping', '[0:63]');

% Set Inport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 ADC Mixer Ch1-Q Data', 'IOInterface', 'Tile2 ADC Mixer Ch1-Q Data [0:127]');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 ADC Mixer Ch1-Q Data', 'IOInterfaceMapping', '[0:63]');

% Set Inport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 ADC Mixer Ch1-IQ Valid', 'IOInterface', 'Tile2 ADC Mixer Ch1-IQ Valid');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 ADC Mixer Ch1-IQ Valid', 'IOInterfaceMapping', '[0]');

% Set Inport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 ADC Mixer Ch2-I Data', 'IOInterface', 'Tile2 ADC Mixer Ch2-I Data [0:127]');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 ADC Mixer Ch2-I Data', 'IOInterfaceMapping', '[0:63]');

% Set Inport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 ADC Mixer Ch2-Q Data', 'IOInterface', 'Tile2 ADC Mixer Ch2-Q Data [0:127]');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 ADC Mixer Ch2-Q Data', 'IOInterfaceMapping', '[0:63]');

% Set Inport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 ADC Mixer Ch2-IQ Valid', 'IOInterface', 'Tile2 ADC Mixer Ch2-IQ Valid');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 ADC Mixer Ch2-IQ Valid', 'IOInterfaceMapping', '[0]');

% Set Inport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/ADC_SelectCh', 'IOInterface', 'AXI4');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/ADC_SelectCh', 'IOInterfaceMapping', 'x"11C"');

% Set Inport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/TriggerCapture', 'IOInterface', 'AXI4');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/TriggerCapture', 'IOInterfaceMapping', 'x"100"');

% Set Inport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/DebugCaptureRegister', 'IOInterface', 'AXI4');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/DebugCaptureRegister', 'IOInterfaceMapping', 'x"108"');

% Set Inport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/ADC_CaptureSize', 'IOInterface', 'AXI4');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/ADC_CaptureSize', 'IOInterfaceMapping', 'x"104"');

% Set Inport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/DDR4_ReadLength', 'IOInterface', 'AXI4');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/DDR4_ReadLength', 'IOInterfaceMapping', 'x"10C"');

% Set Inport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/DDR4_ReadAddress', 'IOInterface', 'AXI4');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/DDR4_ReadAddress', 'IOInterfaceMapping', 'x"110"');

% Set Inport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/DDR4_ReadTrigger', 'IOInterface', 'AXI4');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/DDR4_ReadTrigger', 'IOInterfaceMapping', 'x"114"');

% Set Inport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/NCO_Incr', 'IOInterface', 'AXI4');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/NCO_Incr', 'IOInterfaceMapping', 'x"118"');

% Set SubSystem HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/NCO_Transmit', 'AdaptivePipelining', 'on');

% Set MATLABSystem HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/NCO_Transmit/NCO HDL Optimized1', 'LUTRegisterResetType', 'none');

% Set MATLABSystem HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/NCO_Transmit/NCO HDL Optimized2', 'LUTRegisterResetType', 'none');

% Set MATLABSystem HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/NCO_Transmit/NCO HDL Optimized3', 'LUTRegisterResetType', 'none');

% Set MATLABSystem HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/NCO_Transmit/NCO HDL Optimized4', 'LUTRegisterResetType', 'none');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/dut_diagnostics_rd/Subsystem/S2MM_TreadyLowCount', 'IOInterface', 'ADC Tile1: RF Data Converter DAC3 Master');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/dut_diagnostics_rd/Subsystem/S2MM_TreadyLowCount', 'IOInterfaceMapping', 'Valid');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/dut_diagnostics_rd/AXI4_S2MM_TreadyLowCount', 'IOInterface', 'AXI4');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/dut_diagnostics_rd/AXI4_S2MM_TreadyLowCount', 'IOInterfaceMapping', 'x"140"');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/dut_diagnostics_rd/AXI4_AXI4S_TlastCheck', 'IOInterface', 'AXI4');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/dut_diagnostics_rd/AXI4_AXI4S_TlastCheck', 'IOInterfaceMapping', 'x"134"');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/dut_diagnostics_rd/AXI4_FIFOCapture_Overflow', 'IOInterface', 'AXI4');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/dut_diagnostics_rd/AXI4_FIFOCapture_Overflow', 'IOInterfaceMapping', 'x"138"');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/dut_diagnostics_rd/AXI4_FIFODMA_Overflow', 'IOInterface', 'AXI4');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/dut_diagnostics_rd/AXI4_FIFODMA_Overflow', 'IOInterfaceMapping', 'x"13C"');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/dut_diagnostics_rd/AXI4_WriteCompleteCount', 'IOInterface', 'AXI4');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/dut_diagnostics_rd/AXI4_WriteCompleteCount', 'IOInterfaceMapping', 'x"144"');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/dut_diagnostics_rd/AXI4_ReadCompleteCount', 'IOInterface', 'AXI4');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/dut_diagnostics_rd/AXI4_ReadCompleteCount', 'IOInterfaceMapping', 'x"148"');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/dut_diagnostics_rd/AXI4_AccumulatedWrRdyCount', 'IOInterface', 'AXI4');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/dut_diagnostics_rd/AXI4_AccumulatedWrRdyCount', 'IOInterfaceMapping', 'x"14C"');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/dut_diagnostics_rd/AXI4_WastedWriteCycles', 'IOInterface', 'AXI4');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/dut_diagnostics_rd/AXI4_WastedWriteCycles', 'IOInterfaceMapping', 'x"150"');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/dut_diagnostics_rd/AXI4_AckLow_Count', 'IOInterface', 'AXI4');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/dut_diagnostics_rd/AXI4_AckLow_Count', 'IOInterfaceMapping', 'x"154"');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/dut_diagnostics_rd/AXI4_CaptureFIFONum', 'IOInterface', 'AXI4');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/dut_diagnostics_rd/AXI4_CaptureFIFONum', 'IOInterfaceMapping', 'x"158"');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/axi_s2mm_tdata', 'IOInterface', 'AXI4-Stream DMA Master');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/axi_s2mm_tdata', 'IOInterfaceMapping', 'Data');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/axi_s2mm_tvalid', 'IOInterface', 'AXI4-Stream DMA Master');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/axi_s2mm_tvalid', 'IOInterfaceMapping', 'Valid');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/axi_s2mm_tlast', 'IOInterface', 'AXI4-Stream DMA Master');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/axi_s2mm_tlast', 'IOInterfaceMapping', 'TLAST (optional)');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/axi_mm2s_tready', 'IOInterface', 'AXI4-Stream DMA Slave');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/axi_mm2s_tready', 'IOInterfaceMapping', 'Ready (optional)');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/axim_rd_m2s', 'IOInterface', 'AXI4 Master DDR4 Read');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/axim_rd_m2s', 'IOInterfaceMapping', 'Read Master to Slave Bus');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/axim_wr_data', 'IOInterface', 'AXI4 Master DDR4 Write');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/axim_wr_data', 'IOInterfaceMapping', 'Data');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/axim_wr_m2s', 'IOInterface', 'AXI4 Master DDR4 Write');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/axim_wr_m2s', 'IOInterfaceMapping', 'Write Master to Slave Bus');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 DAC Mixer Ch1-I Data', 'IOInterface', 'Tile2 DAC Mixer Ch1-I Data [0:127]');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 DAC Mixer Ch1-I Data', 'IOInterfaceMapping', '[0:63]');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 DAC Mixer Ch1-Q Data', 'IOInterface', 'Tile2 DAC Mixer Ch1-Q Data [0:127]');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 DAC Mixer Ch1-Q Data', 'IOInterfaceMapping', '[0:63]');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 DAC Mixer Ch1-IQ Valid', 'IOInterface', 'Tile2 DAC Mixer Ch1-IQ Valid');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 DAC Mixer Ch1-IQ Valid', 'IOInterfaceMapping', '[0]');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 DAC Mixer Ch2-I Data', 'IOInterface', 'Tile2 DAC Mixer Ch2-I Data [0:127]');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 DAC Mixer Ch2-I Data', 'IOInterfaceMapping', '[0:63]');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 DAC Mixer Ch2-Q Data', 'IOInterface', 'Tile2 DAC Mixer Ch2-Q Data [0:127]');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 DAC Mixer Ch2-Q Data', 'IOInterfaceMapping', '[0:63]');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 DAC Mixer Ch2-IQ Valid', 'IOInterface', 'Tile2 DAC Mixer Ch2-IQ Valid');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 DAC Mixer Ch2-IQ Valid', 'IOInterfaceMapping', '[0]');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 DAC Mixer Ch3-I Data', 'IOInterface', 'Tile2 DAC Mixer Ch3-I Data [0:127]');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 DAC Mixer Ch3-I Data', 'IOInterfaceMapping', '[0:63]');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 DAC Mixer Ch3-Q Data', 'IOInterface', 'Tile2 DAC Mixer Ch3-Q Data [0:127]');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 DAC Mixer Ch3-Q Data', 'IOInterfaceMapping', '[0:63]');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 DAC Mixer Ch3-IQ Valid', 'IOInterface', 'Tile2 DAC Mixer Ch3-IQ Valid');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 DAC Mixer Ch3-IQ Valid', 'IOInterfaceMapping', '[0]');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 DAC Mixer Ch4-I Data', 'IOInterface', 'Tile2 DAC Mixer Ch4-I Data [0:127]');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 DAC Mixer Ch4-I Data', 'IOInterfaceMapping', '[0:63]');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 DAC Mixer Ch4-Q Data', 'IOInterface', 'Tile2 DAC Mixer Ch4-Q Data [0:127]');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 DAC Mixer Ch4-Q Data', 'IOInterfaceMapping', '[0:63]');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 DAC Mixer Ch4-IQ Valid', 'IOInterface', 'Tile2 DAC Mixer Ch4-IQ Valid');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/Tile2 DAC Mixer Ch4-IQ Valid', 'IOInterfaceMapping', '[0]');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/AXI4_S2MM_TreadyLowCount', 'IOInterface', 'AXI4');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/AXI4_S2MM_TreadyLowCount', 'IOInterfaceMapping', 'x"140"');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/AXI4_AXI4S_TlastCheck', 'IOInterface', 'AXI4');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/AXI4_AXI4S_TlastCheck', 'IOInterfaceMapping', 'x"134"');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/AXI4_FIFOCapture_Overflow', 'IOInterface', 'AXI4');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/AXI4_FIFOCapture_Overflow', 'IOInterfaceMapping', 'x"138"');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/AXI4_FIFODMA_Overflow', 'IOInterface', 'AXI4');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/AXI4_FIFODMA_Overflow', 'IOInterfaceMapping', 'x"13C"');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/AXI4_WriteCompleteCount', 'IOInterface', 'AXI4');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/AXI4_WriteCompleteCount', 'IOInterfaceMapping', 'x"144"');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/AXI4_ReadCompleteCount', 'IOInterface', 'AXI4');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/AXI4_ReadCompleteCount', 'IOInterfaceMapping', 'x"148"');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/AXI4_AccumulatedWrRdyCount', 'IOInterface', 'AXI4');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/AXI4_AccumulatedWrRdyCount', 'IOInterfaceMapping', 'x"14C"');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/AXI4_WastedWriteCycles', 'IOInterface', 'AXI4');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/AXI4_WastedWriteCycles', 'IOInterfaceMapping', 'x"150"');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/AXI4_AckLow_Count', 'IOInterface', 'AXI4');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/AXI4_AckLow_Count', 'IOInterfaceMapping', 'x"154"');

% Set Outport HDL parameters
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/AXI4_CaptureFIFONum', 'IOInterface', 'AXI4');
hdlset_param('ADC_Capture_4x4_IQ_DDR4/HDL_IP/AXI4_CaptureFIFONum', 'IOInterfaceMapping', 'x"158"');


%% Workflow Configuration Settings
% Construct the Workflow Configuration Object with default settings
hWC = hdlcoder.WorkflowConfig('SynthesisTool','Xilinx Vivado','TargetWorkflow','IP Core Generation');

% Specify the top level project directory
hWC.ProjectFolder = 'hdl_prj';
hWC.ReferenceDesignToolVersion = '2018.3';
hWC.IgnoreToolVersionMismatch = false;

% Set Workflow tasks to run
hWC.RunTaskGenerateRTLCodeAndIPCore = true;
hWC.RunTaskCreateProject = true;
hWC.RunTaskGenerateSoftwareInterfaceModel = true;
hWC.RunTaskBuildFPGABitstream = true;
hWC.RunTaskProgramTargetDevice = false;

% Set properties related to 'RunTaskGenerateRTLCodeAndIPCore' Task
hWC.IPCoreRepository = '';
hWC.GenerateIPCoreReport = true;

% Set properties related to 'RunTaskCreateProject' Task
hWC.Objective = hdlcoder.Objective.None;
hWC.AdditionalProjectCreationTclFiles = '';
hWC.EnableIPCaching = true;

% Set properties related to 'RunTaskGenerateSoftwareInterfaceModel' Task
hWC.OperatingSystem = 'Linux';

% Set properties related to 'RunTaskBuildFPGABitstream' Task
hWC.RunExternalBuild = true;
hWC.TclFileForSynthesisBuild = hdlcoder.BuildOption.Default;
hWC.CustomBuildTclFile = '';

% Set properties related to 'RunTaskProgramTargetDevice' Task
hWC.ProgrammingMethod = hdlcoder.ProgrammingMethod.Custom;

% Validate the Workflow Configuration Object
hWC.validate;

%% Run the workflow
hdlcoder.runWorkflow('ADC_Capture_4x4_IQ_DDR4/HDL_IP', hWC);
