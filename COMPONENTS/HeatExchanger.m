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
        
        % Block Name
        Name char ='Heat Exchanger'
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
        cp_f2 (1,1) double {mustBeNumeric} = 2000;
        % Heat Transfer Coefficient [W/K]
        HTC (1,1) double {mustBeNumeric} = 10;
        
    end
    
    methods
        function obj = HeatExchanger(varargin)          
            obj@Component(varargin{:}); % calls the superclass constructor           
        end
    end
    
    methods (Access = protected)
        function g = DefineGraph(obj)
            E = [3 1; ...
                 1 5; ...
                 4 2; ...
                 2 6; ...
                 1 2];
             
             Vertex(1) = GraphVertex_Internal('Description','Temp S1','Type',1,'Capacitance',Type_Capacitance("10"));
             Vertex(2) = GraphVertex_Internal('Description','Temp S2','Type',1,'Capacitance',Type_Capacitance("10"));
             Vertex(3) = GraphVertex_External('Description','Inlet S1');
             Vertex(4) = GraphVertex_External('Description','Inlet S2');
             Vertex(5) = GraphVertex_External('Description','Outlet S1');
             Vertex(6) = GraphVertex_External('Description','Outlet S2');
%              Vertex(1) = GraphVertex_Internal('Description','Temp S1','Type',1,'Capacitance',10);
%              Vertex(2) = GraphVertex_Internal('Description','Temp S2','Type',1,'Capacitance',10);
%              Vertex(3) = GraphVertex_External('Description','Inlet S1');
%              Vertex(4) = GraphVertex_External('Description','Inlet S2');
%              Vertex(5) = GraphVertex_External('Description','Outlet S1');
%              Vertex(6) = GraphVertex_External('Description','Outlet S2');
             
             Edge(1) = GraphEdge_Internal('PowerFlow',Type_PowerFlow('Val_Char',"c*u*xt"),'Input',1,'Port',1);
             Edge(2) = GraphEdge_Internal('PowerFlow',Type_PowerFlow('Val_Char',"c*u*xt"),'Input',1,'Port',2);
             Edge(3) = GraphEdge_Internal('PowerFlow',Type_PowerFlow('Val_Char',"c*u*xt"),'Input',2,'Port',3);
             Edge(4) = GraphEdge_Internal('PowerFlow',Type_PowerFlow('Val_Char',"c*u*xt"),'Input',2,'Port',4);
             Edge(5) = GraphEdge_Internal('PowerFlow',Type_PowerFlow('Val_Char',"c*(xt-xh)"));
%              Edge(1) = GraphEdge_Internal('PowerFlow','c*u*xt','Input',1,'Port',1);
%              Edge(2) = GraphEdge_Internal('PowerFlow','c*u*xt','Input',1,'Port',2);
%              Edge(3) = GraphEdge_Internal('PowerFlow','c*u*xt','Input',2,'Port',3);
%              Edge(4) = GraphEdge_Internal('PowerFlow','c*u*xt','Input',2,'Port',4);
%              Edge(5) = GraphEdge_Internal('PowerFlow','c*(xt-xh)');
             
            g = Graph(E,Vertex,Edge);
            
        end
    end
end
