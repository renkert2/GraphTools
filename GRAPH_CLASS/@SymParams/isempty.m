function l = isempty(obj)
l =  builtin('isempty', obj);
if ~l
    l = obj.N == 0;
end
end