function H = getHRep(obj) % build the model H-representation
H = zeros(2,2);
H(:,1) = [1;-1];
H(:,2) = [obj.UpperLimit;-obj.LowerLimit];

end