function append(obj, sym_param)
assert(isa(sym_param, 'symParam'), 'Argument must be a symParam object');

obj.Vals = [obj.Vals; double(sym_param)]; % Add the default value of symParam to sym_params_vals list
obj.Syms = [obj.Syms; sym_param]; % Add the symParam to sym_params list
obj.N = obj.N+1;
end