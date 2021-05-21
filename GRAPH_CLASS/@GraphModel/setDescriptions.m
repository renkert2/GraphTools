function setDescriptions(obj)
% figure out the state names for a graph model
if ~isempty(obj.Graph.DynamicVertices)
    Desc = vertcat(obj.Graph.DynamicVertices.Description); % state description
    Blks = vertcat(vertcat(obj.Graph.DynamicVertices.Parent).Name); % state's parent object
    x = join([Blks,repmat('\',length(Blks),1),Desc]); %format [component \ state desc]
else
    x = string.empty();
end
obj.StateDescriptions = x;

% figure out the input names for a graph model
if ~isempty(obj.Graph.Inputs)
    Desc = vertcat(obj.Graph.Inputs.Description); % input description
    Blks = vertcat(vertcat(obj.Graph.Inputs.Parent).Name); % input's parent object
    x = join([Blks,repmat('\',length(Blks),1),Desc]); %format [component \ input desc]
else
    x = string.empty();
end
obj.InputDescriptions = x;

% figure out the disturbance names for a graph model
% external vertex disturbance info
if ~isempty(obj.Graph.ExternalVertices)
    ext_verts_desc = vertcat(obj.Graph.ExternalVertices.Description); % disturbance description
    ext_verts_parents = vertcat(vertcat(obj.Graph.ExternalVertices.Parent).Name); % disturbance's parent object
else
    ext_verts_desc = [];
    ext_verts_parents = [];
end
% external edge disturbance info
if ~isempty(obj.Graph.ExternalEdges)
    ext_edges_desc = vertcat(obj.Graph.ExternalEdges.Description); % disturbance description
    ext_edges_parents =  vertcat(vertcat(obj.Graph.ExternalEdges.Parent).Name); % disturbance's parent object
else
    ext_edges_desc = [];
    ext_edges_parents = [];
end
Desc = [ext_verts_desc; ext_edges_desc]; % concatenate descriptions into single list
Blks = [ext_verts_parents; ext_edges_parents]; % concatenate parent objects into single list
x = join([Blks,repmat('\',length(Blks),1),Desc]); %format [component \ disturbance desc]
obj.DisturbanceDescriptions = x;

% figure out the output names for a graph model
% graph outputs default to include all vertex state values
DescX = vertcat(obj.Graph.InternalVertices.Description); % internal vertex desc
BlksX = vertcat(vertcat(obj.Graph.InternalVertices.Parent).Name); % internal vertex parent object
if ~isempty(obj.Graph.Outputs) % if additional model outputs are defined, include those
    DescY = vertcat(obj.Graph.Outputs.Description);
    BlksY = vertcat(vertcat(obj.Graph.Outputs.Parent).Name);
else
    DescY = [];
    BlksY = [];
end
Desc = [DescX; DescY]; % concatentate descriptions
Blks = [BlksX; BlksY]; % concatenate parent object names
x = join([Blks,repmat('\',length(Blks),1),Desc]); %format [component \ output desc]
obj.OutputDescriptions = x;
end