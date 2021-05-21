function SymbolicSolve(obj)
% this function will only work for symbolic expressions at the moment
% symbolically solve the dynamics for a graph model

% get index of dynamic and algebraic states
if ~isa(obj.C_coeff, 'sym')
    idx_x_d = (sum(abs(obj.C_coeff(1:obj.Graph.Nv,:)),2) ~= 0);
    idx_x_a = ~idx_x_d;
else
    C_sum = sum(abs(obj.C_coeff(1:obj.Graph.Nv,:)),2);
    idx_x_a = arrayfun(@(x) isequal(x,sym(0)), C_sum);
    idx_x_d = ~idx_x_a;
end

x = obj.SymVars.x; % Dynamic States
x_a = genSymVars('x_a%d', sum(idx_x_a)); % Algebraic States
u = obj.SymVars.u; % Inputs
d = obj.SymVars.d; % Disturbances
x_e     = d(1:obj.Graph.Nev); % external state
P_e     = d(obj.Graph.Nev+1:end); % external edges

% fill state vector with symbolic varialbes
if any(idx_x_d)
    x_internal(idx_x_d,1) = x;
end
if any(idx_x_a)
    x_internal(idx_x_a,1) = x_a;
end

x_full = vertcat(x_internal, x_e); % full state vector

obj.SymVars.x_full = x_full; % Add full list of symbolic state variables, used later in initNumerical()

% Calculate power flows and capacitances
P = CalcP_Sym(obj,x_full,u); % calculates power flows
obj.P_sym = P;

C = CalcC_Sym(obj,x_full, x_internal); % calcualtes capacitance

% Solve system dynamics
% Process Algebraic States first
if any(idx_x_a)
    eqnA_temp = -obj.Graph.M(idx_x_a,:)*P + obj.D(idx_x_a,:)*P_e; % algebraic state equations
    if obj.AutomaticModify % created Modified graph powerflows (see C.T. Aksland M.S. Thesis Ch. 2)
        for i = 1:length(eqnA_temp)
            eqn = eqnA_temp(i);
            factors = factor(eqn);
            if ismember(x_a(i), factors)
                eqn = simplify(eqn/x_a(i));
            end
            eqnA_temp(i,1) = eqn;
        end
    end
    eqnA(1:sum(idx_x_a),1) = eqnA_temp == 0; % system of algebraic equations
    try
        [A,Bu] = equationsToMatrix(eqnA,x_a); % convert eqnA to the form Ax=B
        x_a_solution = linsolve(A,Bu); % find solution to the algebraic system
    catch
        warning("Failed to solve algebraic states via linsolve.  Trying nonlinear solver solve")
        x_a_solution = solve(eqnA, x_a);
        x_a_solution = struct2cell(x_a_solution);
        x_a_solution = vertcat(x_a_solution{:});
    end
    
else
    x_a_solution = sym.empty();
end

% Process Dynamic States second
if any(idx_x_d)
    eqnD(1:sum(idx_x_d),1) = diag(C(idx_x_d))^-1*(-obj.Graph.M(idx_x_d,:)*P + obj.D(idx_x_d,:)*P_e); % system of dynamic equations
    if any(idx_x_a)
        x_d_solution = simplifyFraction(subs(eqnD,x_a,x_a_solution)); % plug in the algebraic system solution into the dynamic system equations
    else
        x_d_solution = simplifyFraction(eqnD);
    end
else
    x_d_solution = sym.empty();
end

% caclulate additional model outputs
if ~isempty(obj.Graph.Outputs)
    Y = CalcY_Sym(obj,x_full,u);
    if any(idx_x_a)
        Y = simplifyFraction(subs(Y,x_a,x_a_solution)); % plug in the algebraic system solution
    else
        Y = simplifyFraction(Y);
    end
else
    Y = [];
end

% Store symbolic calculations
obj.f_sym = x_d_solution; % system derivatives
obj.g_sym = [x_full(idx_x_d);x_a_solution;Y]; % all system states
end