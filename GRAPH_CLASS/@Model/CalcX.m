function X = CalcX(func, vars)
% Wrapper for matlabFunction properties, does error checking
% and assists with vectorizing the function

n_ins = nargin(func);
if n_ins > -1
    assert(numel(vars) == n_ins, "Func Requires %d Arguments", n_ins);
end

if size(vars{1},2) == 1
    X = func(vars{:});
else
    X = splitapply(func,vars{:},1:size(vars{1},2));
end
end