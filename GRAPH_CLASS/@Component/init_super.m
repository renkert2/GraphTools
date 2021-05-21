function init_super(obj)
obj.init(); % Concrete method that can be overriden by subclasses
obj.DefineComponent();
obj.DefineChildren();
obj.DefineSymParams();
end