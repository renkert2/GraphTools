function [t,x, pf] = Simulate(obj, inputs, disturbances, params, t_range, opts)
% SIMULATE(GraphModel, inputs, disturbances, t_range, opts)
% inputs and disturbances must be column vectors of appropriate size.
% Inputs and disturbances can be anonymous functions of time or constant values
% If the Graph includes symbolic parameters, pass numerical values to the params argument as a column vector.  Leave as an empty double [] if no symbolic parameters exist
% Simulate usees the first and last entries of t_range if dynamic states are calculated
% with ODC23t, or the entire t_range vector if only algebraic states are calculated

arguments
    obj
    inputs
    disturbances
    params
    t_range
    opts.PlotStates logical = true
    opts.PlotInputs logical = false
    opts.PlotDisturbances logical = false
    opts.StateSelect = []
    opts.Solver = @ode23t
    opts.SolverOpts struct = struct.empty()
end

input_function_flag = isa(inputs, 'function_handle');
disturbance_function_flag = isa(disturbances, 'function_handle');

if ~isempty(obj.Graph.DynamicVertices)
    % Dynamic states exist
    xdot = processArgs(@CalcF, inputs, disturbances, params); % Might need to change processArgs so things run faster
    [t,xdyn] = opts.Solver(xdot, [t_range(1) t_range(end)], obj.x_init, opts.SolverOpts);
    if ~isempty(obj.Graph.AlgebraicVertices)
        xfull = processArgs(@CalcG, inputs, disturbances, params);
        x = xfull(t',xdyn')';
    else
        x = xdyn;
    end
else
    % Internal States are all constant
    xfull = processArgs(@CalcG, inputs, disturbances);
    t = t_range;
    x = xfull(t,[])';
end

if nargout == 3
    if input_function_flag
        pf = CalcP(obj, x', inputs(t)', repmat(params,1,numel(t)))';
    else
        pf = CalcP(obj, x', repmat(inputs,1,numel(t)), repmat(params,1,numel(t)))';
    end
end

if any([opts.PlotStates opts.PlotInputs opts.PlotDisturbances])
    hold on
    lgnd = string.empty();
    if opts.PlotStates
        if opts.StateSelect
            x = x(:,opts.StateSelect);
            names = obj.StateDescriptions(opts.StateSelect);
        else
            names = obj.StateDescriptions;
        end
        plot(t,x)
        lgnd = vertcat(lgnd, names);
    end
    
    if opts.PlotInputs && ~isempty(inputs)
        if input_function_flag
            plot(t,inputs(t))
        else
            plot(t,inputs*ones(size(t)));
        end
        lgnd = vertcat(lgnd,obj.InputDescriptions);
    end
    
    if opts.PlotDisturbances && ~isempty(disturbances)
        if disturbance_function_flag
            plot(t,disturbances(t')')
        else
            plot(t,(disturbances*ones(size(t))')');
        end
        lgnd = vertcat(lgnd,obj.DisturbanceDescriptions);
    end
    legend(lgnd)
    hold off
end

    function xfunc = processArgs(func, inputs_arg, disturbances_arg, params_arg)
        if input_function_flag && disturbance_function_flag
            xfunc = @(t,x) func(obj, x, inputs_arg(t), disturbances_arg(t),repmat(params_arg,1,numel(t)));
        elseif input_function_flag
            xfunc = @(t,x) func(obj, x, inputs_arg(t), repmat(disturbances_arg,1,numel(t)),repmat(params_arg,1,numel(t)));
        elseif disturbance_function_flag
            xfunc = @(t,x) func(obj, x, repmat(inputs_arg,1,numel(t)), disturbances_arg(t),repmat(params_arg,1,numel(t)));
        else
            xfunc = @(t,x) func(obj, x, repmat(inputs_arg,1,numel(t)), repmat(disturbances_arg,1,numel(t)),repmat(params_arg,1,numel(t)));
        end
    end
end