classdef Domains
    % Domains is an enumeration class that defines different energy 
    % domains within the Graph Modeling Toolbox. Domains are used to check
    % compatiabilty between component ports. Supported domains are
    % - Abtract (general/default value)
    % - Electrical
    % - Hydraulic
    % - IsothermalLiquid
    % - Magnetic
    % - MechanicalRotational
    % - MechanicalTranslational
    % - Thermal
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Contributors: Christopher T. Aksland and Phil Renkert
    % Association: University of Illionis at Urbana-Champaign
    % Contact: aksland2@illinois.edu and renkert2@illinois.edu
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % potential improvements:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    enumeration
        Abstract
        Electrical
        Hydraulic
        IsothermalLiquid
        Magnetic
        MechanicalRotational
        MechanicalTranslational
        Thermal
    end
    
    methods
        x = isCompatible(varargin)
    end
end