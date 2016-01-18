function [] = DisplayCostFunction(cost,fig,figdata)
%% DisplayCostFunction shows the cost function
% Plots cost function value against iteration
%
% Created by: Victor Bergelin and Emelie Karlsson
% 
% Version number: 1.0
% 0.01: minimal usage implementation for one instance and phase
% 1.0: Clean and commented code

try
    % Set current plot
    h1 = subplot(fig);
    
    % Visualize costs:
    cla reset
    
    set(gca,'FontSize',10);
    
    title(sprintf('Current cost: %s\nIt: %s, Phase: %s', num2str(sum(cost(end,:)),'%10.5e'), num2str(figdata.iteration),  figdata.phase));
    xlabel('Number of iterations');
    ylabel('CostFunction value (LOG)');
    
    hold(fig, 'on')
    h=plot(log(cost+1));
    legend(h,'Total','Depen', 'Overlap','Bounds', ...
        'Location','West');
    hold(fig,'off')
    
    % Set axis:
    axisVal = axis;
    axisVal(3)=max(min(log(cost(end,1))-5,30),0);
    axis(fig,axisVal);
    
catch err
    rethrow(err)
    fprintf(obj.Logfile, getReport(err,'extended'));
end

end

