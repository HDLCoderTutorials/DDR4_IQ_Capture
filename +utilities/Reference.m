classdef Reference < handle
    % Reference is a class for passing any variable data by reference.
    % It is a handle subclass, and contains a single property 'value'
    % which can contain any data type.    
    
    properties
        value % can contain any data type
    end
        
    methods
        function obj = Reference(value)
            if (nargin>0)
                obj.value = value;
            end            
        end
    end        
    
end