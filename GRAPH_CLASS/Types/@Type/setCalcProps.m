function setCalcProps(obj)
obj.Val_Func = matlabFunction(obj.Val_Sym,'Vars',obj.params);
end