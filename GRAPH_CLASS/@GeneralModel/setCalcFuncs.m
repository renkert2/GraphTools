function setCalcFuncs(obj)
f = obj.f_sym;
g = obj.g_sym;

CalcFuncs_Cell = genMatlabFunctions(obj, {f, g});
obj.f_func = CalcFuncs_Cell{1};
obj.g_func = CalcFuncs_Cell{2};
end