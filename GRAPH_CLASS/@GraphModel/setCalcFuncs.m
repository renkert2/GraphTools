function setCalcFuncs(obj)
% Modifies Model.setCalcFuncs to include CalcP_func for PowerFlow Calculations
u_mod = SymVars.genSymVars('u%d',max([obj.Graph.Nu,2])); % inputs - modified from SymVars.u to force MATLAB to vectorize CalcP_func even if there's a single input
vars = {[obj.SymVars.x_full], [u_mod]};
obj.CalcP_func = genMatlabFunctions(obj, obj.P_sym, vars);

setCalcFuncs@Model(obj);
end