function [Y] = CalcY_Sym(obj,x0,u0)
% CalcY_Sym calculates the outputs of a Graph model.

%%% INPUTS
% obj  - System Graph model object
% x0   - state vector
% u0   - input vector

%%% OUTPUTS
% Y - Outputs

% function lookups
OF = sym(ones(length(obj.Graph.Outputs),1));
for i = 1:length(OF) % loop through each output function
    of = obj.Graph.Outputs(i);
    input = [];
    if ~isempty(of)
        for j = 1:length(of.Breakpoints) % build the breakpoint vector for the output function
            if isa(of.Breakpoints{j},'GraphVertex') % if the breakpoint is a state
                [~,idx] = ismember(of.Breakpoints{j},obj.Graph.Vertices);
                input = [input x0(idx)];
            elseif isa(of.Breakpoints{j},'GraphInput') % if the breakpoint is an input
                [~,idx] = ismember(of.Breakpoints{j},obj.Graph.Inputs);
                input = [input u0(idx)];
            else
                error('Breakpoint not Vertex or Input object.')
            end
            
        end
        input = num2cell(input); % reformat the breakpoints into a cell
        func = of.Function;
        % calculate the value of the output function
        if isa(func, 'Type')
            OF(i) = func.calcVal(input{:});
        elseif isa(func, 'symfun')
            OF(i) = func(input{:});
        else
            error('Invalid Output Function Type')
        end
    end
end
Y = OF; % solve for the capacitance of each vertex
end