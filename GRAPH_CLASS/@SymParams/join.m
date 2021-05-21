function sym_params = join(obj_array)
syms = vertcat(obj_array.Syms);
[syms, ia, ~] = unique(syms);

vals = vertcat(obj_array.Vals);
vals = vals(ia);

sym_params = SymParams(syms,vals);
end