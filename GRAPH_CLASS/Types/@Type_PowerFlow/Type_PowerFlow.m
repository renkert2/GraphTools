classdef Type_PowerFlow < Type
    % Type_PowerFlow (subclass of see Type) is used to define the
    % expression to calculate constant coefficient powerflows in the
    % Graph Modeling Toolbox. The powerflows must be defined in terms of
    % the tail state 'xt', head state 'xh', and inputs 'u1','u2',...,'uN'.
    % Instatiate an object in the following form:
    %
    % T = Type_PowerFlow(type) where type defines the expression used to
    % calulacte the power flow of an edge in a Graph object. type must
    % only be a function of the tail state xt, head state xh, and inputs
    % 'u1','u2',...,'uN', (as a string or symbolic variable).
    % Ex: Suppose the powerflow of a vertex is calculated as c1*(u1*xt+u2*xh)
    % where c1 is a constant coefficient, xt is the tail state, xh is the
    % head state, and u1 and u2 are inputs
    % String definition:
    % T = Type_Capacitance('u1*xt+u2*xh');
    % Symbolic definition:
    % xt = sym('xt')
    % xh = sym('xh')
    % u1 = sym('u1')
    % u2 = sym('u2')
    % T = Type_Capacitance(u1*xt+u2*xh)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Contributors: Christopher T. Aksland and Phil Renkert
    % Association: University of Illionis at Urbana-Champaign
    % Contact: aksland2@illinois.edu and renkert2@illinois.edu
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % potential improvements:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    properties (SetAccess = private)
        num_inputs {mustBeInteger, mustBeNonnegative} = 0 % Number of inputs incident on the power flow
    end
    
    methods
        function obj = Type_PowerFlow(type)
            [type, params_temp, num_inputs_temp] = Type_PowerFlow.parsePowerFlowVars(type); % Parses type, returns params argument structure and the number of inputs
            obj = obj@Type(type, params_temp);
            
            obj.num_inputs = num_inputs_temp;
        end
        
        val = calcVal(obj, xt, xh, u)
        type = updateInputs(obj, type)
        init(obj, type)
        
    end
    
    methods(Static)
        [type, params, num_inputs] = parsePowerFlowVars(type)
     
    end
end

