function val = calcVal(obj, xt, xh, u)
% Substitutes numerical values for xt, xh, [u1...un].
% obj can be a single object or object array of Type_PowerFlows

num_args = nargin-1; % Matlab counts obj as an input arguments
num_inputs_array = [obj.num_inputs];

if num_args == 3 && ~isempty(u) % Input arguments 'u' specified
    assert(iscolumn(xt), 'xt must be column vector')
    assert(size(xt,1) == size(xh,1) &&  size(xt,1) == size(u,1), 'Dimension 1 of xt, xh, and u must be equivalent')
    if any(num_inputs_array) % if any of the Type_PowerFlows in obj require input arguments
        assert(length(u) >= max(num_inputs_array), 'Invalid number of inputs. Number of columns of u must be greater than or equal to the maximum number of inputs');
        val = calcVal@Type(obj, xt, xh, u);
    else % input arguments not required
        val = calcVal@Type(obj,xt,xh);
    end
elseif num_args == 2 || isempty(u) % input arguments 'u' not specified
    assert(iscolumn(xt), 'xt must be column vector')
    assert(size(xt,1) == size(xh,1), 'Dimension 1 of xt and xh must be equivalent')
    assert(all(num_inputs_array == 0), "Input argument 'u' required'");
    val = calcVal@Type(obj, xt, xh);
else
    error("Invalid arguments")
end
end