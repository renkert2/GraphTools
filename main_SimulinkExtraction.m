clear all; close all; clc

%% Extract Simulink Models
 
[Comps,ConnectP,G] = autoGraphDefine('ToySystem',1);

%% Plot Component Graphs
figure
for i = 1:length(Comps)
    subplot(ceil(length(Comps)/2),2,i)
    plot(Comps(i).Graph,'NodeColor','r','EdgeColor','b');
    title(Comps(i).Name)
end

%% Build System Graph and Model
SystemGraph = Combine(Comps,ConnectP);
SysModel = GraphModel(SystemGraph);

Comps(2).HTC = 10; % comment
SysModel.init();

%% Plot System Graph and Model

figure
plot(SysModel,'NodeColor','r','EdgeColor','b','DetailedLabels','States','DetailedLabels','Disturbances');
figure
plot(SystemGraph,'NodeColor','r','EdgeColor','b');
figure
plot(SysModel,'NodeColor','r','EdgeColor','b','DetailedLabels','All');