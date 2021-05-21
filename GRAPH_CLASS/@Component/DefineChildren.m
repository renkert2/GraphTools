function DefineChildren(obj)
% Dive into obj.Graph and set the Parent property of all objects with the Parent property

try
    obj.Graph.Parent = obj;
    graph_children = ["Vertices", "Edges", "Inputs", "Outputs"];
    for child = graph_children
        for i = 1:numel(obj.Graph.(child))
            obj.Graph.(child)(i).Parent = obj;
        end
    end
catch
    warning('Error defining component as parent object')
end
end