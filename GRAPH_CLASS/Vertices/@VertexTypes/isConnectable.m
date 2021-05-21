function x = isConnectable(varargin)
% isConnectable = true -> Vertices can be connceted via an edge
% Arguments are two VertexType arguments as comma separated list or array of two objects

if nargin > 1
    obj_array = [varargin{:}];
else
    obj_array = varargin{1};
end

assert(numel(obj_array) == 2, 'isConnectable requires two VertexType arguments as comma separated list or array of two objects');
obj1 = obj_array(1);
obj2 = obj_array(2);

if (obj1.VariableType == VariableTypes.Abstract || obj2.VariableType == VariableTypes.Abstract)
    x = true;
elseif (obj1.VariableType ~= obj2.VariableType)
    x = true;
else
    x = false;
end
end