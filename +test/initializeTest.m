%% Main function to generate tests
function tests = initializeTest()
    tests = functiontests(localfunctions);
end
% https://www.mathworks.com/help/matlab/matlab_prog/write-function-based-unit-tests-.html
% https://www.mathworks.com/help/matlab/matlab_prog/types-of-qualifications.html
% https://www.mathworks.com/help/matlab/matlab_prog/write-test-using-setup-and-teardown-functions.html
% results = runtests('test.initializeTest')

%% Test Functions


function testInitOne(testCase)
% Test specific code

synthesisConfig = pl_config.SynthesisConfig('fpga_clock_rate_hz',128e6,...
    'sample_rate_hz',512e6,'N_accumulator',14)
    synthesisConfig.isValid();

radarSetup = pl_config.RadarSetup('pulses_per_cpi',1024,'pulse_width_sec',1e-6,'prf_hz',20e3,...
    'range_delay_m',200,'range_swath_m',1000,...
    'chirp_start_frequency_hz',-100e6,'chirp_stop_frequency_hz',100e6,...
    'pl_synthesis_config',synthesisConfig)
    
radarSetup.isValid()
radarSetup.getRadarPerformance()
radarSetup.plot()
% This pl_config is the output for programming the fpga programable logic.
pl_register_config = radarSetup.getRadarPlConfig() 
pl_register_config.isValid()
    
    
    
    
end

function testPlaceholder(testCase)
    % Test specific code
end

%% Optional file fixtures  
function setupOnce(testCase)  % do not change function name
    % set a new path, for example
    testCase.TestData.tolerance = 1e-10;    
    % Run original initialization script
    % It would be good to create a static copy of this for reference.
    init_ADC_Capture_4x4_IQ_DDR4;
    
    for iVar = 1:numel(requiredVars)
        variableName = requiredVars{iVar};
        assert(exist(variableName,'var'), ['Required variable ', ...
            variableName,' does not exist.'])
            outputParameters.(variableName) = eval(variableName)
    end            
        testCase.TestData.requiredVars = requiredVars;
        testCase.TestData.outputParameters = outputParameters;           
end

function teardownOnce(testCase)  % do not change function name
    % change back to original path, for example
end

%% Optional fresh fixtures  
function setup(testCase)  % do not change function name
    % open a figure, for example
end

function teardown(testCase)  % do not change function name
    % close figure, for example
end
