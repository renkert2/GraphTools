function [v,i] = getExternal(obj_array)
[~,i] = getInternal(obj_array);
i = ~i;
v = obj_array(i);
end