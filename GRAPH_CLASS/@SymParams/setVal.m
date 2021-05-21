function setVal(obj, param, val)
% setVal sets the value corresponding to symParam 'param' to 'val'
% - param: sym, char, or string identifying the symbolic variable
% - val: double, replaces element in obj.Vals corresponding to the param

if isa(param, 'char') || isa(param, 'string')
    param = sym(param);
end

i = arrayfun(@(p) isequal(p, param), obj.Syms);
if any(i)
    obj.Vals(i) = val;
else
    error("%s not in SymParams Syms vector", string(param));
end
end