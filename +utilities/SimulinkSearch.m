classdef SimulinkSearch
% Utilities for doing find and replace in Simulink models.
% http://www.ece.northwestern.edu/local-apps/matlabhelp/toolbox/simulink/slref/get_param.html
%
%https://www.mathworks.com/help/simulink/slref/get_param.html#btqy0m7-2
%https://www.mathworks.com/help/matlab/matlab_oop/static-data.html
 methods (Static)
      
    function output = find(query)       
        output = Simulink.findVars(bdroot, 'Name', query);           
    end
       
    function output = getDialogParameters(blockPath)
        output = get_param(blockPath,'DialogParameters');
    end
    
    function output = getObjectParameters(blockPath)
        output = get_param(blockPath,'ObjectParameters');
    end
    
    function output = getValue(blockPath,parameterName)
        output = get_param(blockPath,parameterName);
    end
    
    function paramStruct = getFieldStruct(blockPath)
        paramStruct = get_param(blockPath,'DialogParameters');
        fields = fieldnames(paramStruct);
        for iField = 1:numel(fields)
            valueString = get_param(blockPath,fields{iField});
%             paramStruct.(fields{iField}).value = valueString; % Preserve metadata
            paramStruct.(fields{iField}) = valueString; % remove metadata            
        end
    end
       
 end    
end