function [C] = CalcC_Sym(obj,x_full, x_internal)
% CalcC_Sym calculates the capacitance values of a graph model.

%%% INPUTS
% Sys  - System graph model object
% x0   - state vector

%%% OUTPUTS
% C - Capacitance vector

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Christopher T. Aksland
% Association: University of Illionis at Urbana-Champaign
% Contact: aksland2@illinois.edu
% Revision History:
% 11/22/2020 - Function creation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Potential improvements
% -
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% graph lookups
c   = sym(zeros(size(obj.C_coeff)));
% caculate the capacitance of each vertex for each coefficient
for i = 1:size(obj.C_coeff,2)
    c(:,i) = obj.C_coeff(:,i).*obj.CType(i).calcVal(x_internal); % the 1 and 0 in these lines will need to be changed
end
c = sum(c,2); % sum across capacitance coefficients

% function lookups
LF = sym(ones(obj.Graph.Nv,1));
for i = 1:length(LF)
    cf = obj.Graph.Vertices(i).CapFunction;
    if ~isempty(cf)
        [~,idx] = ismember(cf.Breakpoints(:),obj.Graph.Vertices);
        input = num2cell(x_full(idx));
        LF(i) = cf.Function.calcVal(input{:});
    end
end


C = LF.*c(1:obj.Graph.Nv); % solve for the capacitance of each vertex
end