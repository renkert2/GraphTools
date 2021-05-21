function init(obj)
if isempty(obj.SymVars)
    setSymVars(obj);
end

setLinearCalcFuncs(obj)
setFGSym(obj);
setCalcFuncs(obj)
end