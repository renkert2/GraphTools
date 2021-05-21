classdef VertexTypes
    % VertexTypes is an enumeration class that combines Variable Type and 
    % Domain information in the Graph Modeling Toolbox. VertexTypes are 
    % used to check compatiabilty between component ports. 
    % Combines Domain and VariableType information into single enumeration
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Contributors: Christopher T. Aksland and Phil Renkert
    % Association: University of Illionis at Urbana-Champaign
    % Contact: aksland2@illinois.edu and renkert2@illinois.edu
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % potential improvements:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    enumeration
        % Domains derived from: https://www.mathworks.com/help/physmod/simscape/ug/basic-principles-of-modeling-physical-networks.html#bq89sba-3
        Abstract ('Abstract', 'Abstract')
        
        % Electrical Domain
        Voltage ('Electrical','Effort')
        Current ('Electrical','Flow')
        
        % Hydraulic Domain
        GaugePressure ('Hydraulic','Effort')
        VolumetricFlowRate ('Hydraulic','Flow')
        
        % Isothermal Liquid
        AbsolutePressure ('IsothermalLiquid','Effort')
        MassFlowRate ('IsothermalLiquid','Flow')
        
        % Magnetic Domain
        MagnetomotiveForce ('Magnetic','Effort')
        Flux ('Magnetic','Flow')
        
        % Mechanical Rotational Domain
        AngularVelocity ('MechanicalRotational','Effort')
        Torque ('MechanicalRotational','Flow')
        
        % Mechanical Translational Domain
        TranslationalVelocity ('MechanicalTranslational','Effort')
        Force ('MechanicalTranslational','Flow')
        
        % Thermal Domain
        Temperature ('Thermal','Effort')
        HeatFlow ('Thermal','Flow')
    end
    
    properties
        Domain Domains = 'Abstract'
        VariableType VariableTypes = 'Abstract'
    end
    
    methods
        function obj = VertexTypes(domain, var_type)
            obj.Domain = domain;
            obj.VariableType = var_type;
        end
        
        x = isAbstract(obj)
        x = isEffort(obj)
        x = isFlow(obj)
        x = isConnectable(varargin)
        x = isCompatible(varargin)  
        
    end
        
end

