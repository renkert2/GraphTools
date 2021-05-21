function setFGSym(obj)
x = obj.SymVars.x;
u = obj.SymVars.u;
d = obj.SymVars.d;

if isempty(u)
    u = 0;
end
if isempty(d)
    d = 0;
end

obj.f_sym = obj.A_sym*x + obj.B_sym*u + obj.E_sym*d + obj.f0;
obj.g_sym = obj.C_sym*x + obj.D_sym*u + obj.H_sym*d + obj.g0;
end