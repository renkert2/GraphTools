function [P] = CalcP_Sym(obj,x0,u0)
% CalcP_Sym calculates the power flows of a Graph model.

%%% INPUTS
% Sys  - System Graph model object
% x0   - state vector
% u0   - input vector
% opts.
% - opts.Method = Default: vectorized calculation of every power flow
% - opts.Method = Edges: calculates powerflows independently for each edge.  Avoids some numerical issues with complicated powerflows.

%%% OUTPUTS
% P - Power flows

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

if obj.CalcPMethod == "Default"
    xt = obj.Graph.Tails*x0; %tail states
    xh = obj.Graph.Heads*x0; %head states
    [~,~,Nu] = size(obj.B); % max number of inputs incident per edge
    Ne = obj.Graph.Ne;
    u = sym(zeros(Ne,Nu)); % initialize edge input data.
    for i = 1:Nu
        u(:,i) = obj.B(:,:,i)*u0;
    end
    
    % calculate the powerflow along each edge. Note the 3x vector size from
    % repmat required to simulate a multi-domain graph
    P = sym(zeros(size(obj.P_coeff)));
    for i = 1:size(obj.P_coeff,2)
        P(:,i) = obj.P_coeff(:,i).*obj.PType(i).calcVal(xt,xh,u);
    end
    
    % sum the powerflow coefficients
    P = sum(P,2);
elseif obj.CalcPMethod == "Edges"
    xt = obj.Graph.Tails*x0; %tail states
    xh = obj.Graph.Heads*x0; %head states
    Ne = obj.Graph.Ne - obj.Graph.Nee;
    P = sym(zeros(Ne,1));
    for i = 1:Ne
        edge = obj.Graph.InternalEdges(i);
        types = edge.PowerFlow;
        coeffs = edge.Coefficient;
        u = squeeze(obj.B(i,:,:)).'*u0; % Column vector of inputs corresponding to this edge
        types_sym = arrayfun(@(x) x.calcVal(xt(i),xh(i),u.'),types);
        pflows = coeffs.'*types_sym;
        P(i,1) = pflows;
    end
end
end