function prepend(obj, sym_param)
assert(isa(sym_param, 'symParam'), 'Argument must be a symParam object');

obj.Vals = [double(sym_param); obj.Vals];
obj.Syms = [sym_param; obj.Syms];
obj.N = obj.N+1;
end