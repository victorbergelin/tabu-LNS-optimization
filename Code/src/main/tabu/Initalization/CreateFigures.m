function [top,bot_left, bot_right,figdata] = CreateFigures(data,titlestr)
%% Initialize figures for solution plot in tabumain
%
% Created by: Emelie Karlsson
% Date created: 28/10/2015
% Version number 1.0
%
% Linköping University, Linköping

try
    close all;

    fig1 = figure('Visible','on','Position',[10,100,1400,1000]);

    top = subplot(2,2,1);
    bot_left = subplot(2,2,3);
    bot_right = subplot(2,2,[2 4]);

    set (fig1, 'Units', 'normalized','Position', [0,0,1,1]);

    % Make x-axis length of max end of tasks
    figdata.L = 1.1*max(data.tasks(:,3));

    % Make y-axis no of timelines
    figdata.T = 1.1*max(data.tasks(:,4));

    titlestring = ['Dataset:',titlestr{1},'. Ts:',titlestr{2},'. Tls:', ...
        titlestr{3},'. Deps:',titlestr{4},'. Phases:',titlestr{5}];

    suptitle(titlestring)

catch err
    rethrow(err)
    fprintf(obj.Logfile, getReport(err,'extended'));
end

end
