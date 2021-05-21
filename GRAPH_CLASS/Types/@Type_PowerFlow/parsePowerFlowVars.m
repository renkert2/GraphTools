function [type, params, num_inputs] = parsePowerFlowVars(type)
% Returns symbolic variables, params argument structure, and number of inputs incident on a type

[type,num_inputs] = countInputVars(type);
params = calcVars(num_inputs);

    function [type, num_inputs] = countInputVars(type)
        % Converts type to a string and uses regular expression to count the number of inputs required
        
        if isa(type, 'sym') || isa(type, 'char')
            type = string(type);
        elseif ~isa(type,'string')
            error("PowerFlow Type must be of type string, char, or sym")
        end
        
        patt_single_input = 'u(?!\d)'; % Finds 'u' occurences in expression
        type = regexprep(type, patt_single_input, "u1"); % Replace occurences of 'u' with 'u1'
        
        patt_list = '(?<=u)\d+';
        input_list = double(regexp(type, patt_list, 'match')); % Finds 'u[12...N]' occurences in expression
        input_list_flag = ~isempty(input_list); % Flag indicating if any inputs were found
        
        if input_list_flag
            num_inputs = max(input_list);
        else
            num_inputs = 0;
        end
    end

    function [params] = calcVars(num_inputs)
        state_vars = [sym('xt'), sym('xh')];
        if num_inputs >= 1
            input_vars =sym('u', [1, max(num_inputs,2)]);
            params = {state_vars(1), state_vars(2), input_vars};
        elseif num_inputs == 0
            params = {state_vars(1), state_vars(2)};
        end
    end
end