function DefineSymParams(obj)
% Pass symbolic parameters defined in the Component properties
% to the Graph
props = properties(obj);
sp_cell = {};
for i = 1:numel(props)
    prop = obj.(props{i});
    if isa(prop, 'symParam')
        sp_cell{end+1} = prop;
    end
end
sym_params = SymParams(sp_cell);
obj.SymParams = sym_params;
obj.Graph.SymParams = sym_params;
end