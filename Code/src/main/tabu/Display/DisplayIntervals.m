function [] = DisplayIntervals(data,fig,figdata)
%% DisplayIntervals shows the task intervals
%
% Created by: Victor Bergelin and Emelie Karlsson
% 
% Version number: 1.0
% 0.01: Simple, working implementation
% 1.0: Clean and commented code

% Display the intervals for the tasks

% Set current plot
subplot(fig);

% No of timesteps
L = figdata.L;

% No of timelines
T = figdata.T;

% Visualize testdata:
cla reset

axis([-0.1*L,1.1*L,0,T+1])
set(gca,'FontSize',10);
title('Plot of task intervals');
xlabel('Time');
ylabel('Timeline');

Color = [1 1 0.1; 1 0 1; 0 1 1; 1 0 0; 0 1 0; 0 0 1; 0.5 0.5 0.5; 0 0 0];
% For all tasks
for i=1:size(data.tasks,1)
    line([data.tasks(i,2) data.tasks(i,3)],[data.tasks(i,4) data.tasks(i,4)],'Color',Color(1+mod(i,8),:), 'Marker','.','LineWidth', 2);
    line([data.tasks(i,2) data.tasks(i,2)], [data.tasks(i,4)+0.1 data.tasks(i,4)-0.1], 'Color',Color(1+mod(i,8),:));
    line([data.tasks(i,3) data.tasks(i,3)], [data.tasks(i,4)+0.1 data.tasks(i,4)-0.1], 'Color',Color(1+mod(i,8),:));
end


end

