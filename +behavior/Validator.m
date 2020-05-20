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
        
        function discriminatorFcn = getDiscriminator(obj,typeString,propertyCellArray)
            % Returns a "property discriminator" function.
            % includeBoolean = discriminatorFcn(propertyNameString)
            %
            % A Property Discriminator accepts a propertyNameString and
            % returns a boolean on whether the property should be included
            % for whatever purpose is at hand, whether a bulk validation or
            % parsing operation.
            % 
            % Inputs:
            % typeString can be 'all', 'include', or 'exclude'
            % For 'all' a second argument is not needed, and the
            % discriminator will always return true, including all
            % properties.
            % For 'include' and 'exclude' the second argument is required, 
            % and return value will depend on whether the propertyName matches 
            % the names given in the propertyCellAray.  For matches,
            % 'include' will return true, and 'exclude' will return false.                       
            if nargin <= 1
                typeString = 'all';
            end
            
            if strcmp(typeString,'all') 
                discriminatorFcn = @(propertyNameString) true;
            elseif nargin == 3
                if strcmp(typeString,'include')
                    discriminatorFcn = @(propertyNameString) ismember(propertyNameString,propertyCellArray);
                elseif strcmp(typeString,'exclude')
                    discriminatorFcn = @(propertyNameString) ~ismember(propertyNameString,propertyCellArray);
                else
                   error('typeString must be all, include, or exclude') 
                end
            else
                error(['typeString must be all, include, or exclude. ',...
                'include or exclude also require propertyCellArray'])                
            end                        
        end

        function result = allPropertiesAreDefined(obj,typeString,propertyCellArray)
            if (nargin <= 2); typeString = 'all';propertyCellArray = {}; end
            discriminatorFcn = obj.getDiscriminator(typeString,propertyCellArray);
            result = true;
            props = properties(obj);
            for iprop = 1:length(props)
              thisprop = props{iprop};
              if ~discriminatorFcn(thisprop); continue; end
              result = result & obj.isPropertyDefined(thisprop);
            end
        end

        function result = allPropertiesAreSingletonAndDefined(obj,typeString,propertyCellArray)
            if (nargin <= 2); typeString = 'all';propertyCellArray = {}; end
            discriminatorFcn = obj.getDiscriminator(typeString,propertyCellArray);                        
            result = true;
            props = properties(obj);
            for iprop = 1:length(props)
              thisprop = props{iprop};
              if ~discriminatorFcn(thisprop); continue; end
              result = result & obj.isPropertySingleton(thisprop);
            end
        end

        function parseConstructorInputForClassProperties(obj,vararginCellArray,typeString,propertyCellArray)
            % Parse varargin for constructor to find name/value pairs for all class properties.
            % Excludes hidden and constant class properties. Special
            % assignment handling is provided for dependent properties.
            % Support is given for option 'include' or 'exclude' typeString
            % and propertyCellArray to reduce parsed properties with a
            % whitelist or blacklist approach.
            if (nargin <= 3); typeString = 'all';propertyCellArray = {}; end
            discriminatorFcn = obj.getDiscriminator(typeString,propertyCellArray);
            parseObj = inputParser; % Class for handling varargin parsing.
            % Initialize parser targeting class properties.
            props = obj.getNonconstantNonhiddenProperties();
            % Filter properties using the discriminatorFcn to implement
            % whitelist/blacklist behavior.
            props = props(arrayfun(discriminatorFcn,props));
            for iprop = 1:length(props)
                thisprop = props(iprop);
                parseObj.addParameter(thisprop{1},[]);
            end
            parseObj.KeepUnmatched = true;
            % PartialMatchingNeat is neat, but promotes sloppy code. Setting to false
            % forces using exact property names, or throws an error.
            parseObj.PartialMatching = false;
            parseObj.parse(vararginCellArray{:})
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
                   warning([fieldNames{iUnmatched}, ' is not a valid class property for input parsing.']);
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
           mc = metaclass(obj);
           propertyNames = {mc.PropertyList.Name};
           dependentLogicalArray = [mc.PropertyList.Dependent];
           dependentPropertiesCellArray = propertyNames(dependentLogicalArray);
        end

        function independentPropertiesCellArray = getIndependentNonconstantNonhiddenProperties(obj)
           % Return cell array of independent, non-constant, non-hidden properties
           mc = metaclass(obj);
           propertyNames = {mc.PropertyList.Name};
           dependentLogicalArray = [mc.PropertyList.Dependent];
           constantLogicalArray = [mc.PropertyList.Constant];
           hiddenLogicalArray = [mc.PropertyList.Hidden];
           independentPropertiesCellArray ...
               = propertyNames(~dependentLogicalArray & ~constantLogicalArray & ~hiddenLogicalArray);
        end

        function parsedPropertyCell = getNonconstantNonhiddenProperties(obj)
           % Return cell array of independent, non-constant, non-hidden properties
           mc = metaclass(obj);
           propertyNames = {mc.PropertyList.Name};
           % Logical indexing for non-constant non-hidden properties
           parsedPropertyCell = propertyNames( ~[mc.PropertyList.Constant] & ~[mc.PropertyList.Hidden] );
        end

    end
end

