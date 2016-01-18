function [] = DisplayCurrentSolution(data,fig,figdata)
%% DisplayCurrentSolution shows the current solution
% Displays the temporary solution on a graphical timeline
%
% Created by: Victor Bergelin and Emelie Karlsson
% 
% Version number: 1.0
% 0.01: Working implementation
% 1.0: Clean and commented code

% Set current plot
subplot(fig);

% No of timesteps
L = figdata.L;

% No of timelines
T = figdata.T;

% Visualisera testdata:
cla reset


axis([-0.01*L,1.01*L,0,T+1])
set(gca,'FontSize',10);
title('Plot of timelines and tasks');
xlabel('Time');
ylabel('Timeline');
hold(fig, 'on')
Color = [1 1 0.1; 1 0 1; 0 1 1; 1 0 0; 0 1 0; 0 0 1; 0.5 0.5 0.5; 0 0 0];

% For all tasks, display current placement
for i=1:size(data.tasks,1)
    timeline = data.tasks(i,4);
    start_task = data.tasks(i,6);
    end_task = start_task + data.tasks(i,5);
    
    line([start_task start_task], [timeline+0.1 timeline-0.1], 'Color',Color(1+mod(i,8),:));
    line([end_task end_task], [timeline+0.1 timeline-0.1], 'Color',Color(1+mod(i,8),:));
    line([start_task end_task], [timeline timeline], ...
        'Color',Color(1+mod(i,8),:), 'LineWidth', 2);
end

% Visualize depencencies
for i=1:size(data.dependencies,1)
    
    % Tasks in dependecy
    task_1 = data.dependencies(i,1);
    task_2 = data.dependencies(i,2);

    task1_start = data.tasks(task_1,6);
    task1_length = data.tasks(task_1,5);
    task2_start = data.tasks(task_2,6);

    x_start = task1_start+task1_length;
    x_end = task2_start;
    y_start = data.tasks(task_1,4);
    y_end = data.tasks(task_2,4);


    X = [x_start x_end];
    Y = [y_start y_end];
    % intermediate point (you have to choose your own)
    Xi = mean(X);
    Yi = mean(Y) + 0.5*(y_end-y_start)+0.1;
    
    Xa = [X(1) Xi X(2)];
    Ya = [Y(1) Yi Y(2)];
    
    t  = 1:numel(Xa);
    ts = linspace(min(t),max(t),numel(Xa)*10); % has to be a fine grid
    xx = spline(t,Xa,ts);
    yy = spline(t,Ya,ts);
    
    plot(xx,yy); %hold on; % curve
    
    
    plot(x_end,y_end,'Marker','p','Color',[.88 .48 0],'MarkerSize',10)
end

hold(fig, 'off')

end


