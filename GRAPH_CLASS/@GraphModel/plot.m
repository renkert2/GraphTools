function h = plot(obj,varargin)
% Pass the Graph Model you would like to plot with modifiers in
% NAME-VALUE pairs. The modifiers can include ANY modifiers
% used in the MATLAB digraph plotting PLUS the added option for
% graph model detailed labels. To invoke the detailed labels
% modifiers, use the NAME "DetailedLabels" with VALUE,
% "States","Edges","Disturbances", or "All".

if mod(length(varargin),2) == 1
    error('Plot modifiers must be in name-value pairs')
end
% extract and remove the DetailedLabels options from varargin
idxName = find(cellfun(@(x) strcmp('DetailedLabels',x),varargin));
idxValue = idxName+1;
LABELS = {varargin{idxValue}};
varargin([idxName,idxValue]) = [];

h = plot(obj.Graph,varargin{:});

for i = 1:length(LABELS)
    opts = {'All','States','Edges','Disturbances'};
    switch LABELS{i}
        case opts{1}
            LabelStates(obj,h)
            LabelEdges(obj,h)
            LabelDisturbances(obj,h)
        case opts{2}
            LabelStates(obj,h)
        case opts{3}
            LabelEdges(obj,h)
        case opts{4}
            LabelDisturbances(obj,h)
        otherwise
            error([sprintf('Provide a valid argument value for DetailedLabels:\n') sprintf('-%s\n',opts{:})]) % update this to list valid arguments
    end
end

set(gcf,'WindowButtonDownFcn',@(f,~)edit_graph(f,h))

    function LabelStates(obj,h) % label graph model vertices with state information
        labelnode(h,1:obj.Graph.Nv,obj.OutputDescriptions(1:obj.Graph.Nv))
    end

    function LabelEdges(obj,h) % label graph model edges with powerflow information
        % Get state vector filled up with symbolic varialbes
        x       = sym('x%d'      ,[obj.Graph.v_tot        1]); % dynamic states
        u       = sym('u%d'      ,[obj.Graph.Nu           1]); % inputs
        % Calculate power flows and capacitances
        P = CalcP_Sym(obj,x,u); % calculates power flows
        labeledge(h,obj.Graph.E(:,1)',obj.Graph.E(:,2)',string(P)) %label Edges
    end

    function LabelDisturbances(obj,h) % label graph model with disturbance information
        labelnode(h,obj.Graph.Nv+1:obj.Graph.v_tot,obj.DisturbanceDescriptions(1:obj.Graph.Nev))
        labeledge(h,obj.Graph.Ne+1:obj.Graph.Ne+obj.Graph.Nee,obj.DisturbanceDescriptions(obj.Graph.Nev+1:end))
    end
end