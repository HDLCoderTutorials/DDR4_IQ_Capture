classdef (Abstract) Validator < handle
    %Validator Abstract class with methods to aid validation
    %

    methods

        function defined = isPropertyDefined(obj,propertyName)
            defined = true; % Default
            propertyName = convertStringsToChars(propertyName);
            props = properties(obj);
            if ismember(propertyName,props)
                propertyValue = obj.(propertyName);
                if isempty(propertyValue)
                    defined = false;
                    warning([propertyName,' is not defined.']);
                end
            else % property not found
                defined = false;
                warning([propertyName,' is not a member of this class.']);
            end
        end

        % All checks are negations, failure modes.
        % When the condition is true, the rest of the conditions are not
        % checked.
        function singleton = isPropertySingleton(obj,propertyName)
            singleton = true; % Default
            propertyName = convertStringsToChars(propertyName);
            props = properties(obj);
            if ~ismember(propertyName,props) % property not found
                singleton = false;
                warning([propertyName,' is not a member of this class.']);
            else
                % propertyValue = obj.(propertyName);
                if ~obj.isPropertyDefined(propertyName) % property not defined
                    singleton = false;
                elseif ~(numel(obj.(propertyName)) == 1) % property not singleton
                    singleton = false;
                    warning([propertyName,' is not singleton.']);
                end
            end
        end

        function defined = allPropertiesAreDefined(obj)
            defined = true;
            props = properties(obj);
            for iprop = 1:length(props)
              thisprop = props{iprop};
              %thisprop_value = obj.(thisprop);
              defined = defined & obj.isPropertyDefined(thisprop);
            end
        end

        function singleton = allPropertiesAreSingletonAndDefined(obj)
            singleton = true;
            props = properties(obj);
            for iprop = 1:length(props)
              thisprop = props{iprop};
              %thisprop_value = obj.(thisprop);
              singleton = singleton & obj.isPropertySingleton(thisprop);
            end
        end
        
        function valid = isValid(obj)
            % isValid validate before use
            valid = obj.allPropertiesAreSingletonAndDefined();
        end

        function parseConstructorInputForClassProperties(obj,varargin)
            % Parse varargin for constructor to find name/value pairs for all class properties.
            parseObj = inputParser; % Class for handling varargin parsing.
            % Initialize parser targeting all class properties
            props = properties(obj);
%             props = obj.getIndependentNonconstantNonhiddenProperties();
            for iprop = 1:length(props)
                thisprop = props(iprop);
                parseObj.addParameter(thisprop{1},[]);
            end
            parseObj.KeepUnmatched = true;
            parseObj.PartialMatching = false; % Neat feature, but promotes sloppy code.
            parseObj.parse(varargin{:})
            % Assign object properties with values.
            for iprop = 1:length(props)
               thisprop = props{iprop};
               obj.(thisprop) = parseObj.Results.(thisprop);
            end
            % Check for unmatched field names
            fieldNames = fieldnames(parseObj.Unmatched);
            if numel(fieldNames) > 0
                for iUnmatched = 1:length(fieldNames)
                   warning([fieldNames{iUnmatched}, ' is not a valid class property.']);
                end
                % Show Valid class properties
                disp('**** Valid Class Properties ****')
                for iprop = 1:length(props)
                   thisprop = props{iprop};
                   disp(thisprop);
                end
                error('Remove input parameters which do not match class properties.')
            end
        end

        function dependentPropertiesCellArray = getDependentProperties(obj)
            % Return cell array of dependent properties
           myClass = class(obj)
           mc = [];
           eval(['mc=?',myClass,';'])
           propertyNames = {mc.PropertyList.Name};
           dependentLogicalArray = [mc.PropertyList.Dependent];
           dependentPropertiesCellArray = propertyNames(dependentLogicalArray);            
        end        
        
        function independentPropertiesCellArray = getIndependentNonconstantNonhiddenProperties(obj)
            % Return cell array of independent, non-constant, non-hidden properties
           myClass = class(obj)
           mc = [];
           eval(['mc=?',myClass,';'])
           propertyNames = {mc.PropertyList.Name};
           dependentLogicalArray = [mc.PropertyList.Dependent];
           constantLogicalArray = [mc.PropertyList.Constant];
           hiddenLogicalArray = [mc.PropertyList.Hidden];
           independentPropertiesCellArray ...
               = propertyNames(~dependentLogicalArray & ~constantLogicalArray & ~hiddenLogicalArray);            
        end

    end
end

