function createSysGraph(obj)
[obj.Graph, obj.extrinsicProps] = Combine(obj.Components, obj.ConnectP);
end