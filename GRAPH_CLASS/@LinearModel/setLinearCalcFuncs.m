function setLinearCalcFuncs(obj)
for i = 1:obj.N_mats
    sym = obj.(obj.syms_props(i));
    if ~isempty(sym)
        func = genMatlabFunctions(obj,sym);
        obj.(obj.func_props(i)) = func;
    end
end
end