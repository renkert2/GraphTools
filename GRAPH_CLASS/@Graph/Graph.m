classdef Graph < matlab.mixin.Copyable
    % Graph is a class that stores all the information required to generate
    % a graph model. Graphs can be instatiated as an empty object or
    %
    % g = Graph(Vertex,Edge) where Vertex is an array of GraphVertex 
    % elements and Edge is array of GraphEdge elements.
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Contributors: Christopher T. Aksland and Phil Renkert
    % Association: University of Illionis at Urbana-Champaign
    % Contact: aksland2@illinois.edu and renkert2@illinois.edu
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % potential improvements:
    % - Consider added Matlab "digraph" or adjcancy matrix as a propertey.
    % - Consider improving how we find the head and tail vertex indices.
    % - At some point, graph can be defined with only edges
    % - Move the Internal/External etc get functions into the GraphVertex and
    %   GraphEdge classes. Since those functions only operate on vertices
    %   and edges, it seems they fit better there.
    % - The graph combination code should be moved to a separate file
    %   (files) since it's so long and complex.
    % - Phil: Figure out a more elegant solution for SymParams
    % - Use VPA on all our symbolic calculations to save a ton of time
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties
        Vertices (:,1) GraphVertex % set of vertices
        Edges (:,1) GraphEdge % set of edges
        
        Outputs (:,1) GraphOutput % Graph Outputs
              
        SymParams SymParams {mustBeScalarOrEmpty}
    end
    
    properties (SetAccess = private)
        Inputs (:,1) GraphInput % graph Inputs
        
        Nv (1,1) double % Number of Internal Vertices
        Nx (1,1) double % Number of Dynamic States / Dynanic Vertices
        Ne (1,1) double % Number of Edges
        Nu (1,1) double % Number of Inputs 
        Nev (1,1) double % Number of External Vertices
        Nee (1,1) double % Number of External Edges
          
        E (:,2) double % Graph Edge Matrix
        M (:,:) double % Incidence Matrix
    end
    
    properties (Dependent)  
        v_tot (1,1) double % total number of vertices
  
        Tails (1,1) double 
        Heads (1,1) double 
    end
    
    properties (Dependent)
        InternalVertices  (:,1) GraphVertex
        DynamicVertices   (:,1) GraphVertex
        AlgebraicVertices (:,1) GraphVertex
        ExternalVertices  (:,1) GraphVertex
        InternalEdges     (:,1) GraphEdge
        ExternalEdges     (:,1) GraphEdge 
    end
    
    properties (SetAccess = ?Component)
        Parent Component = Component.empty()
    end
    
    methods
        function obj = Graph(varargin) % constructor method
            % this function can be initialized with an edge matrix.
            % Immediately calculate the incidence matrix
           if nargin == 0
               % do nothing
           elseif nargin == 2
               obj.Vertices = varargin{1};
               obj.Edges = varargin{2};
               obj.init()
           else
              error('A Graph object must be initialized as an empty object or as Graph(Vertex_Set, Edge_Set ).') 
           end
                              
        end
                      
        function x = get.v_tot(obj) % total number of vertices
            x = obj.Nv + obj.Nev;
        end
        
        function x = get.Tails(obj) % tail incidence matrix
            x = double(obj.M'== 1);
        end
        
        function x = get.Heads(obj) % head incidence matrix
            x = double(obj.M'== -1);
        end
        
        function x = get.InternalVertices(obj) % get list of Internal Vertices
            x = getInternal(obj.Vertices);
        end
        
        function x = get.ExternalVertices(obj) % get list of external vertices
            x = getExternal(obj.Vertices);
        end 
        
        function x = get.DynamicVertices(obj) % get list of Dynamic Vertices
            x = getDynamic(obj.Vertices);
        end
        
        function x = get.AlgebraicVertices(obj) % get list of algebraic Vertices
            x = getAlgebraic(obj.Vertices);
        end
        
        function x = get.InternalEdges(obj) % get list of internal edges
            x = getInternal(obj.Edges);
        end
        function x = get.ExternalEdges(obj) % get list of external edges
            x = getExternal(obj.Edges);
        end
        
        init(obj)               
        h = plot(obj,varargin)       
        [obj, ConnectE, ConnectV] = Combine(G, ConnectE, ConnectV, opts)       
        val = isempty(obj)
        
    end
    
end

