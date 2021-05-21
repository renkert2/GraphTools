function G = CalcG(obj,x,u,d,params)
param_lengths = [obj.Nx, obj.Nu, obj.Nd, obj.SymParams.N];

if isempty(obj.SymParams)
    vars = {x,u,d};
else
    if nargin == 4
        vars = {x,u,d,obj.SymParams.Vals};
    elseif nargin == 5
        vars = {x,u,d,params};
    end
end

for i = 1:numel(vars)
    assert(size(vars{i},1) >= param_lengths(i), "Argument %d requires %d entries", i, param_lengths(i));
end

G = obj.CalcX(obj.g_func, vars);
end