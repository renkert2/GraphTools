function type = updateInputs(obj, type)
[type, params_temp, num_inputs_temp] = Type_PowerFlow.parsePowerFlowVars(type);
obj.params = params_temp;
obj.num_inputs = num_inputs_temp;
end