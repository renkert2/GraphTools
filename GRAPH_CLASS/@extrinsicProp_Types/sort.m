function sorted = sort(obj_array)
[~,i] = sort([obj_array.id]);
sorted = obj_array(i);
end