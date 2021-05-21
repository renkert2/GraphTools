function [val, i] = getProp(obj_array, type)
% Get value of extrinsicProp of Type type from object array of extrinsicProps
i = [obj_array.Type] == type;
val = [obj_array(i).Value];
end