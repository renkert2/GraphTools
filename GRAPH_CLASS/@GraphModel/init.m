function init(obj)
obj.Nx = obj.Graph.Nx; % number of states
obj.Nu = obj.Graph.Nu; % number of inputs
obj.Nd = obj.Graph.Nev + obj.Graph.Nee; % number of disturbances
obj.Ny = obj.Graph.Nv + numel(obj.Graph.Outputs); % number of outputs

setSymVars(obj)
obj.SymParams = obj.Graph.SymParams; % list of symbolic parametes

% get state initial conditions
if ~isempty(obj.Graph.DynamicVertices)
    obj.x_init = vertcat(obj.Graph.DynamicVertices.Initial);
else
    obj.x_init = [];
end

% vertex dynamic type (energy or state flow)
% Can we remove this?
obj.DynType = vertcat(obj.Graph.Vertices.DynamicType);

% create the D matrix: External Edge Mapping Matrix
Dmat = zeros(obj.Graph.v_tot,obj.Graph.Nee);
E_idx = arrayfun(@(x) find(x==obj.Graph.InternalVertices),vertcat(obj.Graph.ExternalEdges.HeadVertex));
for i  = 1:length(E_idx)
    Dmat(E_idx(i),i) = 1;
end
obj.D = Dmat;

% create B matrix
% dim 1: affected edge
% dim 2: inputs
% dim 3: used if multiple inputs affect the same edge
Eint = obj.Graph.InternalEdges;
numU = max(arrayfun(@(x) length(x.Input),Eint));
obj.B = zeros(obj.Graph.Ne, obj.Graph.Nu, numU); % Inputs added along second dimensions; separate inputs along third dimension
for i = 1:numel(Eint)
    for j = 1:numel(Eint(i).Input)
        obj.B(i,:,j) = (Eint(i).Input(j)==obj.Graph.Inputs);
    end
end

% create C matrix
CTypeAll = vertcat(obj.Graph.InternalVertices(:).Capacitance); % get list of all capacitance types
numCType = arrayfun(@(x) length(x.Capacitance),obj.Graph.InternalVertices); % number of capacitance types thtat affect each vertex
% build the graph Capacitance Coefficient matrix and figure out minimum number of unique capacitance types
[obj.C_coeff,obj.CType] = MakeCoeffMatrix(obj.Graph.InternalVertices,CTypeAll,numCType);

% P matrix
PTypeAll = vertcat(Eint(:).PowerFlow); % get list of all powerflow types
numPType = arrayfun(@(x) length(x.PowerFlow),Eint); % number of powerflow types thtat affect each edge
% build the graph powerflow Coefficient matrix and figure out minimum number of unique powerflow types
[obj.P_coeff,obj.PType] = MakeCoeffMatrix(Eint,PTypeAll,numPType);

SymbolicSolve(obj);
setCalcFuncs(obj);
setDescriptions(obj);
end