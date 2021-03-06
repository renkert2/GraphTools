classdef SymParams < matlab.mixin.Copyable
    %SYMPARAMS Contains list of SymParams Symbolic Variables, Default Values, and the number of SymParams
    % Note that this is an immutable Value class
    properties (SetAccess = private)
        Syms (:,1) sym = sym.empty()
        Vals (:,1) double = []
        N (1,1) double = 0
    end
    
    methods
        function obj = SymParams(varargin)
            if nargin == 0
                % Do Nothing
            elseif nargin == 1
                arg = varargin{1};
                if isa(arg, 'cell')
                    syms = sym.empty();
                    vals = [];
                    
                    for i = 1:numel(arg) % Loop over all cell elements
                        elem = arg{i};
                        if isa(elem, 'symParam') % For each symParam property,
                            syms(end+1,1) = elem; % Add the symParam to sym_params list
                            vals(end+1,1) = double(elem); % Add the default value of symParam to sym_params_vals list
                        end
                    end
                    
                    obj.Syms = syms;
                    obj.Vals = vals;
                    obj.N = numel(vals);
                    
                elseif isa(arg, 'sym')
                    obj.Syms = arg;
                    obj.N = numel(arg);
                    obj.Vals = zeros(obj.N, 1);
                    
                else
                    error("Single argument call to SymParams constructor must be cell or sym array");
                end
                
            elseif nargin == 2
                n = numel(varargin{1});
                assert(numel(varargin{2}) == n, "Vals must be of length %d", n);
                obj.Syms = varargin{1};
                obj.Vals = varargin{2};
                obj.N = n;
   
            else
                error("SymParams constructor requires single cell array of symParams, single sym array (Vals default to zero), or two arguments specifying syms and vals")
            end   
        end
        
        sym_params = join(obj_array)
        append(obj, sym_param)      
        prepend(obj, sym_param)        
        l = isempty(obj)        
        setVal(obj, param, val)
        
    end
end

