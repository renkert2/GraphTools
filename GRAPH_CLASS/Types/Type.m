classdef Type < matlab.mixin.Copyable
    % Type is a Super Class for all mathmatical expressions in the the 
    % Graph Modeling Toolbox. For example, objects of class Type can
    % convert an expression, x1+2*x2, into a callable matlab function. Type
    % objects are typically used to define graph powerflows and
    % capacitances, but also have other more generic applications. 
    % Instatiate an empty object or a filled object in the following form:
    % 
    % T = Type(vars,params,type) where type is a desired function defined
    % as a string or symbolic expression, vars is a symbolic array of the
    % symbolic variables used in type, and params is a symbolic cell array
    % form of vars.
    % ex: T = Type([sym('b1') sym('b2')],{sym('b1') sym('b2')},'b1*b2')
      
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
    
    % @Phil can you comment this since you're more familiar.
    
    properties  % User can set Val_Str or Val_Sym, the corresponding properties are updated automatically
        Val_Str string = string.empty()
        Val_Sym sym = sym.empty()
    end
    
    properties (SetAccess = protected)
        vars sym = sym.empty % contains list of symbolic variables used in type definition.  This property is set by subclasses, i.e. Type_PowerFlow.vars = [x_t, x_h, u_j]
        params cell = cell.empty % Cell array of variables used to define matlabFunction input arguments
        
        Val_Func function_handle = function_handle.empty() % Value calculation function
        Jac_Func function_handle = function_handle.empty() % Jacobian calculation function
        
        Jac_Sym sym = sym.empty() % Symbolic Jacobian
    end
    
    properties (SetAccess = private, GetAccess = private)
        set_method_flag logical = true % Allows access to set methods, prevents recursion
    end
    
    methods
        function obj = Type(vars, params, type) % Type class constructor
            if nargin ~= 0
                obj.vars = vars;
                obj.params = params;
                init(obj,type)
            end
        end
        
        function init(obj, type)
            setType(obj, type);
            setCalcProps(obj);
        end
        
        function setType(obj,type)
            if isa(type,'string') || isa(type,'char')
                Val_Str_temp = type;
                Val_Sym_temp = str2sym(Val_Str_temp);
            elseif isa(type,'sym')
                Val_Sym_temp = type;
                Val_Str_temp = string(Val_Sym_temp);
            else
                error("Type must be 'string', 'char', or 'sym'")
            end
                                 
            obj.set_method_flag = false; % Prevents infinite loop in set method
            
            if isempty(obj.Val_Sym) || obj.Val_Sym ~= Val_Sym_temp
                obj.Val_Sym = Val_Sym_temp;
            end
            
            if isempty(obj.Val_Str) || not(strcmp(obj.Val_Str,Val_Str_temp))
                obj.Val_Str = Val_Sym_temp;
            end
            
            obj.set_method_flag = true;
        end
        
        function setCalcProps(obj)
            obj.Val_Func = matlabFunction(obj.Val_Sym,'Vars',obj.params);
            obj.Jac_Sym  = jacobian(obj.Val_Sym,obj.vars);
            obj.Jac_Func = matlabFunction(obj.Jac_Sym,'Vars',obj.params);
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
        
        
        function val = calcVal(obj, varargin) % Calculates type value with symbolic 'vars' substituted with numeric 'vars_'
            num_params = arrayfun(@(x) numel(x.params), obj);
            assert(numel(varargin)==max(num_params), 'Arguments must match Parameter Structure.  For object array, ensure maximum number of inputs are given');
            
            if numel(obj)==1
                val = obj.Val_Func(varargin{1:num_params});
            else
                val = cell(size(obj));
                for i = 1:size(obj,1)
                    for j = 1:size(obj,2)
                        val{i,j} = obj(i,j).Val_Func(varargin{1:num_params(i,j)});
                    end
                end
            end
        end
        
        function val = calcJac(obj, varargin) % Calculates type Jacobian with symbolic 'vars' substituted with numeric 'vars_'
            num_params = arrayfun(@(x) numel(x.params), obj);
            assert(numel(varargin)==max(num_params), 'Arguments must match Parameter Structure.  For object array, ensure maximum number of inputs are given');
            
            if numel(obj) == 1
                val = obj.JacFunc(varargin{1:num_params});
            else
                val = cell(size(obj));
                for i = 1:size(obj,1)
                    for j = 1:size(obj,2)
                        val{i,j} = obj(i,j).Jac_Func(varargin{1:num_params(i,j)});
                    end
                end
            end
        end  
    end
end
    
