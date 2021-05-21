function init(obj)
obj.Vertices = [obj.DynamicVertices; obj.AlgebraicVertices; obj.ExternalVertices];
obj.Edges    = [obj.InternalEdges; obj.ExternalEdges];

% Calculate input array from Internal Edges
obj.Inputs = unique(vertcat(obj.InternalEdges.Input), 'stable');

% calculate graph size, order, etc
obj.Nv  = length(obj.InternalVertices);
obj.Nx  = length(obj.DynamicVertices);
obj.Ne  = length(obj.InternalEdges);
obj.Nu  = length(obj.Inputs);
obj.Nev = length(obj.Vertices)-obj.Nv;
obj.Nee = length(obj.Edges)-obj.Ne;

% list of tail and head vertices
vTail = vertcat(obj.InternalEdges.TailVertex);
vHead = vertcat(obj.InternalEdges.HeadVertex);

% indicies of tail and head vertices
vT_idx =  arrayfun(@(x) find(arrayfun(@(y) eq(x,y), obj.Vertices)),vTail);
vH_idx =  arrayfun(@(x) find(arrayfun(@(y) eq(x,y), obj.Vertices)),vHead);

% calculate Edge and Incidence matrix
obj.E = [vT_idx vH_idx];
m = zeros(max(max(obj.E)),size(obj.E,1));
for i = 1:size(obj.E,1)
    m(obj.E(i,1),i) =  1; % tails
    m(obj.E(i,2),i) = -1; % heads
end
obj.M = m;

end