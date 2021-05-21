function [v,i] = getDynamic(obj_array)
i = arrayfun(@isDynamic,obj_array);
v = obj_array(i);

    function l = isDynamic(x)
        if isa(x,"GraphVertex_Internal")
            coeff = x.Coefficient;
            
            if isa(coeff, 'sym')
                l = ~ all(arrayfun(@(x) isequal(x, sym(0)), coeff));
            elseif isa(coeff, 'double')
                l = sum(abs(coeff))>0;
            else
                error('Invalid coefficient type')
            end
        else
            l = false;
        end
    end
end