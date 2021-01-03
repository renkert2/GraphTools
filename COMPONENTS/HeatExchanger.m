classdef HeatExchanger < Component
    % HeatExchanger is a class the defines a heat exchanger model
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Author: Christopher T. Aksland
    % Association: University of Illionis at Urbana-Champaign
    % Contact: aksland2@illinois.edu
    % Revision History:
    % 7/6/2020 - Class creation
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties
        % Side 1 working Fluid
        fluid1 char = 'JP8'
        % Side 2 working Fluid
        fluid2 char = 'water'
        % Initial Side 1 Fluid temperature [C]
        T1_init(1,1) double {mustBeNumeric} = 25;
        % Initial Side 2 Fluid temperature [C]
        T2_init(1,1) double {mustBeNumeric} = 25;
        % Side 1 fluid Specific Heat [J/kg]
        cp_f1 (1,1) double {mustBeNumeric} = 2000;
        % Side 2 fluid Specific Heat [J/kg]
        cp_f2 (1,1) double {mustBeNumeric} = 1000;
        % Heat Transfer Coefficient [W/K]
        HTC (1,1) double {mustBeNumeric} = 10;
        
    end
    
    methods
        function obj = HeatExchanger(varargin)          
            obj@Component('Name' ,'Heat Exchanger', varargin{:}); % calls the superclass constructor
        end
    end
    
    methods (Access = protected)
        function g = DefineGraph(obj)
            % edge matrix
            E = [3 1; ...
                 1 5; ...
                 4 2; ...
                 2 6; ...
                 1 2];
             
            % Capacitance Types
            C(1) = Type_Capacitance("1");
             
            % Power Flow Types
            P(1) = Type_PowerFlow("u1*xt");
            P(2) = Type_PowerFlow("xt");
            P(3) = Type_PowerFlow("xh");
            
            % Define Vertices
            Vertex(1) = GraphVertex_Internal('Description','Temp S1','Type',1,'Capacitance',C(1),'Coefficient',10,'Initial',25);
            Vertex(2) = GraphVertex_Internal('Description','Temp S2','Type',1,'Capacitance',C(1),'Coefficient',10,'Initial',25);
            Vertex(3) = GraphVertex_External('Description','Inlet S1','Capacitance',C(1));
            Vertex(4) = GraphVertex_External('Description','Inlet S2','Capacitance',C(1));
            Vertex(5) = GraphVertex_External('Description','Outlet S1','Capacitance',C(1));
            Vertex(6) = GraphVertex_External('Description','Outlet S2','Capacitance',C(1));
            
            % Define Inputs
            I(1) = GraphInput('HX Input 1');
            I(2) = GraphInput('HX Input 2');
            
            % Define Edges
            Edge(1) = GraphEdge_Internal('PowerFlow',P(1),'Input',I(1),'Port',1,'Coefficient',obj.cp_f1,'TailVertex',Vertex(E(1,1)),'HeadVertex',Vertex(E(1,2)));
            Edge(2) = GraphEdge_Internal('PowerFlow',P(1),'Input',I(1),'Port',2,'Coefficient',obj.cp_f1,'TailVertex',Vertex(E(2,1)),'HeadVertex',Vertex(E(2,2)));
            Edge(3) = GraphEdge_Internal('PowerFlow',P(1),'Input',I(2),'Port',3,'Coefficient',obj.cp_f2,'TailVertex',Vertex(E(3,1)),'HeadVertex',Vertex(E(3,2)));
            Edge(4) = GraphEdge_Internal('PowerFlow',P(1),'Input',I(2),'Port',4,'Coefficient',obj.cp_f2,'TailVertex',Vertex(E(4,1)),'HeadVertex',Vertex(E(4,2)));
            Edge(5) = GraphEdge_Internal('PowerFlow',[P(2); P(3)],'Coefficient',[obj.HTC -obj.HTC],'TailVertex',Vertex(E(5,1)),'HeadVertex',Vertex(E(5,2)));
            
            g = Graph(Vertex,Edge); 
        end
    end
end
