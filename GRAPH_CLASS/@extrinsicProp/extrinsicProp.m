classdef extrinsicProp
    % extrinsicProp is a class that represents design-dependent 
    % properties like mass and price.  When Components are 
    % combined into a system, extrinsicProps are combined into the
    % total system extrinsicProp.  E.X. if component one had a Mass extrinsicProp 
    % with value m1 and component 2 had a Mass extrinsicProp with value m2, 
    % the combined system would have a resulting Mass extrinsicProp with value
    % m1+m2
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Contributors: Christopher T. Aksland and Phil Renkert
    % Association: University of Illionis at Urbana-Champaign
    % Contact: aksland2@illinois.edu and renkert2@illinois.edu
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % potential improvements:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties
        Type extrinsicProp_Types = "Abstract" % Property type, i.e. mass, price, etc...
        Value {mustBeA(Value, ["double", "sym"])} % Numeric or Symbolic value associated with the property
    end
    
    methods
        function obj = extrinsicProp(type, val)
            if nargin == 2
                obj.Type = type;
                obj.Value = val;
            end
        end
        
        resProps = Combine(obj_array)       
        [val, i] = getProp(obj_array, type)
        
    end
end

