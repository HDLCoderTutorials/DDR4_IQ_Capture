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

    end
end

