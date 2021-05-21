classdef Model < matlab.mixin.Copyable
    % The Model class in the Graph Modeling Toolbox is used to generically
    % define a model in nonlinear state space form.
    %
    % System Description
    % x_dot = f_sym(x,u,d)
    % y     = g_sym(x,u,d)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Contributors: Christopher T. Aksland and Phil Renkert
    % Association: University of Illionis at Urbana-Champaign
    % Contact: aksland2@illinois.edu and renkert2@illinois.edu
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % potential improvements:
    % Add Constructor
    % Find better solution than splitapply() for calcX
    % VPA all the things
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties
        Nx (1,1) double = 0 % number of states
        Nu (1,1) double = 0 % number of inputs
        Nd (1,1) double = 0 % number of disturbances
        Ny (1,1) double = 0 % number of outputs
        
        StateDescriptions string
        InputDescriptions string
        DisturbanceDescriptions string
        OutputDescriptions string
        
        SymVars SymVars {mustBeScalarOrEmpty} % Contains fields x,u,d, each an array of symbolic variables
        SymParams SymParams {mustBeScalarOrEmpty}
    end
    
    properties
        f_sym (:,1) sym % f(x,u,d), can contain symbolic parameters
        g_sym (:,1) sym % g(x,u,d), can contain symbolic parameters
    end
    
    properties (SetAccess = protected, GetAccess = protected)
        f_func function_handle {mustBeScalarOrEmpty} % calculates x_dot
        g_func function_handle {mustBeScalarOrEmpty} % calculates y
    end
    
    properties (Dependent)
        StateTable table
        InputTable table
        DisturbanceTable table
        OutputTable table
    end
    
    methods        
        function t = get.StateTable(obj)
            state_syms = arrayfun(@(x) string((x)), obj.SymVars.x);
            t = table(state_syms, obj.StateDescriptions, 'VariableNames', ["State Index", "Description"]);
        end
        
        function t = get.InputTable(obj)
            in_syms = arrayfun(@(x) string((x)), obj.SymVars.u);
            t = table(in_syms, obj.InputDescriptions, 'VariableNames', ["Input Index", "Description"]);
        end
        
        function t = get.DisturbanceTable(obj)
            dist_syms = arrayfun(@(x) string((x)), obj.SymVars.d);
            t = table(dist_syms, obj.DisturbanceDescriptions, 'VariableNames', ["Disturbance Index", "Description"]);
        end
        
        function t = get.OutputTable(obj)
            out_syms = arrayfun(@(x) sprintf("y%d", x), 1:obj.Ny);
            t = table(out_syms', obj.OutputDescriptions, 'VariableNames', ["Output Index", "Description"]);
        end
        
        init(obj)        
        setSymVars(obj)       
        setCalcFuncs(obj)       
        F = CalcF(obj,x,u,d,params)      
        G = CalcG(obj,x,u,d,params)             
        lm = getLinearModel(obj)
             
    end
   
    methods (Access = protected)
        
        funcs = genMatlabFunctions(obj, syms, vars)
        copyModelProps(obj_from, obj_to, opts)
        
    end
    
    methods (Static, Access = protected)
        
        X = CalcX(func, vars)
        
    end
end

