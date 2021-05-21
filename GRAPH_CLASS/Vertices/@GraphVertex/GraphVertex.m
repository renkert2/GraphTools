classdef GraphVertex < handle & matlab.mixin.Heterogeneous & matlab.mixin.Copyable
    % GraphVertex Super Class for all vertex types (i.e. Internal, 
    % External) in the Graph Modeling Toolbox.
    % Instatiate an empty object or use an input parser
    % Definable properties (with class) include:
    % - Description (string)
    % - VertexType (VertexTypes)
    % - DynamicType (DynamicTypes)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Contributors: Christopher T. Aksland and Phil Renkert
    % Association: University of Illionis at Urbana-Champaign
    % Contact: aksland2@illinois.edu and renkert2@illinois.edu
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % potential improvements:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties
        Description string = string.empty() % vertex state description
        VertexType VertexTypes = "Abstract" % describes vertex type
        DynamicType DynamicTypes = "EnergyFlow" % Dynamic Type: 1 - Energy Flow, 2 - State Flow
    end
    
    properties (SetAccess = ?Component)
        Parent Component = Component.empty() % parent object for vertices
    end
    
    methods
        function obj = GraphVertex(varargin) % Object constructor
            if nargin > 1
                obj = my_inputparser(obj,varargin{:});
            end
        end
    end
    
    methods (Sealed)   
        
        x = eq(obj1,obj2)
        x = ne(obj1, obj2)
        [v,i] = getInternal(obj_array)
        [v,i] = getExternal(obj_array)
        [v,i] = getDynamic(obj_array)
        [v,i] = getAlgebraic(obj_array) 
                   
    end
end

