function F = CalcF(obj,x,u,d,params)
param_lengths = [obj.Nx, obj.Nu, obj.Nd, obj.SymParams.N];

if nargin == 4 || isempty(obj.SymParams)
    vars = {x,u,d};
elseif nargin == 5
    vars = {x,u,d,params};
end

for i = 1:numel(vars)
    assert(size(vars{i},1) >= param_lengths(i), "Argument %d requires %d entries", i, param_lengths(i));
end

F = obj.CalcX(obj.f_func, vars);
end