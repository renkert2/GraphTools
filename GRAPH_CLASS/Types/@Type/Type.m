classdef Type < matlab.mixin.Copyable
    % Type is a Super Class for all mathmatical expressions in the the 
    % Graph Modeling Toolbox. For example, objects of class Type can
    % convert an expression, x1+2*x2, into a callable matlab function. Type
    % objects are typically used to define graph powerflows and
    % capacitances, but also have other more generic applications. 
    % Instatiate an empty object or a filled object in the following form:
    % 
    % T = Type(type, params) where 
    % - type is a desired function defined as a string or symbolic expression
    % - params is a cell array of symbolic variables in type used to define the argument structure, 
    % -- When defining the internal matlabFunctions, the params property is used in
    % -- matlabFunction(___, 'Vars', obj.params)
    % EX: T = Type('b1*b2*c', {[sym('b1'); sym('b2')], sym('c')})
    
    % T = Type(type) 
    % When only type is specified, arguments to calcVal are determined by symvar(type)
    % ex: T = Type('b1*b2')
      
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Contributors: Christopher T. Aksland and Phil Renkert
    % Association: University of Illionis at Urbana-Champaign
    % Contact: aksland2@illinois.edu and renkert2@illinois.edu
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % potential improvements:
    % - remove either vars or params since they are duplicates of each
    % other. The redundancy may cause confusion.
    % - add 'optimize' option to the matlabfunction calls to speed up
    % processing?
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties  % User can set Val_Str or Val_Sym, the corresponding properties are updated automatically
        Val_Str string = string.empty()
        Val_Sym sym = sym.empty()
    end
    
    properties (SetAccess = protected)
        params cell % Cell array of variables used to define matlabFunction input arguments
        Val_Func function_handle % Value calculation function
    end
    
    properties (SetAccess = private, GetAccess = private)
        set_method_flag logical = true % Allows access to set methods, prevents recursion
    end
    
    methods
        function obj = Type(type, params)
            if nargin ~= 0
                if nargin == 1 % Only type specified
                    setType(obj, type);
                    obj.params = sym2cell(symvar(obj.Val_Sym));
                elseif nargin ==2
                    setType(obj, type);
                    obj.params = params;
                end
                setCalcProps(obj)
            end
        end               
        
        % set the string value and update the symbolic definition
        function set.Val_Str(obj, type)
            if obj.set_method_flag
                init(obj, type)
            else
                obj.Val_Str = type;
            end
        end
        
        % set the symbolic value and update the string definition
        function set.Val_Sym(obj, type)
            if obj.set_method_flag
                init(obj,type)
            else
                obj.Val_Sym = type;
            end
        end
        
        setType(obj,type)
        setCalcProps(obj)
        val = calcVal(obj, varargin)
        init(obj, type)        
        
    end
end
    
