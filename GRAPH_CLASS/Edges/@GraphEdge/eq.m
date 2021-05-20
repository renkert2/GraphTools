function x = eq(obj1,obj2)
% custom GraphEdge object eq() method to compare a hetergeneous
% array of GraphEdges
% GraphEdges are 'handle' objects, so they are considered
% equivalent if the handles point to the same GraphEdge object.
if numel(obj1)==numel(obj2)
    x = false(size(obj1));
    for i = 1:numel(obj1)
        x(i) = eq@handle(obj1(i), obj2(i));
    end
elseif numel(obj1)==1
    x = false(size(obj2));
    for i = 1:numel(obj2)
        x(i) = eq@handle(obj1, obj2(i));
    end
elseif numel(obj2)==1
    x = false(size(obj1));
    for i = 1:numel(obj1)
        x(i) = eq@handle(obj2, obj1(i));
    end
else
    error('array sizes are incompatible')
end
end