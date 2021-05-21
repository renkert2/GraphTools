function comp_arrays = Replicate(obj_array, N)
% Replicate is used to create N independent copies of all the components in obj_array
% Returns comp_arrays cell array containing the duplicate components.
% - comp_arrays{i} is an 1xN Component array of copies corresponding to obj_array(i)

comp_arrays = cell(size(obj_array));
for i = 1:numel(obj_array)
    comp = obj_array(i);
    unique_props = setdiff(properties(comp), properties('Component')); % Get properties unique to the specific component, i.e. remove properties in the Component superclass
    prop_struct = struct();
    for j = 1:numel(unique_props)
        prop_struct.(unique_props{j}) = comp.(unique_props{j});
    end
    
    constructFun = str2func(class(comp)); % Get the class Constructor handle specific to the component.
    
    for j = 1:N
        prop_struct.Name = join([comp.Name,string(j)]);
        comp_array(j) = constructFun(prop_struct); % Call the constructor N times to get N independent objects with identical property values.
    end
    
    comp_arrays{i} = comp_array;
end
end