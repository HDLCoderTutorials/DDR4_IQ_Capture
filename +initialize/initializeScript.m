input=struct('ConverterSamplingRate',2048e6,'DDC_DUC_factor',4,'VectorSamplingFactor',4,'CPILength'...
, 128,'PRF' , 10000,'PulseWidth' , 5e-6,'f0' , 0,'f1' , 140e6,'N' , 14)

output = initialize.initializeFunction(input)
