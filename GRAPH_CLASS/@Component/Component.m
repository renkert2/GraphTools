classdef Component < matlab.mixin.Heterogeneous & handle
    % Component is a super class for all specifc components (Ex: tank, 
    % battery, etc) in the Graph Modeling Toolbox. The graph property of
    % different components can be connected to generate a system model.
    % Instatiate an empty object, use an input parser, or use a strcuture array
    % with "Name" and "Value" fields, or use a single structure with 
    % fields corresponding to parameters. Valid Name and Value pairs are
    % dictated by the component subclasses.
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Contributors: Christopher T. Aksland and Phil Renkert
    % Association: University of Illionis at Urbana-Champaign
    % Contact: aksland2@illinois.edu and renkert2@illinois.edu
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % potential improvements:
    % Move SymParam and extrinsicProps outside of GraphClass Core
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties       
        Name (1,1) string = "Component" % Block Name
        Graph (1,1) Graph 
        Ports (:,1) ComponentPort = ComponentPort.empty()
        
        extrinsicProps (:,1) extrinsicProp
        SymParams SymParams {mustBeScalarOrEmpty}
    end
    
    methods
        function obj = Component(varargin)
            if nargin == 1
                if isstruct(varargin{1}) % create a component using a strucutre
                    
                    if isequal(fields(varargin{1}),{'Name';'Value'}) % Structure passed as struct array with property 'Name' and 'Value' fields, e.x. s(1).Name = 'R', s(1).Value = 1
                        for i = 1:numel(varargin{1})
                            try
                                obj.(varargin{1}(i).Name) = varargin{1}(i).Value;
                            catch
                                % eventually update this to indicate that no
                                % property for this class exists.
                            end
                        end
                        
                    else
                        fnames = fieldnames(varargin{1}); % Single structure passed with each field corresponding to a property, e.x. s.R = 1
                        for i = 1:numel(fnames)
                            try
                                obj.(fnames{i}) = varargin{1}.(fnames{i});
                            end
                        end
                    end
                else
                    error('Components must be defined using a struct array with Name/Value fields or a single struct with fields corresponding to properties')
                end
            elseif nargin > 1
                my_inputparser(obj,varargin{:}); % input parser component models
            end
            obj.init_super();

        end
        
        function set.Name(obj, name)
            obj.Name = string(name);
        end
    end
    
    methods (Sealed)
        init_super(obj)
    end
    
    methods (Sealed, Access = protected)
        DefineChildren(obj)
        DefineSymParams(obj)    
    end
    
        
    methods (Access = protected)        
        init(obj)
    end
    
    methods (Sealed) 
        [gSys, extProps] = Combine(C, ConnectP, varargin)      
        setParamVal(obj, param, val)    
        comp_arrays = Replicate(obj_array, N)
    end
    
    methods (Abstract, Access = protected)
        DefineComponent(obj) % Required in subclasses
    end
end

