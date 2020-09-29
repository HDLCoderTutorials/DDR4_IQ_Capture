%% Main function to generate tests
function tests = exampleTest
tests = functiontests(localfunctions);
end
% https://www.mathworks.com/help/matlab/matlab_prog/write-function-based-unit-tests-.html
% https://www.mathworks.com/help/matlab/matlab_prog/types-of-qualifications.html
% https://www.mathworks.com/help/matlab/matlab_prog/write-test-using-setup-and-teardown-functions.html
% results = runtests('test.initializeTest')

%% Test Functions
function testFunctionOne(testCase)
% Test specific code
end

function FunctionTwotest(testCase)
% Test specific code
end

%% Optional file fixtures  
function setupOnce(testCase)  % do not change function name
% set a new path, for example
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