function [v,i] = getAlgebraic(obj_array)
[~,i_dyn] = getDynamic(obj_array);
[~,i_int] = getInternal(obj_array);

i = (~i_dyn) & i_int;
v = obj_array(i);
end