function funcs = genMatlabFunctions(obj, syms, vars)
% Generates matlabFunctions from symbolic arrays
% i.e. f_sym -> calcF_Func and g_sym -> calcG_Func in
% setCalcFuncs().
% Vars argument is optional
arguments
    obj
    syms
    vars = {}
end

if isempty(vars)
    vars = {[obj.SymVars.x], [obj.SymVars.u], [obj.SymVars.d]};
end

if ~isempty(obj.SymParams)
    vars{end+1} = [obj.SymParams.Syms];
end

cell_flag = isa(syms, 'cell');
if cell_flag
    funcs = cellfun(@processSym, syms, 'UniformOutput', false);
else
    funcs = processSym(syms);
end

    function func = processSym(sym)
        if isa(sym, 'sym')
            func = matlabFunction(sym,'Vars',vars);
        else
            func = @(varargin) sym;
        end
    end
end