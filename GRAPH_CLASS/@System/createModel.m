function model = createModel(obj, varargin)
% Creates GraphModel from obj.Graph and stores
% it in obj.Model.  Pass additional arguments
% to the GraphModel constructor with varargin

obj.Model = GraphModel(obj.Graph, varargin{:});
model = obj.Model;
end