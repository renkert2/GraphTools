classdef HeatLoad < Component
    % HeatLoad is a class the defines a heat load model
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Author: Christopher T. Aksland
    % Association: University of Illionis at Urbana-Champaign
    % Contact: aksland2@illinois.edu
    % Revision History:
    % 7/6/2020 - Class creation
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties
        
        % Block Name
        Name char ='Heat Load'
        % Working Fluid
        fluid char = 'JP8'
        % Initial Fluid temperature [C]
        T_init(1,1) double {mustBeNumeric} = 25;
        % Fluid Specific Heat [J/kg]
        cp_f (1,1) double {mustBeNumeric} = 2000;
        
    end
    
    methods
        function obj = HeatLoad(varargin)          
            obj@Component(varargin{:}); % calls the superclass constructor           
        end
    end
    
    methods (Access = protected)
        function g = DefineGraph(obj)
            E = [2 1; ...
                 1 3];
             
             Vertex(1) = GraphVertex_Internal('Description','Load Temp','Type',1,'Capacitance',10);
             Vertex(2) = GraphVertex_External('Description','Inlet');
             Vertex(3) = GraphVertex_External('Description','Outlet');
             
             Edge(1) = GraphEdge_Internal('PowerFlow','c*u*xt','Input',1,'Port',1);
             Edge(2) = GraphEdge_Internal('PowerFlow','c*u*xt','Input',1,'Port',2);
             Edge(3) = GraphEdge_External();

             g = Graph(E,Vertex,Edge);
            
        end
    end
end