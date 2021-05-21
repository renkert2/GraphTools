function val = calcVal(obj, varargin)
% Calculates type value by replacing symbolic vars with numerical vars.
% obj can be a single Type object or object array of Types with similar arguments
% Expects one argument for each element in obj.params.
% E.X. if obj.params = {[x1;x2],y,z}, use obj.calcVal([x1;x2], y, z)

num_params = arrayfun(@(x) numel(x.params), obj);
assert(numel(varargin) == max(num_params), 'Arguments must match Parameter Structure.  For object array, ensure maximum number of inputs are given');

if numel(obj)==1
    val = obj.Val_Func(varargin{1:num_params});
else
    val = cell(size(obj));
    for i = 1:size(obj,1)
        for j = 1:size(obj,2)
            val{i,j} = obj(i,j).Val_Func(varargin{1:num_params(i,j)});
        end
    end
end
end