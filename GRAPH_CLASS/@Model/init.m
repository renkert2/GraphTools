function init(obj)
if isempty(obj.SymVars)
    setSymVars(obj);
end
setCalcFuncs(obj);
end