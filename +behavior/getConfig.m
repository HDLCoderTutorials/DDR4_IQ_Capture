classdef getConfig
    %GETCONFIG Static class 
    
    methods (Static)
        
        
        function [plConfig radarSetup] = simulation()
            %SIMULATION Configuration for running in simulation
            display('Simulation')
            
        end
        
        function [plConfig radarSetup] = realtime()
            %REALTIME Configuration for running in realtime
            display('Realtime')
            
        end
    end
end

