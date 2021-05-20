function [e,i] = getInternal(obj_array)
i = arrayfun(@(x) isa(x,'GraphEdge_Internal'),obj_array);
e = obj_array(i);
end