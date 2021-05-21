function resProps = Combine(obj_array)
% extrinsicProp.Combine combines like types in array of extrinsicProps
% into the resulting system extrinsicProps

types = [obj_array.Type];
unique_types = unique(types);

resProps = extrinsicProp.empty();
for i = 1:numel(unique_types) % For each unique type in obj_array
    prop_id = (unique_types(i) == types); % Get indices of all properties of that type
    val = unique_types(i).combFunc([obj_array(prop_id).Value]); % Call the combination function of the type on the values of the property of that type
    resProps(i) = extrinsicProp(unique_types(i), val); % Assign aggregate prop value into new system extrinsicProp
end
end