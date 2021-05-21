function x = isCompatible(varargin)
% isCompatible = true -> Vertices can be combined in equivalence connection
% Arguments are VertexTypes as comma separated list or array of VertexType objects

if nargin > 1
    obj_array = [varargin{:}];
else
    obj_array = varargin{1};
end

assert(numel(obj_array)>=2,'Array of two or more objects required');

definedTypes = obj_array(VertexTypes.Abstract ~= obj_array); % Allow combination of abstract types
if ~isempty(definedTypes)
    x = all(definedTypes(1) == definedTypes);
else
    x = true;
end
end