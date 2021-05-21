classdef LinearModel < Model
    % LinearModel is a propety of the model class and has linear state
    % space model matrices. The model is of the form:
    %
    % System Description
    % x_dot = A*x + B*u + E*d + f0
    % y     = C*x + D*u + H*d + g0
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Contributors: Christopher T. Aksland and Phil Renkert
    % Association: University of Illionis at Urbana-Champaign
    % Contact: aksland2@illinois.edu and renkert2@illinois.edu
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % potential improvements:
    % f0 and g0 should be moved into the linear model class...
    % Finish CalcState and CalcOutput
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties      
        A_sym  (:,:) {mustBeNumericOrSym}
        B_sym  (:,:) {mustBeNumericOrSym}
        E_sym  (:,:) {mustBeNumericOrSym}
        
        C_sym  (:,:) {mustBeNumericOrSym}
        D_sym  (:,:) {mustBeNumericOrSym}
        H_sym  (:,:) {mustBeNumericOrSym}
        
        f0 (:,1) {mustBeNumericOrSym}
        g0 (:,1) {mustBeNumericOrSym}
    end
        
    properties (Access = private)   
        A_func  function_handle {mustBeScalarOrEmpty}
        B_func  function_handle {mustBeScalarOrEmpty}
        E_func  function_handle {mustBeScalarOrEmpty}
        
        C_func  function_handle {mustBeScalarOrEmpty}
        D_func  function_handle {mustBeScalarOrEmpty}
        H_func  function_handle {mustBeScalarOrEmpty}
    end
    
    properties (Constant, Access = private)
        N_mats = 6
        syms_props = ["A_sym", "B_sym", "E_sym", "C_sym", "D_sym", "H_sym"];
        func_props = ["A_func", "B_func", "E_func", "C_func", "D_func", "H_func"];
    end

    methods
        function obj = LinearModel(varargin) % constructor stores the linear matrix information
            if nargin == 6
                obj.A_sym = varargin{1};
                obj.B_sym = varargin{2};
                obj.E_sym = varargin{3};
                obj.C_sym = varargin{4};
                obj.D_sym = varargin{5};
                obj.H_sym = varargin{6};
                
                obj.Nx = size(obj.A_sym, 2);
                obj.Nu = size(obj.B_sym, 2);
                obj.Nd = size(obj.E_sym, 2);
                obj.Ny = size(obj.C_sym, 1);
                
                obj.f0 = zeros(obj.Nx,1);
                obj.g0 = zeros(obj.Ny,1);
                
                obj.init();
            end
        end
        
        init(obj)       
        setLinearCalcFuncs(obj)       
        setFGSym(obj)
        [A,B,E,C,D,H] = CalcMatrices(obj,x,u,d,params)
        
    end
end

