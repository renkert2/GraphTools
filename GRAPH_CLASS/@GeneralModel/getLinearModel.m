function lm = getLinearModel(obj)
f = obj.f_sym;
g = obj.g_sym;

A = jacobian(f,obj.SymVars.x);
B = jacobian(f,obj.SymVars.u);
E = jacobian(f,obj.SymVars.d);

C = jacobian(g,obj.SymVars.x);
D = jacobian(g,obj.SymVars.u);
H = jacobian(g,obj.SymVars.d);

lm = LinearModel(A,B,E,C,D,H);
copyModelProps(obj, lm);
end