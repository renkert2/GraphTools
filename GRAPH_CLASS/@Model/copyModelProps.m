function copyModelProps(obj_from, obj_to, opts)
arguments
    obj_from
    obj_to
    opts.Properties = ["Nx","Nu","Nd","Ny",...
        "StateDescriptions", "InputDescriptions", "DisturbanceDescriptions", "OutputDescriptions",...
        "SymVars","SymParams"];
end

for prop = opts.Properties
    obj_to.(prop) = obj_from.(prop);
end
end