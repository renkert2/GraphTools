function init_super(obj)
init(obj); % Optionally defined by subclasses
createSysGraph(obj); % Calls Component.Combine to create system graph and resulting extrinsic props
end