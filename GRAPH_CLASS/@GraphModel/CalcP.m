function P = CalcP(obj, x_full, u, params)
% calculate the values of the power flows when simulating the
% graph

param_lengths = [numel(obj.SymVars.x_full), obj.Nu, obj.SymParams.N];

if isempty(obj.SymParams)
    vars = {x_full,u};
else
    if nargin == 3
        vars = {x_full,u,obj.SymParams.Vals};
    elseif nargin == 4
        vars = {x_full,u,params};
    end
end

% through an error if the user did not pass enough (or too
% much) information to the simulate function
for i = 1:numel(vars)
    assert(size(vars{i},1) >= param_lengths(i), "Argument %d requires %d entries", i, param_lengths(i));
end

P = obj.CalcX(obj.CalcP_func, vars);
end