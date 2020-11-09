classdef SimulinkSearch
% Utilities for doing find and replace in Simulink models.
% http://www.ece.northwestern.edu/local-apps/matlabhelp/toolbox/simulink/slref/get_param.html
%
%https://www.mathworks.com/help/simulink/slref/get_param.html#btqy0m7-2
%https://www.mathworks.com/help/matlab/matlab_oop/static-data.html
 methods (Static)
      
    function output = findVars(workspaceVariable)       
        % Given name string of a workspace variable, return a structure
        % which provides a Users cell array of block paths which utilize
        % the given workspace variable.
        output = Simulink.findVars(bdroot, 'Name', workspaceVariable);           
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
    
    
    function output = getBlockPorts(blockPath)
        if not(exist('blockPath','var') == 1)
            blockPath = gcb;            
            disp(['No blockPath argument given, using current selected block:  ',blockPath])
        end        
        simBlockH = get_param(blockPath, 'Handle');
        handlesIn = find_system(simBlockH, 'LookUnderMasks', 'on', 'FollowLinks', 'on', 'SearchDepth', 1, 'BlockType', 'Inport');
        inputs = cellstr(get_param(handlesIn, 'Name'));
        handlesOut = find_system(simBlockH, 'LookUnderMasks', 'on', 'FollowLinks', 'on', 'SearchDepth', 1, 'BlockType', 'Outport');
        outputs = cellstr(get_param(handlesOut, 'Name'));
        output = utilities.v2struct({'fieldnames','inputs','outputs'});
    end
    
    
    function output = getFunctionBlocks(systemPath)
        % Return cell array of paths to all function paths in given systemPath.
        % If no systemPath is given, then the entire model is searched.
        % Also displays links to the found function blocks.
        % https://www.mathworks.com/matlabcentral/answers/464809-how-to-find-matlab-function-blocks-in-a-model
        if not(exist('systemPath','var') == 1)
            systemPath = bdroot; % gcs is selected system, bdroot is top level
            disp(['No systemPath argument given, using current selected block:  ',systemPath])
        end
                
        find_mat_fn = find_system(systemPath,'BlockType','SubSystem'); % finding Subsytem
        mat_fn = {' Demux ';'Ground';' SFunction ';' Terminator '}; % default parameter for Matlab Function Block
        mat_blk_name = 1;
        for i = 1 : length(find_mat_fn)
            get_blocks = get_param(find_mat_fn{i}, 'Blocks');   % Blocks will returns what are the blocks used in subsystem
            check_block =  find(ismember(get_blocks,mat_fn) == 1); % comparing with default parameter
            if check_block
                matlab_fcn_blck{mat_blk_name} = find_mat_fn{i};
                mat_blk_name = mat_blk_name + 1;
            end
        end
        output = matlab_fcn_blck';
        utilities.SimulinkSearch.dispBlockPathLinks(matlab_fcn_blck);
    end

    
    function dispBlockPathLinks(blockPathArray)
        % Given a cell array of block paths, display links which, on click, 
        % bring the block into focus in simulink
        for iBlock = 1:numel(blockPathArray)
            fprintf(['<a href="matlab:hilite_system(''%s'')">',blockPathArray{iBlock},'</a>\n'] , blockPathArray{iBlock} );
        end       
    end
    
    
    function findAndReplace(searchFor,replaceWith)
        % Find block properties which use a local variable and replace
        % them.
        % There are several cases for this tool.
        % 1) Replacing a top level structure or variable. This is easy, and
        % this functionality is built into the Model Explorer.
        % 2) Replacing a second level structure field or object property.
        % This must be split into two steps, and aided by regex parsing.
        % The query must be split at the '.' into the root and the sub
        % fields/properties.  The search is done for the root variable
        % using getFieldStruct, and each field must be checked for whether
        % it has the root variable.  From the list of parameters targeting
        % the correct root, those with the correct sub fields must be
        % identified.  If the subfield substring is found, it can be
        % replaced with the new string.
       
        error('This code is not complete and not safe to use.')
        %{
        model = 'TestModel';
        Objects = find_system(model)
        oldName = 'testParam';
        newName = 'newTestParam';

        for i = 2:length(Objects)
            DialogParams = get_param(Objects{i},'DialogParameters');
            DialogNames = fieldnames(DialogParams);
            for j = 1:length(DialogNames)
                param = get_param(Objects{i},DialogNames{j});
                if (strcmp(param,oldName))
                    set_param(Objects{i},DialogNames{j},newName);
                end
            end
        end 
        %}
    end
       
 end    
end