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

        function parseConstructorInputForClassProperties(obj,varargin)
            % Parse varargin for constructor to find name/value pairs for all class properties.
            % Excludes hidden and constant class properties. Special
            % assignment handling is provided for dependent properties.
            parseObj = inputParser; % Class for handling varargin parsing.
            % Initialize parser targeting class properties.
            props = obj.getNonconstantNonhiddenProperties();
            for iprop = 1:length(props)
                thisprop = props(iprop);
                parseObj.addParameter(thisprop{1},[]);
            end
            parseObj.KeepUnmatched = true;
            % PartialMatchingNeat is neat, but promotes sloppy code. Setting to false
            % forces using exact property names, or throws an error.
            parseObj.PartialMatching = false;
            parseObj.parse(varargin{:})
            % Assign object properties with parsed values.
            dependentProperties = obj.getDependentProperties();
            for iprop = 1:length(props)
               thisprop = props{iprop};
               parsedValue = parseObj.Results.(thisprop);
               % Only make the assignment IF thisprop is notDependent OR
               % parsedValue is not empty [] (not default)
               % This prevents calculation errors in set methods, and blank
               % dependent properties overwriting their independent
               % counterpart.
               if ~ismember(thisprop,dependentProperties) || ~isempty(parsedValue)
                obj.(thisprop) = parsedValue;
               end
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

        function metaPropertyObject = getMetaPropertyObject(thisObject)
           % Return meta.property object for class of specified object.
           % Useful for determining which class properties are hidden,
           % constant, dependent, etc. to support handling them
           % differently.
           myClass = class(thisObject);
           metaPropertyObject = [];
           eval(['metaPropertyObject=?',myClass,';']) % get meta.property object
        end

        function dependentPropertiesCellArray = getDependentProperties(obj)
           % Return cell array of dependent properties
           mc = obj.getMetaPropertyObject;
           propertyNames = {mc.PropertyList.Name};
           dependentLogicalArray = [mc.PropertyList.Dependent];
           dependentPropertiesCellArray = propertyNames(dependentLogicalArray);
        end

        function independentPropertiesCellArray = getIndependentNonconstantNonhiddenProperties(obj)
           % Return cell array of independent, non-constant, non-hidden properties
           mc = obj.getMetaPropertyObject;
           propertyNames = {mc.PropertyList.Name};
           dependentLogicalArray = [mc.PropertyList.Dependent];
           constantLogicalArray = [mc.PropertyList.Constant];
           hiddenLogicalArray = [mc.PropertyList.Hidden];
           independentPropertiesCellArray ...
               = propertyNames(~dependentLogicalArray & ~constantLogicalArray & ~hiddenLogicalArray);
        end

        function parsedPropertyCell = getNonconstantNonhiddenProperties(obj)
           % Return cell array of independent, non-constant, non-hidden properties
           mc = obj.getMetaPropertyObject;
           propertyNames = {mc.PropertyList.Name};
           % Logical indexing for non-constant non-hidden properties
           parsedPropertyCell = propertyNames( ~[mc.PropertyList.Constant] & ~[mc.PropertyList.Hidden] );
        end

    end
end

