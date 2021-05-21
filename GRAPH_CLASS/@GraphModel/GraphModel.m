classdef GraphModel < Model
    % GraphModel converts a Graph object to a model that can be simulated
    % or used in other supported tools. GraphModel subclasses Model as a
    % specific type of model within the Graph Modeling Toolbox. 
    % A graph model is represented in the form
    % 
    % C*x_dot = -M_ubar*P + DP_in
    %
    % A GraphModel can be instatiated as an empty object or as:
    % 
    % gm = GraphModel(comp) where comp is a Graph or Component object
    %   or
    % gm = GraphModel(comp,opts) where opts has optional settings
    %       opts.Linearize = {true or false}
    %       opts.CalcPMethod = {Default or Edges}
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Contributors: Christopher T. Aksland and Phil Renkert
    % Association: University of Illionis at Urbana-Champaign
    % Contact: aksland2@illinois.edu and renkert2@illinois.edu
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % potential improvements:
    % - split this class into multiple files for organizational purposes
    % - use VPA with abandon on symbolic calculations
    % - Remove DynType and DynamicType from GraphVertex, I don't think we're using them
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties
        Graph (1,1) Graph
        AutomaticModify (1,1) logical = true
        CalcPMethod (1,1) CalcPMethods = CalcPMethods.Default
    end
    
    properties (SetAccess = private)
        C_coeff (:,:) {mustBeNumericOrSym} % capacitance coefficient matrix
        CType (:,1) Type_Capacitance = Type_Capacitance.empty()
        P_coeff (:,:) {mustBeNumericOrSym} % powerflow coefficient matrix
        PType (:,1) Type_PowerFlow = Type_PowerFlow.empty()
        x_init (:,1) double % initial condition vector
        DynType (:,1) DynamicTypes = DynamicTypes.EnergyFlow
        D (:,:) double % external edge mapping matrix
        B (:,:,:) double % input mapping matrix
        
        P_sym (:,1) sym % Symbolic Representation of Power Flows
    end
    
    properties (SetAccess = protected, GetAccess = protected)
        CalcP_func % Matlab function of Power Flows
    end
    
    properties (Dependent)
        VertexTable table
        EdgeTable table
    end

    methods
        function obj = GraphModel(arg1, opts)
            arguments 
                arg1 (:,1) = []
                
                % Specify Default Options
                opts.CalcPMethod CalcPMethods = "Default"
            end
            
            % build model from Graph or Component object
            if ~isempty(arg1)
                if isa(arg1,'Graph')
                    obj.Graph = arg1;
                elseif isa(arg1,'Component')
                    obj.Graph = arg1.Graph;
                else
                    error('Invalid argument to GraphModel.  Must be of type Graph or Component')
                end
                
                obj.CalcPMethod = opts.CalcPMethod;
            
                init(obj);
            end
        end
        
        function vertex_table = get.VertexTable(obj)
            % compile the vertex information into a table for improved
            % usability
            names = vertcat(obj.Graph.Vertices.Description);
            parents = vertcat(vertcat(obj.Graph.Vertices.Parent).Name);
            types = vertcat(obj.Graph.Vertices.VertexType);
            vertex_table = table((1:(obj.Graph.Nv+obj.Graph.Nev))', parents, names, types, 'VariableNames', ["Vertices", "Component", "Description", "Domain"]);
        end
        
        function edge_table = get.EdgeTable(obj)
            % compile the edge information into a table for improved
            % usability
            digits(4)
            pflows = vpa(obj.P_sym);
            pflows_strings = arrayfun(@string, pflows);
            digits(32)
            
            parents = vertcat(vertcat(obj.Graph.InternalEdges.Parent).Name);
            
            edge_table = table((1:(obj.Graph.Ne))',parents, pflows_strings, 'VariableNames', ["Edges", "Component", "PowerFlows"]);
        end
        
        
        init(obj)       
        setCalcFuncs(obj)      
        setDescriptions(obj)   
        [t,x, pf] = Simulate(obj, inputs, disturbances, params, t_range, opts)
        h = plot(obj,varargin)          
        SymbolicSolve(obj)           
        [P] = CalcP_Sym(obj,x0,u0)       
        [C] = CalcC_Sym(obj,x_full, x_internal)
        [Y] = CalcY_Sym(obj,x0,u0)
        P = CalcP(obj, x_full, u, params)
        
        
    end       
end

