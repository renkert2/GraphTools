function [v,i] = getInternal(obj_array)
i = arrayfun(@(x) isa(x,'GraphVertex_Internal'), obj_array);
v = obj_array(i);
end