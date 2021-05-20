function [e,i] = getExternal(obj_array)
[~,i] = getInternal(obj_array);
i = ~i;
e = obj_array(i);
end