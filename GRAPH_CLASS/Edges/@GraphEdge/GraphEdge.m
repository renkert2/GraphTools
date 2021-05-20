classdef GraphEdge < matlab.mixin.Heterogeneous & handle
    % GraphEdge Super Class for all edge types (i.e. Internal, External) in
    % the Graph Modeling Toolbox
    % Instatiate an empty object or use an input parser
    % Definable properties (with class) include:
    % - Description (string)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Contributors: Christopher T. Aksland and Phil Renkert
    % Association: University of Illionis at Urbana-Champaign
    % Contact: aksland2@illinois.edu and renkert2@illinois.edu
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % potential improvements:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties
        Description (1,1) string % Edge Description
    end
    
    properties (SetAccess = ?Component) % Parent can only be set by the instantiating Component
        Parent Component = Component.empty() % edge parent object
    end

    methods
        function obj = GraphEdge(varargin) % constructor method using input parsing
            if nargin > 1
                obj = my_inputparser(obj,varargin{:});
            end
        end
    end
    
    methods (Sealed) % Sealed attribute required for heterogenous arrays
        x = eq(obj1,obj2)
        x = ne(obj1, obj2)
        
        [e,i] = getInternal(obj_array)
        [e,i] = getExternal(obj_array)
    end
    
end