function h = plot(obj,varargin)
% basic digraph plotting.
E_Augmented = obj.E; % edge matrix
try % try to augment the edge matrix to include external edges
    E_idx = arrayfun(@(x) find(x==obj.InternalVertices),vertcat(obj.ExternalEdges.HeadVertex)); % index of vertices with external edges
    Eext = [[obj.v_tot+1:1:obj.v_tot+obj.Nee]' E_idx]; % edge matrix of external edges
    E_Augmented = [E_Augmented; Eext]; % augment E matrix with external edges
    skipPlotExt = 0;
catch
    skipPlotExt = 1;
end
G = digraph(E_Augmented(:,1),E_Augmented(:,2)); % make digraph
h = plot(G,varargin{:}); % plot digraph
labeledge(h,E_Augmented(:,1)',E_Augmented(:,2)',[1:obj.Ne, 1:obj.Nee]); % edge lables
highlight(h,[obj.Nv+1:1:obj.v_tot],'NodeColor','w') % remove external vertices
xLoc = h.XData(obj.Nv+1:1:obj.v_tot); yLoc = h.YData(obj.Nv+1:1:obj.v_tot); % get external vertex location
hold on; scatter(xLoc,yLoc,5*h.MarkerSize,'MarkerEdgeColor',h.NodeColor(1,:)); hold off; % add external vertices back
if ~skipPlotExt
    highlight(h,reshape(Eext',1,[]),'LineStyle','--') % make external edges dashed
    highlight(h,[obj.v_tot+1:1:obj.v_tot+length(E_idx)],'NodeLabelColor','w','NodeColor','w') % remove augmented external edge tail vertices and labels
    xLoc = [ h.XData(Eext(:,1))]; yLoc = [ h.YData(Eext(:,1))]; % get external edge tail vertex location
end
hold on; scatter(xLoc,yLoc,5*h.MarkerSize,'MarkerEdgeColor',h.EdgeColor(1,:)); hold off; % plot external edge tail vertices
end