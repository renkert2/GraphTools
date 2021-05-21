function setType(obj,type)
if isa(type,'string') || isa(type,'char')
    Val_Str_temp = type;
    Val_Sym_temp = str2sym(Val_Str_temp);
elseif isa(type,'sym')
    Val_Sym_temp = type;
    Val_Str_temp = string(Val_Sym_temp);
else
    error("Type must be 'string', 'char', or 'sym'")
end

obj.set_method_flag = false; % Prevents infinite loop in set method

if isempty(obj.Val_Sym) || obj.Val_Sym ~= Val_Sym_temp
    obj.Val_Sym = Val_Sym_temp;
end

if isempty(obj.Val_Str) || not(strcmp(obj.Val_Str,Val_Str_temp))
    obj.Val_Str = Val_Sym_temp;
end

obj.set_method_flag = true;
end