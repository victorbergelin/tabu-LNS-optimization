% Created by: Isak Bohman, 2015

function GUI

close all;

% Initialize global variables.
TimelineSolution = [];
attributes = [];
DependencyMatrix = [];
DependencyAttribute = [];
% xx_mater contain multiple data sets.
TimelineSolution_mater = [];
attributes_mater = [];
DependencyMatrix_mater = [];
DependencyAttribute_mater = [];

% Modified variables for the demands of the group.
Modified_DependencyMatrix = [];
Modified_DependencyMatrix_mater = [];

% Colour matrices for preserving colors of printed objects.
Task_color_matrix = [];
Dep_color_matrix = [];
Task_timeline_color_matrix = [];

% testdataiterator = ones(3,1);
testdataiterator = 1;

% Number of tasks
N = 100;

% Number of time steps
L = 1000000000;
L_prev = L;
% Number of time-lines
T = 10;
T_prev = T;

% Number of data sets
Num_data = 1;

% Number of dependencies
Ndeps=20;

% the level of occupancy of time-lines
occupancy = 0.5;

% No intra-time-line dependencies?
constrain = 0;

% Number of dependencies per task
dependency_level = Ndeps/N;

% Use dependency chains or not?
chains = 0;

% Various standard deviations (scaling factors).

% Temporal distribution of dependencies standard deviation. Not used.
std1 = 0.5;
% Maximum time between dependent tasks standard deviation
std2 = 0.5;
% Minimum starting time distribution standard deviation
std3 = 0.5;
% Task length standard deviation
std4 = 0.5;
% Deadline distribution standard deviation
std5 = 0.5;
% Minimum time between dependent tasks standard deviation
std6 = 0.5;
% Task spacing distribution standard deviation
std7 = 0.8;
% Task distribution across time-lines standard deviation.
std8 = 0.5;
% Spatial distribution of dependencies standard deviation. Not used.
std9 = 0.5;

% Various expected values (scaling factors).
% Minimum starting time distribution expected value
mu1 = 0.5;
% Maximum time betwen dependent tasks expected value
mu2 = 0.5;
% Deadline distribution expected value
mu3 = 0.5;
% Minimum time betwen dependent tasks expected value
mu4 = 0.5;

% Various standard settings

std_low = 0.8;
mu_low = 0.1;

% Rectify dependency probabilities based on task lengths.

rectify = 0;

% The minimum and maximum number of tasks allowed.

max_tasks = 10000;
min_tasks = 20;

% Settings for the Simplified2 mode

% The average number of dependencies per task
min_dependency_level = 2;
max_dependency_level = 4;

min_occupancy_level = 0.4;
max_occupancy_level = 0.7;


% GUI colours

color1 = [0.3 0.8 0.3];
color2 = [0.8 0.3 0.3];
color3 = [0.3 0.7 1];

% GUI positioning

button_pos = [0.725,0.05,0.2,0.05];
button_pos2 = button_pos + [0 0.05 0 0];
button_pos3 = button_pos + [0 0.1 0 0];
button_pos4 = button_pos - [0.225 0 0 0];

% button_pos2 = [0.75,0.15,0.2,0.05];
% button_pos3 = [0.75,0.2,0.2,0.05];

text_pos1 = [0.74,0.45,0.13,0.02];
text_pos2 = text_pos1-[0 0.05 0 0];
text_pos3 = text_pos1-[0 0.1 0 0];
text_pos4 = text_pos1-[0 0.15 0 0];
text_pos5 = text_pos1-[0 0.2 0 0];

edit_pos1 = [0.88 0.45 0.05 0.02];
edit_pos2 = edit_pos1-[0 0.05 0 0];
edit_pos3 = edit_pos1-[0 0.1 0 0];
edit_pos4 = edit_pos1-[0 0.15 0 0];
edit_pos5 = edit_pos1-[0 0.2 0 0];


% Define function objects for the distribution functions.
norm_distr = @(mu, sigma) normal_distribution(mu, sigma);
unif_distr = @(mu, sigma) uniform_distribution(mu, sigma);
chi2_distr = @(mu, sigma) chi2_distribution(mu, sigma);

% Function objects for functions to be used.
genlistoflst = @(L, N, occupancy, distrib4, std4, std7, distrib7) genlistoflengths_startpts(L, N, occupancy, distrib4, std4, std7, distrib7);
gentasks = @( Ntasks, Ntimelines, distrib8, std8 ) generateNumberoftasksinTimelinevector( Ntasks, Ntimelines, distrib8, std8 );
gendepmatrix = @(TimelineSolution, Ndependencies, rectify,constrain,L, chains) Generatedependencymatrix(TimelineSolution, Ndependencies, rectify,constrain,L, chains);
gendepattr = @(TimelineSolution,DependencyMatrix, L, N, T, distrib6, std6, mu4, std2, distrib2, mu2) Generatedependencyattributes(TimelineSolution,DependencyMatrix, L, N, T, distrib6, std6, mu4, std2, distrib2, mu2);


% Various choices of distributions. 
% The numbering here corresponds to the numbering used for standard deviations
distrib1 = norm_distr;
distrib2 = norm_distr;
distrib3 = norm_distr;
distrib4 = chi2_distr;
distrib5 = norm_distr;
distrib6 = norm_distr;
distrib7 = chi2_distr;
distrib8 = norm_distr;
distrib9 = norm_distr;

% Numerical value indicating choices of distributions. 0 = normal, 1 =
% uniform, 2 = chi-squared.
dist_sel1 = 0;
dist_sel2 = 0;
dist_sel3 = 0;
dist_sel4 = 2;
dist_sel5 = 0;
dist_sel6 = 0;
dist_sel7 = 2;
dist_sel8 = 0;
dist_sel9 = 0;

% Mode selector: 1 for extended, 2 for dummie, 3 for dummies 2.
mode = 1;

% Selectors for the dummy mode
density = 0;
dep_intervals = 0;
attr_intervals = 0;
dep_intensity = 0;

difficulty='A';
difficulty_number = 25;

% Selector for the dummy2 mode.

dummy2_selector = 1;

% Continuous or discrete difficulties?
diff_type = 0;

% Selector for the dummies mode

dummies_selector = 1;

%%%%%%%%%% Figure displaying tasks and dependencies
f2 = figure('Visible','on','Position',[10,100,1000,800]);
set(gcf,'numbertitle','off','name','Window 1')

% Checkbox for activating the display of dependencies.
checkbox = uicontrol(f2,'Style','checkbox',...
    'String','Display dependencies (dot denotes the endpoint of a dependency)',...
    'Units','normalized', ...
    'Value',0,'Position',[0.3 0.02 0.4 0.05], ...
    'Callback', @checkbox_callback);

% Callback for the checkbox above.
    function checkbox_callback(hObject, eventdata, handles)
        if (get(hObject,'Value') == 1)
            
            print_correct();
            
            print_arrows();
            
        else
            
            print_correct();
        end
    end

% Axes object for the dusplay of tasks and dependencies.
ha2 = axes('Units','pixels', 'Units','normalized','Position',[0.05,0.1,0.9,0.85]);

%%%%%%%%%% Figure exhibiting task deadlines and minimum starting times.
f3 = figure('Visible','on','Position',[10,100,800,600]);
set(gcf,'numbertitle','off','name','Window 2')

% Axes object for the display of task deadlines and minimum starting times.
ha3 = axes('Units','pixels', 'Units','normalized','Position',[0.05,0.1,0.7,0.85]);

% Listbox for selecting a time-line.
listbox1 = uicontrol(f3,'Style','listbox',...
    'Units','normalized',...
    'Position',[0.78 0.1 0.2 0.5],'Value',1, ...
    'Callback', @listbox1_callback);

% Text for the listbox above
listbox1_text = uicontrol('Style','text','String','Timeline selector', 'Units','normalized',...
    'Position',[0.78,0.6,0.2,0.02]);

% Current time-line selection.
timeline_selection = 1;

    function listbox1_callback(hObject, eventdata, handles)
        index_selected = get(hObject,'Value');
        timeline_selection = index_selected;
%         print_correct();
        print_selection();
    end

%%%%%%%%%% Figure displaying dependency attributes
f4 = figure('Visible','on','Position',[10,100,950,600]);
set(gcf,'numbertitle','off','name','Window 3')

ha4 = axes('Units','pixels', 'Units','normalized','Position',[0.05,0.1,0.9,0.85]);

%%%%%%%%%% Figure for the main GUI
f = figure('Visible','on','Position',[160,200,1600,800]);
set(gcf,'numbertitle','off','name','Window 4')

% Data creation panel.
p = uipanel('Title','Data creation',...
    'Position',[0.04 0.02 0.92 0.93]);

% Button for the creation of test data
testdatagen    = uicontrol('Style','pushbutton',...
    'String','Create test data', 'Units','normalized','Position',button_pos2,...
    'Callback',@testdatagen_callback);

% Button for creating multiple test data with different settings at once
make_multi    = uicontrol('Style','pushbutton',...
    'String','Make and save multiple test data', 'Units','normalized','Position',button_pos4,...
    'Callback',@make_multi_callback);

% Text box for editing the number of time steps
txtbox1 = uicontrol('Style','edit',...
    'String',num2str(L), 'Units','normalized',...
    'Position',edit_pos4,...
    'Callback',@txt1_callback);

    function txt1_callback(source,eventdata)
        L_prel = str2num(get(txtbox1,'String'));
        if isnumeric(L_prel) && ~isempty(L_prel) && ...
                L_prel > 0 && L_prel == floor(L_prel)
            
            L = L_prel;
        else
            set(txtbox1,'String',num2str(L));
            
        end
    end

% Text box for editing the number of time-lines
txtbox2 = uicontrol('Style','edit',...
    'String',num2str(T), 'Units','normalized',...
    'Position',edit_pos3,...
    'Callback',@txt2_callback);

    function txt2_callback(source,eventdata)
        T_prel = str2num(get(txtbox2,'String'));
        if isnumeric(T_prel) && ~isempty(T_prel) && ...
                T_prel > 0 && T_prel == floor(T_prel)
            
            T = T_prel;
        else
            set(txtbox2,'String',num2str(T));
            
        end
    end

% Text box for editing the number of tasks
txtbox3 = uicontrol('Style','edit',...
    'String',num2str(N), 'Units','normalized',...
    'Position',edit_pos2,...
    'Callback',@txt3_callback);

    function txt3_callback(source,eventdata)
        N_prel = str2num(get(txtbox3,'String'));
        if isnumeric(N_prel) && ~isempty(N_prel) && ...
                N_prel > 2 && N_prel == floor(N_prel)
            
            N = min(N_prel,max_tasks);
            
        end
        set(txtbox3,'String',num2str(N));
    end

% Text box for editing the number of data copies to be created.
txtbox4 = uicontrol('Style','edit',...
    'String',num2str(Num_data), 'Units','normalized',...
    'Position',edit_pos1,...
    'Callback',@txt4_callback);

    function txt4_callback(source,eventdata)
        Num_data_prel = str2num(get(txtbox4,'String'));
        if isnumeric(Num_data_prel) && ~isempty(Num_data_prel) && ...
                Num_data_prel > 0 && Num_data_prel == floor(Num_data_prel)
            
            Num_data = Num_data_prel;
        else
            set(txtbox4,'String',num2str(Num_data));
            
        end
    end

% Text box for editing the number of dependencies
txtbox5 = uicontrol('Style','edit',...
    'String',num2str(Ndeps), 'Units','normalized',...
    'Position',edit_pos5,...
    'Callback',@txt5_callback);

    function txt5_callback(source,eventdata)
        Ndeps_prel = str2num(get(txtbox5,'String'));
        if isnumeric(Ndeps_prel) && ~isempty(Ndeps_prel) && ...
                Ndeps_prel >= 0 && Ndeps_prel == floor(Ndeps_prel)
            
            Ndeps = Ndeps_prel;
        else
            set(txtbox5,'String',num2str(Ndeps));
            
        end
    end

static_text1 = uicontrol('Style','text','String','Number of data sets:', 'Units','normalized',...
    'Position',text_pos1);

static_text2 = uicontrol('Style','text','String','Number of tasks (approximately):', 'Units','normalized',...
    'Position',text_pos2);

static_text3 = uicontrol('Style','text','String','Number of time-lines:', 'Units','normalized',...
    'Position',text_pos3);

static_text4 = uicontrol('Style','text','String','Number of time steps:', 'Units','normalized',...
    'Position',text_pos4);

static_text5 = uicontrol('Style','text','String','Number of dependencies:', 'Units','normalized',...
    'Position',text_pos5);

% Button for saving test data when data have been created.
testdatasave    = uicontrol('Style','pushbutton',...
    'String','Save test data', 'Units','normalized','Position',button_pos3,...
    'Callback',@testdatasave_callback);

    function testdatasave_callback(source,eventdata)
        % We save each data set separately
        for data_it=1:Num_data
            % Idea: keep track of which mode we are in, and save
            % accordingly.
            if mode == 1
                % Type X data
                type_string = 'X';
            elseif mode == 2
                % Type Z data
                type_string = 'Z';
            else
                switch dummy2_selector
                    case 1
                        % Type B data
                        type_string = 'B';
%                         type_string = 'A';
                    case 2
                        % Type C data
                        type_string = 'C';
%                         type_string = 'B';
                    case 3
                        % Not used at the moment
                        type_string = 'C';
                    case 4
                        % Not used at the moment
                        type_string = 'D';
                    case 5
                        % Type D data
                        type_string = 'D';
%                         type_string = 'E';
                    case 6
                        % Type A data
                        type_string = 'A';
%                         type_string = 'F';
                end
            end
            
            % The current date
            dateName = datestr(now(),'yyyy-mm-ddTHH-MM-SS');
            
            
            %         dir = strcat('../../../test/testdata/',type_string,num2str(difficulty_number),'_',dateName);
            % dir = strcat('test/testdata/',type_string,num2str(difficulty_number),'_',dateName);
            
            % Directory where test data are saved.
            dir = strcat('test/testdata/',type_string,num2str(difficulty_number),'_',num2str(data_it),'_',dateName);
            
            % Finally, create the folder if it doesn't exist already.
            if ~exist(dir, 'dir')
                mkdir(dir);
            end
            
            % tells us if the current folder exist
            bool0 = 0;
            % tells us if the current file exists
            bool1 = 0;
            
            testfile = strcat(dir,'/TimelineSolution','.dat');
            
            if exist(testfile, 'file') == 2
                testdataiterator = testdataiterator + 1;
            else
                testdataiterator = 1;
                bool0 = 1;
                bool1 = 1;
            end
            
            % Must find the right index to add our files.
            while bool1==0
                testfile = strcat(dir,'/Tasks',num2str(testdataiterator), '.dat');
                if exist(testfile, 'file') == 2
                    testdataiterator = testdataiterator + 1;
                else
                    testdataiterator = 1;
                    bool1 = 1;
                end
            end
            
            % Check if there are any data to add
            if ~isempty(TimelineSolution_mater) && ~isempty(attributes_mater) && ~isempty(DependencyMatrix_mater) && ~isempty(DependencyAttribute_mater)
                
                
                if bool0 == 1
                    % Folder is empty.
                    UserFile5 = strcat(dir,'/Testinfo', '.dat');
                    mod_UserFile1 = strcat(dir,'/Tasks', '.dat');
                    mod_UserFile2 = strcat(dir,'/Dependencies', '.dat');
                    mod_UserFile3 = strcat(dir,'/AMPL', '.dat');
                else
                    % Multiple test data already in folder
                    UserFile5 = strcat(dir,'/Testinfo',num2str(testdataiterator), '.dat');
                    mod_UserFile1 = strcat(dir,'/Tasks',num2str(testdataiterator), '.dat');
                    mod_UserFile2 = strcat(dir,'/Dependencies',num2str(testdataiterator), '.dat');
                    mod_UserFile3 = strcat(dir,'/AMPL',num2str(testdataiterator), '.dat');
                end
                
                
                % Add the time-line matrix
                fil1_mod_orig = [TimelineSolution_mater(:,1), attributes_mater(:,1:3), TimelineSolution_mater(:,3) TimelineSolution_mater(:,end)];
                % Add the dependency matrix
                fil2_mod_orig = [Modified_DependencyMatrix_mater(:,1:2),Modified_DependencyMatrix_mater(:,4), DependencyAttribute_mater(:,1:2), DependencyAttribute_mater(:,end)];
                
                % Find the right data set from which we shall save.
                indices1 = find(fil1_mod_orig(:,end) == data_it);
                indices2 = find(fil2_mod_orig(:,end) == data_it);
                
                % Don't save which data set we are at in the files.
                fil1_mod = fil1_mod_orig(indices1,1:end-1);
                fil2_mod = fil2_mod_orig(indices2,1:end-1);
                
                
                % Save test information.
                fil5 = [dummy2_selector, N, L, T, Num_data, Ndeps, occupancy, constrain, rectify, std1, std2, std3, std4, std5, std6, std7, std8, std9, ...
                    mu1, mu2, mu3, mu4, difficulty_number, dist_sel1, dist_sel2, dist_sel3, dist_sel4, dist_sel5, dist_sel6, dist_sel7, dist_sel8, ...
                    dist_sel9]';
                
                
                
                % Save the test data
                save(UserFile5, 'fil5', '-ascii')
                save(mod_UserFile1, 'fil1_mod', '-ascii')
                save(mod_UserFile2, 'fil2_mod', '-ascii')
                createdat(mod_UserFile1,mod_UserFile2, mod_UserFile3);
                
                % Not really necessary at this moment.
                testdataiterator = testdataiterator+1;
            end
        end
    end

% Launch testing GUI. Not used
launch_test_gui_btn    = uicontrol('Style','pushbutton',...
    'String','Launch testing GUI', 'Units','normalized','Position',button_pos,...
    'Callback',@launch_test_gui_callback);

    function launch_test_gui_callback(source,eventdata)
%         close(f3)
        test_gui();
        
    end

% Not used
distribution_group = uibuttongroup(f,'Title','Temporal distribution of dependencies',...
    'Position',[.5 .25 .20 .08]);

% Not used
distr1 = uicontrol(distribution_group,'Style','radiobutton','String','Normal',...
    'Units','normalized',...
    'Position',[.1 .3 .6 .4], ...
    'Callback',@distr1_callback, ...
    'Tag', 'rab1');
% Not used
distr2 = uicontrol(distribution_group,'Style','radiobutton','String','Uniform',...
    'Units','normalized',...
    'Position',[.6 .3 .6 .4], ...
    'Callback',@distr2_callback, ...
    'Tag', 'rab2');
% Not used
    function distr1_callback(source,eventdata)
        distrib1 = norm_distr;
        dist_sel1 = 0;
    end
% Not used
    function distr2_callback(source,eventdata)
        distrib1 = unif_distr;
        dist_sel1 = 1;
    end

set(allchild(distribution_group),'Enable','off');
% Not used
temp_dist_slider = uicontrol(f,'Style','slider',...
                'Min',0.05,'Max',0.95,'Value',std1,...
                'SliderStep',[0.05 0.1], ...
                'Units','normalized',...
                'Position',[0.5 0.15 0.2 0.04], ...
                'Callback',@temp_dist_cb);
% Not used
    function temp_dist_cb(source,eventdata)
        std1 = get(temp_dist_slider,'Value');
    end
% Not used
htext3  = uicontrol('Style','text','String','Standard deviation:', 'Units','normalized',...
    'Position',[0.55,0.195,0.10,0.02]);

set(temp_dist_slider,'Enable','off');
set(htext3,'Enable','off');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Max time between dependent tasks%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
htext21  = uicontrol('Style','text','String','Mean value:', 'Units','normalized',...
    'Position',[0.6,0.395,0.10,0.02]);

htext2  = uicontrol('Style','text','String','Standard deviation:', 'Units','normalized',...
    'Position',[0.5,0.395,0.10,0.02]);

distribution2_group = uibuttongroup(f,'Title','Maximum time between dependent tasks distribution',...
    'Position',[.5 .45 .20 .08], 'BackgroundColor',color1);

distr3 = uicontrol(distribution2_group,'Style','radiobutton','String','Normal',...
    'Units','normalized',...
    'Position',[.1 .3 .6 .4], ...
    'Callback',@distr3_callback, ...
    'Tag', 'rab1', 'BackgroundColor',color1);
distr4 = uicontrol(distribution2_group,'Style','radiobutton','String','Uniform',...
    'Units','normalized',...
    'Position',[.35 .3 .6 .4], ...
    'Callback',@distr4_callback, ...
    'Tag', 'rab2', 'BackgroundColor',color1);

    function distr3_callback(source,eventdata)
        distrib2 = norm_distr;
        dist_sel2 = 0;
    end

    function distr4_callback(source,eventdata)
        distrib2 = unif_distr;
        dist_sel2 = 1;
    end

distr51 = uicontrol(distribution2_group,'Style','radiobutton','String','Chi-squared',...
    'Units','normalized',...
    'Position',[.6 .3 .6 .4], ...
    'Callback',@distr51_callback, ...
    'Tag', 'rab2', 'BackgroundColor',color1);

    function distr51_callback(source,eventdata)
        distrib2 = chi2_distr;
        dist_sel2 = 2;
    end

maxt_slider = uicontrol(f,'Style','slider',...
                'Min',0.05,'Max',0.95,'Value',std2,...
                'SliderStep',[0.05 0.1], ...
                'Units','normalized',...
                'Position',[0.5 0.35 0.1 0.04], ...
                'Callback',@maxt_slider_cb, 'BackgroundColor',color1);
            
    function maxt_slider_cb(source,eventdata)
        std2 = get(maxt_slider,'Value');
    end

maxt2_slider = uicontrol(f,'Style','slider',...
                'Min',0.05,'Max',0.95,'Value',mu2,...
                'SliderStep',[0.05 0.1], ...
                'Units','normalized',...
                'Position',[0.6 0.35 0.1 0.04], ...
                'Callback',@maxt2_slider_cb, 'BackgroundColor',color1);
            
    function maxt2_slider_cb(source,eventdata)
        mu2 = get(maxt2_slider,'Value');
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Min start time distr%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
distribution3_group = uibuttongroup(f,'Title','Minimum starting time distribution',...
    'Position',[.05 .45 .20 .08], 'BackgroundColor',color1);

distr5 = uicontrol(distribution3_group,'Style','radiobutton','String','Normal',...
    'Units','normalized',...
    'Position',[.1 .3 .6 .4], ...
    'Callback',@distr5_callback, ...
    'Tag', 'rab1', 'BackgroundColor',color1);
distr6 = uicontrol(distribution3_group,'Style','radiobutton','String','Uniform',...
    'Units','normalized',...
    'Position',[.35 .3 .6 .4], ...
    'Callback',@distr6_callback, ...
    'Tag', 'rab2', 'BackgroundColor',color1);

    function distr5_callback(source,eventdata)
        distrib3 = norm_distr;
        dist_sel3 = 0;
    end

    function distr6_callback(source,eventdata)
        distrib3 = unif_distr;
        dist_sel3 = 1;
    end

distr7 = uicontrol(distribution3_group,'Style','radiobutton','String','Chi-squared',...
    'Units','normalized',...
    'Position',[.6 .3 .6 .4], ...
    'Callback',@distr7_callback, ...
    'Tag', 'rab2', 'BackgroundColor',color1);

    function distr7_callback(source,eventdata)
        distrib3 = chi2_distr;
        dist_sel3 = 2;
    end

mstext  = uicontrol('Style','text','String','Standard deviation:', 'Units','normalized',...
    'Position',[0.05,0.395,0.1,0.02]);
            
ms_slider = uicontrol(f,'Style','slider',...
                'Min',0.05,'Max',0.95,'Value',std3,...
                'SliderStep',[0.05 0.1], ...
                'Units','normalized',...
                'Position',[0.05 0.35 0.1 0.04], ...
                'Callback',@ms_slider_cb, 'BackgroundColor',color1);
            
    function ms_slider_cb(source,eventdata)
        std3 = get(ms_slider,'Value');
    end

ms2text  = uicontrol('Style','text','String','Mean value:', 'Units','normalized',...
    'Position',[0.15,0.395,0.1,0.02]);
            
ms2_slider = uicontrol(f,'Style','slider',...
                'Min',0.05,'Max',0.95,'Value',mu1,...
                'SliderStep',[0.05 0.1], ...
                'Units','normalized',...
                'Position',[0.15 0.35 0.1 0.04], ...
                'Callback',@ms2_slider_cb, 'BackgroundColor',color1);
            
    function ms2_slider_cb(source,eventdata)
        mu1 = get(ms2_slider,'Value');
    end

%%%%%%%%%%%%%%%%%%%%%%%%%% task length %%%%%%%%%%%%%%%%%%%%%%%%%%%%

tltext  = uicontrol('Style','text','String','Standard deviation:', 'Units','normalized',...
    'Position',[0.325,0.595,0.1,0.02]);
            
tl_slider = uicontrol(f,'Style','slider',...
                'Min',0.05,'Max',0.95,'Value',std4,...
                'SliderStep',[0.05 0.1], ...
                'Units','normalized',...
                'Position',[0.275 0.55 0.2 0.04], ...
                'Callback',@tl_slider_cb, 'BackgroundColor',color1);
            
    function tl_slider_cb(source,eventdata)
        std4 = get(tl_slider,'Value');
    end

distribution4_group = uibuttongroup(f,'Title','Task length distribution',...
    'Position',[.275 .65 .20 .08], 'BackgroundColor',color1);

tlength_distr1 = uicontrol(distribution4_group,'Style','radiobutton','String','Normal',...
    'Units','normalized',...
    'Position',[.1 .3 .6 .4], ...
    'Callback',@tlength_distr1_callback, ...
    'Tag', 'rab_mode1', 'BackgroundColor',color1);

    function tlength_distr1_callback(source,eventdata)
        distrib4 = norm_distr;
        dist_sel4 = 0;
    end

tlength_distr2 = uicontrol(distribution4_group,'Style','radiobutton','String','Uniform',...
    'Units','normalized',...
    'Position',[.35 .3 .6 .4], ...
    'Callback',@tlength_distr2_callback, ...
    'Tag', 'rab_mode2', 'BackgroundColor',color1);

    function tlength_distr2_callback(source,eventdata)
        distrib4 = unif_distr;
        dist_sel4 = 1;
    end

tlength_distr3 = uicontrol(distribution4_group,'Style','radiobutton','String','Chi-squared',...
    'Units','normalized',...
    'Position',[.6 .3 .6 .4], ...
    'Callback',@tlength_distr3_callback, ...
    'Tag', 'rab_mode2', 'BackgroundColor',color1);

    function tlength_distr3_callback(source,eventdata)
        distrib4 = chi2_distr;
        dist_sel4 = 2;
    end

% Default to chi2 distribution.
set(tlength_distr3,'Value',1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Rectify probabilities %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

correct_checkbox = uicontrol(f,'Style','checkbox',...
                'String','Rectify dependency probabilities based on task lengths',...
                'Units','normalized', ...
                'Value',0,'Position',[0.275 0.76 0.2 0.02], ...
                'Callback', @correct_checkbox_callback, 'BackgroundColor',color1);
            
    function correct_checkbox_callback(hObject, eventdata, handles)
        if (get(hObject,'Value') == 1)
            rectify = 1;
        else
            rectify = 0;
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Constrain dependencies %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

constrain_checkbox = uicontrol(f,'Style','checkbox',...
                'String','Constrain dependencies to stay within a single time-line',...
                'Units','normalized', ...
                'Value',0,'Position',[0.275 0.78 0.2 0.02], ...
                'Callback', @constrain_checkbox_callback, 'BackgroundColor',color1);
            
    function constrain_checkbox_callback(hObject, eventdata, handles)
        if (get(hObject,'Value') == 1)
            constrain = 1;
        else
            constrain = 0;
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Utilizing of dependencies %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

chains_checkbox = uicontrol(f,'Style','checkbox',...
                'String','Utilize dependency chains',...
                'Units','normalized', ...
                'Value',0,'Position',[0.275 0.80 0.2 0.02], ...
                'Callback', @chains_checkbox_callback, 'BackgroundColor',color1);
            
    function chains_checkbox_callback(hObject, eventdata, handles)
        if (get(hObject,'Value') == 1)
            chains = 1;
        else
            chains = 0;
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%% deadline distribution %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

distribution5_group = uibuttongroup(f,'Title','Deadline distribution',...
    'Position',[.275 .45 .20 .08], 'BackgroundColor',color1);

dead_distr1 = uicontrol(distribution5_group,'Style','radiobutton','String','Normal',...
    'Units','normalized',...
    'Position',[.1 .3 .6 .4], ...
    'Callback',@dead_distr1_callback, ...
    'Tag', 'rab_mode1', 'BackgroundColor',color1);

    function dead_distr1_callback(source,eventdata)
        distrib5 = norm_distr;
        dist_sel5 = 0;
    end

dead_distr2 = uicontrol(distribution5_group,'Style','radiobutton','String','Uniform',...
    'Units','normalized',...
    'Position',[.35 .3 .6 .4], ...
    'Callback',@dead_distr2_callback, ...
    'Tag', 'rab_mode2', 'BackgroundColor',color1);

    function dead_distr2_callback(source,eventdata)
        distrib5 = unif_distr;
        dist_sel5 = 1;
    end

dead_distr3 = uicontrol(distribution5_group,'Style','radiobutton','String','Chi-squared',...
    'Units','normalized',...
    'Position',[.6 .3 .6 .4], ...
    'Callback',@dead_distr3_callback, ...
    'Tag', 'rab_mode2', 'BackgroundColor',color1);

    function dead_distr3_callback(source,eventdata)
        distrib5 = chi2_distr;
        dist_sel5 = 2;
    end

ddtext  = uicontrol('Style','text','String','Standard deviation:', 'Units','normalized',...
    'Position',[0.275,0.395,0.1,0.02]);
            
dd_slider = uicontrol(f,'Style','slider',...
                'Min',0.05,'Max',0.95,'Value',std5,...
                'SliderStep',[0.05 0.1], ...
                'Units','normalized',...
                'Position',[0.275 0.35 0.1 0.04], ...
                'Callback',@dd_slider_cb, 'BackgroundColor',color1);
            
    function dd_slider_cb(source,eventdata)
        std5 = get(dd_slider,'Value');
    end

ddtext2  = uicontrol('Style','text','String','Mean value:', 'Units','normalized',...
    'Position',[0.375,0.395,0.1,0.02]);
            
dd2_slider = uicontrol(f,'Style','slider',...
                'Min',0.05,'Max',0.95,'Value',mu3,...
                'SliderStep',[0.05 0.1], ...
                'Units','normalized',...
                'Position',[0.375 0.35 0.1 0.04], ...
                'Callback',@dd2_slider_cb, 'BackgroundColor',color1);
            
    function dd2_slider_cb(source,eventdata)
        mu3 = get(dd2_slider,'Value');
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%% minimum time between dependent tasks %%%%%%%%%%%%%%%%%%%%%%
htext1  = uicontrol('Style','text','String','Standard deviation:', 'Units','normalized',...
    'Position',[0.5,0.595,0.10,0.02]);
htext12  = uicontrol('Style','text','String','Mean value:', 'Units','normalized',...
    'Position',[0.6,0.595,0.10,0.02]);

distribution6_group = uibuttongroup(f,'Title','Minimum time between dependent tasks distribution',...
    'Position',[.5 .65 .20 .08], 'BackgroundColor',color1);

mint_distr1 = uicontrol(distribution6_group,'Style','radiobutton','String','Normal',...
    'Units','normalized',...
    'Position',[.1 .3 .6 .4], ...
    'Callback',@mint_distr1_callback, ...
    'Tag', 'rab_mode1', 'BackgroundColor',color1);

    function mint_distr1_callback(source,eventdata)
        distrib6 = norm_distr;
        dist_sel6 = 0;
    end

mint_distr2 = uicontrol(distribution6_group,'Style','radiobutton','String','Uniform',...
    'Units','normalized',...
    'Position',[.35 .3 .6 .4], ...
    'Callback',@mint_distr2_callback, ...
    'Tag', 'rab_mode2', 'BackgroundColor',color1);

    function mint_distr2_callback(source,eventdata)
        distrib6 = unif_distr;
        dist_sel6 = 1;
    end

mint_distr3 = uicontrol(distribution6_group,'Style','radiobutton','String','Chi-squared',...
    'Units','normalized',...
    'Position',[.6 .3 .6 .4], ...
    'Callback',@mint_distr3_callback, ...
    'Tag', 'rab_mode2', 'BackgroundColor',color1);

    function mint_distr3_callback(source,eventdata)
        distrib6 = chi2_distr;
        dist_sel6 = 2;
    end

mint_slider = uicontrol(f,'Style','slider',...
                'Min',0.05,'Max',0.95,'Value',std6,...
                'SliderStep',[0.05 0.1], ...
                'Units','normalized',...
                'Position',[0.5 0.55 0.1 0.04], ...
                'Callback',@mint_slider_cb, 'BackgroundColor',color1);
            
    function mint_slider_cb(source,eventdata)
        std6 = get(mint_slider,'Value');
    end

mint2_slider = uicontrol(f,'Style','slider',...
                'Min',0.05,'Max',0.95,'Value',mu4,...
                'SliderStep',[0.05 0.1], ...
                'Units','normalized',...
                'Position',[0.6 0.55 0.1 0.04], ...
                'Callback',@mint2_slider_cb, 'BackgroundColor',color1);
            
    function mint2_slider_cb(source,eventdata)
        mu4 = get(mint2_slider,'Value');
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Task spacing distribution %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
distribution7_group = uibuttongroup(f,'Title','Task spacing distribution',...
    'Position',[.05 .65 .20 .08], 'BackgroundColor',color1);

mode_distr1 = uicontrol(distribution7_group,'Style','radiobutton','String','Normal',...
    'Units','normalized',...
    'Position',[.1 .3 .6 .4], ...
    'Callback',@mode_distr1_callback, ...
    'Tag', 'rab_mode1', 'BackgroundColor',color1);

    function mode_distr1_callback(source,eventdata)
        distrib7 = norm_distr;
        dist_sel7 = 0;
    end

mode_distr2 = uicontrol(distribution7_group,'Style','radiobutton','String','Uniform',...
    'Units','normalized',...
    'Position',[.35 .3 .6 .4], ...
    'Callback',@mode_distr2_callback, ...
    'Tag', 'rab_mode2', 'BackgroundColor',color1);

    function mode_distr2_callback(source,eventdata)
        distrib7 = unif_distr;
        dist_sel7 = 1;
    end

mode_distr3 = uicontrol(distribution7_group,'Style','radiobutton','String','Chi-squared',...
    'Units','normalized',...
    'Position',[.6 .3 .6 .4], ...
    'Callback',@mode_distr3_callback, ...
    'Tag', 'rab_mode2', 'BackgroundColor',color1);

    function mode_distr3_callback(source,eventdata)
        distrib7 = chi2_distr;
        dist_sel7 = 2;
    end

set(mode_distr3,'Value',1);

mode_std_slider = uicontrol(f,'Style','slider',...
    'Min',0.05,'Max',0.95,'Value',std7,...
    'SliderStep',[0.05 0.1], ...
    'Units','normalized',...
    'Position',[0.05 0.55 0.2 0.04], ...
    'Callback',@mode_std_cb, 'BackgroundColor',color1);

    function mode_std_cb(source,eventdata)
        std7 = get(mode_std_slider,'Value');
    end

htext8  = uicontrol('Style','text','String','Standard deviation:', 'Units','normalized',...
    'Position',[0.1,0.595,0.1,0.02]);
%%%%%%%%%%%%%%%%%%%%%%% Mode selector %%%%%%%%%%%%%%%%%%%%%%%%%%%%
mode_selector = uibuttongroup(f,'Title','Mode Selector',...
    'Position',[.05 .85 .20 .08]);

mode_btn1 = uicontrol(mode_selector,'Style','radiobutton','String','Manual',...
    'Units','normalized',...
    'Position',[.05 .3 .6 .4], ...
    'Callback',@mode_btn1_callback, ...
    'Tag', 'rab_mode1');

mode_btn2 = uicontrol(mode_selector,'Style','radiobutton','String','Simplified',...
    'Units','normalized',...
    'Position',[.27 .3 .47 .4], ...
    'Callback',@mode_btn2_callback, ...
    'Tag', 'rab_mode2');

mode_btn3 = uicontrol(mode_selector,'Style','radiobutton','String','Further simplified',...
    'Units','normalized',...
    'Position',[.53 .3 .6 .4], ...
    'Callback',@mode_btn3_callback, ...
    'Tag', 'rab_mode3');

%% Simple GUI: dependencies %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dep_group = uibuttongroup(f,'Title','Dependencies intensity',...
    'Position',[.725 .65 .20 .08], 'BackgroundColor',color2);

dep_low = uicontrol(dep_group,'Style','radiobutton','String','Low',...
    'Units','normalized',...
    'Position',[.1 .3 .6 .4], ...
    'Callback',@dep_low_callback, ...
    'Tag', 'rab_mode1', 'BackgroundColor',color2);

    function dep_low_callback(source,eventdata)
        dependency_level = 0.05;
        Ndeps = round(dependency_level*N);
        dep_intensity = 0;
        set(txtbox5,'String',num2str(Ndeps));
    end

dep_high = uicontrol(dep_group,'Style','radiobutton','String','High',...
    'Units','normalized',...
    'Position',[.6 .3 .6 .4], ...
    'Callback',@dep_high_callback, ...
    'Tag', 'rab_mode2', 'BackgroundColor',color2);

    function dep_high_callback(source,eventdata)
        dependency_level = 0.95;
        Ndeps = round(dependency_level*N);
        dep_intensity = 1;
        set(txtbox5,'String',num2str(Ndeps));
    end

%% Simple GUI: attributes interval %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

attr_group = uibuttongroup(f,'Title','Attributes intervals',...
    'Position',[.725 .75 .20 .08], 'BackgroundColor',color2);

attr_short = uicontrol(attr_group,'Style','radiobutton','String','Short',...
    'Units','normalized',...
    'Position',[.1 .3 .6 .4], ...
    'Callback',@attr_short_callback, ...
    'Tag', 'rab_mode1', 'BackgroundColor',color2);

    function attr_short_callback(source,eventdata)
        
        % min time
        std3 = std_low;
        mu1 = mu_low;
        
        % max time
        std5 = std_low;
        mu3 = mu_low;
        
        attr_intervals=0;
        
        set(ms2_slider,'Value',mu1);
        set(dd2_slider,'Value',mu3);
        set(dd_slider,'Value',std5);
        set(ms_slider,'Value',std3);
    end

attr_long = uicontrol(attr_group,'Style','radiobutton','String','Long',...
    'Units','normalized',...
    'Position',[.6 .3 .6 .4], ...
    'Callback',@attr_long_callback, ...
    'Tag', 'rab_mode2', 'BackgroundColor',color2);

    function attr_long_callback(source,eventdata)
        % min time
        std3 = 0.4;
        mu1 = 0.9;
        
        % max time
        std5 = 0.4;
        mu3 = 0.9;
        
        attr_intervals=1;
        
        set(ms2_slider,'Value',mu1);
        set(dd2_slider,'Value',mu3);
        set(dd_slider,'Value',std5);
        set(ms_slider,'Value',std3);
    end

%% Simple GUI: density of tasks %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

density_group = uibuttongroup(f,'Title','Task density',...
    'Position',[.5 .75 .20 .08], 'BackgroundColor',color2);

density_low = uicontrol(density_group,'Style','radiobutton','String','Low',...
    'Units','normalized',...
    'Position',[.1 .3 .6 .4], ...
    'Callback',@density_low_callback, ...
    'Tag', 'rab_mode1', 'BackgroundColor',color2);

    function density_low_callback(source,eventdata)
        occupancy = 0.1;
        density = 0;
        set(slider5,'Value',occupancy);
    end

density_high = uicontrol(density_group,'Style','radiobutton','String','High',...
    'Units','normalized',...
    'Position',[.6 .3 .6 .4], ...
    'Callback',@density_high_callback, ...
    'Tag', 'rab_mode2', 'BackgroundColor',color2);

    function density_high_callback(source,eventdata)
        occupancy = 0.9;
        density = 1;
        set(slider5,'Value',occupancy);
    end

%% Simple GUI: dependency intervals %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

depattr_group = uibuttongroup(f,'Title','Dependency Attributes intervals',...
    'Position',[.725 .85 .20 .08], 'BackgroundColor',color2);

depattr_short = uicontrol(depattr_group,'Style','radiobutton','String','Short',...
    'Units','normalized',...
    'Position',[.1 .3 .6 .4], ...
    'Callback',@depattr_short_callback, ...
    'Tag', 'rab_mode1', 'BackgroundColor',color2);

    function depattr_short_callback(source,eventdata)
        % min time
        std6 = std_low;
        mu4 = mu_low;
        
        % max time
        std2 = std_low;
        mu2 = mu_low;
        
        dep_intervals=0;
        
        set(mint2_slider,'Value',mu4);
        set(mint_slider,'Value',std6);
        set(maxt_slider,'Value',std2);
        set(maxt2_slider,'Value',mu2);
    end

depattr_long = uicontrol(depattr_group,'Style','radiobutton','String','Long',...
    'Units','normalized',...
    'Position',[.6 .3 .6 .4], ...
    'Callback',@depattr_long_callback, ...
    'Tag', 'rab_mode2', 'BackgroundColor',color2);

    function depattr_long_callback(source,eventdata)
        % min time
        std6 = 0.4;
        mu4 = 0.9;
        
        % max time
        std2 = 0.4;
        mu2 = 0.9;
        
        dep_intervals = 1;
        
        set(mint2_slider,'Value',mu4);
        set(mint_slider,'Value',std6);
        set(maxt_slider,'Value',std2);
        set(maxt2_slider,'Value',mu2);
    end
%% Simple 2 GUI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dummy2_group = uibuttongroup(f,'Title','Further Simplified Mode',...
    'Position',[.725 .5 .20 .12], 'BackgroundColor',color3);

% Many dependencies data
high_deps = uicontrol(dummy2_group,'Style','radiobutton','String','High dependencies',...
    'Units','normalized',...
    'Position',[.05 .7 .6 .2], ...
    'Callback',@high_deps_callback, ...
    'Tag', 'rab_mode1', 'BackgroundColor',color3);

    function high_deps_callback(source,eventdata)
        dependency_level = max_dependency_level;
        Ndeps = round(dependency_level*N);
        dummy2_selector = 1;
        set(txtbox5,'String',num2str(Ndeps));
        
        
        % min time
        std6 = std_low;
        mu4 = mu_low;
        
        % max time
        std2 = std_low;
        mu2 = mu_low;
        
        set(mint2_slider,'Value',mu4);
        set(mint_slider,'Value',std6);
        set(maxt_slider,'Value',std2);
        set(maxt2_slider,'Value',mu2);
        
        
        % min time
        std3 = std_low;
        mu1 = mu_low;
        
        % max time
        std5 = std_low;
        mu3 = mu_low;
        
        
        set(ms2_slider,'Value',mu1);
        set(dd2_slider,'Value',mu3);
        set(dd_slider,'Value',std5);
        set(ms_slider,'Value',std3);
        
        
        occupancy = min_occupancy_level;
        set(slider5,'Value',occupancy);
        
        T=5;
        set(txtbox2,'String',num2str(T));
        
    end

% High occupancy level data
high_density = uicontrol(dummy2_group,'Style','radiobutton','String','High density',...
    'Units','normalized',...
    'Position',[.5 .7 .6 .2], ...
    'Callback',@high_density_callback, ...
    'Tag', 'rab_mode2', 'BackgroundColor',color3);

    function high_density_callback(source,eventdata)
        occupancy = max_occupancy_level;
        dummy2_selector = 2;
        set(slider5,'Value',occupancy);
        
        
        
        % min time
        std6 = std_low;
        mu4 = mu_low;
        
        % max time
        std2 = std_low;
        mu2 = mu_low;
        
        set(mint2_slider,'Value',mu4);
        set(mint_slider,'Value',std6);
        set(maxt_slider,'Value',std2);
        set(maxt2_slider,'Value',mu2);
        
        
        
        % min time
        std3 = std_low;
        mu1 = mu_low;
        
        % max time
        std5 = std_low;
        mu3 = mu_low;
        
        
        set(ms2_slider,'Value',mu1);
        set(dd2_slider,'Value',mu3);
        set(dd_slider,'Value',std5);
        set(ms_slider,'Value',std3);
        
        
        
        dependency_level = min_dependency_level;
        Ndeps = round(dependency_level*N);
        set(txtbox5,'String',num2str(Ndeps));
        
        T=5;
        set(txtbox2,'String',num2str(T));
        
    end

% Long task atributes intervals
high_attr_intervals = uicontrol(dummy2_group,'Style','radiobutton','String','Long attributes intervals',...
    'Units','normalized',...
    'Position',[.05 .4 .6 .2], ...
    'Callback',@high_attr_intervals_callback, ...
    'Tag', 'rab_mode3', 'BackgroundColor',color3);

    function high_attr_intervals_callback(source,eventdata)
        % min time
        std3 = 0.4;
        mu1 = 0.9;
        
        % max time
        std5 = 0.4;
        mu3 = 0.9;
        
        dummy2_selector=3;
        
        set(ms2_slider,'Value',mu1);
        set(dd2_slider,'Value',mu3);
        set(dd_slider,'Value',std5);
        set(ms_slider,'Value',std3);
        
        
        
        % min time
        std6 = std_low;
        mu4 = mu_low;
        
        % max time
        std2 = std_low;
        mu2 = mu_low;

        set(mint2_slider,'Value',mu4);
        set(mint_slider,'Value',std6);
        set(maxt_slider,'Value',std2);
        set(maxt2_slider,'Value',mu2);
        
        
        occupancy = min_occupancy_level;
        set(slider5,'Value',occupancy);
        
        
        
        dependency_level = min_dependency_level;
        Ndeps = round(dependency_level*N);
        set(txtbox5,'String',num2str(Ndeps));
        
        T=5;
        set(txtbox2,'String',num2str(T));
    end

% Long dependency attributes intervals
high_dep_intervals = uicontrol(dummy2_group,'Style','radiobutton','String','Long dependency intervals',...
    'Units','normalized',...
    'Position',[.5 .4 .6 .2], ...
    'Callback',@high_dep_intervals_callback, ...
    'Tag', 'rab_mode4', 'BackgroundColor',color3);

    function high_dep_intervals_callback(source,eventdata)
        % min time
        std6 = 0.4;
        mu4 = 0.9;
        
        % max time
        std2 = 0.4;
        mu2 = 0.9;
        
        dummy2_selector = 4;
        
        set(mint2_slider,'Value',mu4);
        set(mint_slider,'Value',std6);
        set(maxt_slider,'Value',std2);
        set(maxt2_slider,'Value',mu2);
        
        
        
        % min time
        std3 = std_low;
        mu1 = mu_low;
        
        % max time
        std5 = std_low;
        mu3 = mu_low;
        
        
        set(ms2_slider,'Value',mu1);
        set(dd2_slider,'Value',mu3);
        set(dd_slider,'Value',std5);
        set(ms_slider,'Value',std3);
        
        
        occupancy = min_occupancy_level;
        set(slider5,'Value',occupancy);
        
        
        
        dependency_level = min_dependency_level;
        Ndeps = round(dependency_level*N);
        set(txtbox5,'String',num2str(Ndeps));
        
        T=5;
        set(txtbox2,'String',num2str(T));
        
        
    end

% Many time-lines data
many_timelines = uicontrol(dummy2_group,'Style','radiobutton','String','Many Time-lines',...
    'Units','normalized',...
    'Position',[.05 .1 .6 .2], ...
    'Callback',@many_timelines_callback, ...
    'Tag', 'rab_mode4', 'BackgroundColor',color3);

    function many_timelines_callback(source,eventdata)
        
        T=max(1,min(30,floor(N/2)));
        set(txtbox2,'String',num2str(T));
        
        % min time
        std6 = std_low;
        mu4 = mu_low;
        
        % max time
        std2 = std_low;
        mu2 = mu_low;
        
        dummy2_selector = 5;
        
        set(mint2_slider,'Value',mu4);
        set(mint_slider,'Value',std6);
        set(maxt_slider,'Value',std2);
        set(maxt2_slider,'Value',mu2);
        
        
        
        % min time
        std3 = std_low;
        mu1 = mu_low;
        
        % max time
        std5 = std_low;
        mu3 = mu_low;
        
        
        set(ms2_slider,'Value',mu1);
        set(dd2_slider,'Value',mu3);
        set(dd_slider,'Value',std5);
        set(ms_slider,'Value',std3);
        
        
        occupancy = min_occupancy_level;
        set(slider5,'Value',occupancy);
        
        
        
        dependency_level = min_dependency_level;
        Ndeps = round(dependency_level*N);
        set(txtbox5,'String',num2str(Ndeps));
        
        
    end

% Normal data settings
normal_data = uicontrol(dummy2_group,'Style','radiobutton','String','Standard settings',...
    'Units','normalized',...
    'Position',[.5 .1 .6 .2], ...
    'Callback',@normal_data_callback, ...
    'Tag', 'rab_mode4', 'BackgroundColor',color3);

    function normal_data_callback(source,eventdata)
        
        T=5;
        set(txtbox2,'String',num2str(T));
        
        % min time
        std6 = std_low;
        mu4 = mu_low;
        
        % max time
        std2 = std_low;
        mu2 = mu_low;
        
        dummy2_selector = 6;
        
        set(mint2_slider,'Value',mu4);
        set(mint_slider,'Value',std6);
        set(maxt_slider,'Value',std2);
        set(maxt2_slider,'Value',mu2);
        
        
        % min time
        std3 = std_low;
        mu1 = mu_low;
        
        % max time
        std5 = std_low;
        mu3 = mu_low;
        
        
        set(ms2_slider,'Value',mu1);
        set(dd2_slider,'Value',mu3);
        set(dd_slider,'Value',std5);
        set(ms_slider,'Value',std3);
        
        
        occupancy = min_occupancy_level;
        set(slider5,'Value',occupancy);
        
        
        
        dependency_level = min_dependency_level;
        Ndeps = round(dependency_level*N);
        set(txtbox5,'String',num2str(Ndeps));
        
        
    end

%%%%%%%%%%%%%%%%%%%%%%% callbacks for switching between modes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% We don't use either temporal or spatial distributions for dependencies.
set(allchild(dep_group),'Enable','off');
set(allchild(depattr_group),'Enable','off');
set(allchild(attr_group),'Enable','off');
set(allchild(density_group),'Enable','off');

% Simplified2 is deactivated by default.
set(allchild(dummy2_group),'Enable','off');

% Callback for the extended mode
    function mode_btn1_callback(source,eventdata)
        
        mode = 1;
        set(diff_slider,'Enable','off');
        set(htext7,'Enable','off');
        
        set(allchild(dep_group),'Enable','off');
        set(allchild(depattr_group),'Enable','off');
        set(allchild(attr_group),'Enable','off');
        
        set(allchild(density_group),'Enable','off');
        set(allchild(diff_type_selector),'Enable','off');
        
        set(allchild(dummy2_group),'Enable','off');
        
        
        set(htext8,'Enable','on');
        set(tdt_slider,'Enable','on');
        set(tdt_text,'Enable','on');
%         set(allchild(depspat_group),'Enable','on');
%         set(depspat_slider,'Enable','on');
%         set(depspat_text,'Enable','on');
        set(slider5,'Enable','on');
%         set(temp_dist_slider,'Enable','on');
        set(maxt_slider,'Enable','on');
        set(ms_slider,'Enable','on');
        set(allchild(distribution4_group),'Enable','on');
        set(allchild(distribution7_group),'Enable','on');
        set(tl_slider,'Enable','on');
        set(dd_slider,'Enable','on');
        set(ddtext,'Enable','on');
        set(mint_slider,'Enable','on');
        set(mode_std_slider,'Enable','on');
        
        set(htext1,'Enable','on');
        set(htext2,'Enable','on');
%         set(htext3,'Enable','on');
        set(htext6,'Enable','on');
        
        set(mstext,'Enable','on');
        set(tltext,'Enable','on');
        
%         set(allchild(distribution_group),'Enable','on');
        set(allchild(distribution2_group),'Enable','on');
        set(allchild(distribution3_group),'Enable','on');
        set(allchild(distribution5_group),'Enable','on');
        set(allchild(distribution6_group),'Enable','on');
        set(allchild(task_group),'Enable','on');
        
        set(mint2_slider,'Enable','on');
        set(ms2text,'Enable','on');
        set(ms2_slider,'Enable','on');
        set(dd2_slider,'Enable','on');
        set(ddtext2,'Enable','on');
        set(maxt2_slider,'Enable','on');
        set(htext12,'Enable','on');
        set(htext21,'Enable','on');
        
        set(static_text2,'Enable','on');
        set(static_text3,'Enable','on');
        set(static_text4,'Enable','on');
        set(static_text5,'Enable','on');
        
        set(txtbox1,'Enable','on');
        set(txtbox2,'Enable','on');
        set(txtbox3,'Enable','on');
        set(txtbox5,'Enable','on');
        
        set(correct_checkbox,'Enable','on'); 
        set(constrain_checkbox,'Enable','on'); 
        set(chains_checkbox,'Enable','on'); 
    end

% Callback for the for dummies mode.
    function mode_btn2_callback(source,eventdata)
        mode =2;
        
        set(diff_slider,'BackgroundColor',color2);
        set(diff_type_selector,'BackgroundColor',color2);
        set(diff_type_btn1,'BackgroundColor',color2);
        set(diff_type_btn2,'BackgroundColor',color2);
        
        set(allchild(dep_group),'Enable','on');
        set(allchild(depattr_group),'Enable','on');
        set(allchild(attr_group),'Enable','on');
        
        
        set(diff_slider,'Enable','on');
        set(diff_slider,'Value',difficulty_number);
        set(htext7,'Enable','on');
        
        set(allchild(density_group),'Enable','on');
        set(allchild(diff_type_selector),'Enable','on');
        
        
        set(htext8,'Enable','off');
        
        set(tdt_slider,'Enable','off');
        set(tdt_text,'Enable','off');
%         set(allchild(depspat_group),'Enable','off');
%         set(depspat_slider,'Enable','off');
        set(slider5,'Enable','off');
%         set(temp_dist_slider,'Enable','off');
        set(maxt_slider,'Enable','off');
        set(ms_slider,'Enable','off');
        set(allchild(distribution4_group),'Enable','off');
        set(allchild(distribution7_group),'Enable','off');
        set(tl_slider,'Enable','off');
        set(dd_slider,'Enable','off');
        set(ddtext,'Enable','off');
        set(mint_slider,'Enable','off');
        set(mode_std_slider,'Enable','off');
        
        set(htext1,'Enable','off');
        set(htext2,'Enable','off');
%         set(htext3,'Enable','off');
        set(htext6,'Enable','off');
        
%         set(depspat_text,'Enable','off');
        set(mstext,'Enable','off');
        set(tltext,'Enable','off');
        
%         set(allchild(distribution_group),'Enable','off');
        set(allchild(distribution2_group),'Enable','off');
        set(allchild(distribution3_group),'Enable','off');
        set(allchild(distribution5_group),'Enable','off');
        set(allchild(distribution6_group),'Enable','off');
        set(allchild(task_group),'Enable','off');
        
        set(mint2_slider,'Enable','off');
        set(ms2text,'Enable','off');
        set(ms2_slider,'Enable','off');
        set(dd2_slider,'Enable','off');
        set(ddtext2,'Enable','off');
        set(maxt2_slider,'Enable','off');
        set(htext12,'Enable','off');
        set(htext21,'Enable','off');
        
        set(static_text2,'Enable','off');
        set(static_text3,'Enable','off');
        set(static_text4,'Enable','off');
        set(static_text5,'Enable','off');
        
        set(txtbox1,'Enable','off');
        set(txtbox2,'Enable','off');
        set(txtbox3,'Enable','off');
        set(txtbox5,'Enable','off');
        
        set(correct_checkbox,'Enable','off'); 
        set(constrain_checkbox,'Enable','off'); 
        set(chains_checkbox,'Enable','off'); 
        
        set(allchild(dummy2_group),'Enable','off');
        
        dummies_selector = 1;
        
        update_fields(dummies_selector);
    end

% Callback for the simplified2 mode.
    function mode_btn3_callback(source,eventdata)
        
        mode = 3;
        if dummy2_selector == 5
            T=max(1,min(30,floor(N/2)));
            set(txtbox2,'String',num2str(T));
        end
        
        
        set(diff_slider,'BackgroundColor',color3);
        set(diff_type_selector,'BackgroundColor',color3);
        set(diff_type_btn1,'BackgroundColor',color3);
        set(diff_type_btn2,'BackgroundColor',color3);
        
        set(allchild(dummy2_group),'Enable','on');
        set(high_attr_intervals,'Enable','off');
        set(high_dep_intervals,'Enable','off');
        
        
        set(allchild(density_group),'Enable','off');
        set(allchild(dep_group),'Enable','off');
        set(allchild(depattr_group),'Enable','off');
        set(allchild(attr_group),'Enable','off');
        
        set(diff_slider,'Enable','on');
        set(diff_slider,'Value',difficulty_number);
        set(htext7,'Enable','on');
        
        set(allchild(diff_type_selector),'Enable','on');
        
        
        set(htext8,'Enable','off');
        
        set(tdt_slider,'Enable','off');
        set(tdt_text,'Enable','off');
%         set(allchild(depspat_group),'Enable','off');
%         set(depspat_slider,'Enable','off');
        set(slider5,'Enable','off');
%         set(temp_dist_slider,'Enable','off');
        set(maxt_slider,'Enable','off');
        set(ms_slider,'Enable','off');
        set(allchild(distribution4_group),'Enable','off');
        set(allchild(distribution7_group),'Enable','off');
        set(tl_slider,'Enable','off');
        set(dd_slider,'Enable','off');
        set(ddtext,'Enable','off');
        set(mint_slider,'Enable','off');
        set(mode_std_slider,'Enable','off');
        
        set(htext1,'Enable','off');
        set(htext2,'Enable','off');
%         set(htext3,'Enable','off');
        set(htext6,'Enable','off');
        
%         set(depspat_text,'Enable','off');
        set(mstext,'Enable','off');
        set(tltext,'Enable','off');
        
%         set(allchild(distribution_group),'Enable','off');
        set(allchild(distribution2_group),'Enable','off');
        set(allchild(distribution3_group),'Enable','off');
        set(allchild(distribution5_group),'Enable','off');
        set(allchild(distribution6_group),'Enable','off');
        set(allchild(task_group),'Enable','off');
        
        set(mint2_slider,'Enable','off');
        set(ms2text,'Enable','off');
        set(ms2_slider,'Enable','off');
        set(dd2_slider,'Enable','off');
        set(ddtext2,'Enable','off');
        set(maxt2_slider,'Enable','off');
        set(htext12,'Enable','off');
        set(htext21,'Enable','off');
        
        set(static_text2,'Enable','off');
        set(static_text3,'Enable','off');
        set(static_text4,'Enable','off');
        set(static_text5,'Enable','off');
        
        set(txtbox1,'Enable','off');
        set(txtbox2,'Enable','off');
        set(txtbox3,'Enable','off');
        set(txtbox5,'Enable','off');
        
        set(correct_checkbox,'Enable','off'); 
        set(constrain_checkbox,'Enable','off'); 
        set(chains_checkbox,'Enable','off'); 
        
        dummies_selector = 2;
        
        update_fields(dummies_selector);
    end

% In some sense, this is where the fun happends. Must be changed for the
% dummies2 mode.
    function update_fields(arg1)
        % Different values dependning on low or high is chosen.
        
        set(correct_checkbox,'Value',1);
        set(constrain_checkbox,'Value',0);
        set(chains_checkbox,'Value',1); 
        
        constrain = 0;
        rectify = 1;
        chains = 1;
        
        % This could be fine-tuned a bit.
        N = max(1,round(min_tasks + (max_tasks-min_tasks)*difficulty_number^4/100^4));
        L = 1000000000;
        if arg1 == 1
            
            T = min(floor(N/3),max(1,round(difficulty_number/3.3)));
        elseif dummy2_selector ~= 5
            
            T = min(floor(N/3),5);
        elseif dummy2_selector == 5
            T=max(1,min(30,floor(N/2)));
        end
        
        % Must change the corresponding button groups.
        
        distrib1 = norm_distr;
        distrib2 = norm_distr;
        distrib3 = norm_distr;
        distrib4 = chi2_distr;
        distrib5 = norm_distr;
        distrib6 = norm_distr;
        distrib7 = chi2_distr;
        distrib8 = norm_distr;
        distrib9 = norm_distr;
        
        dist_sel1 = 0;
        dist_sel2 = 0;
        dist_sel3 = 0;
        dist_sel4 = 2;
        dist_sel5 = 0;
        dist_sel6 = 0;
        dist_sel7 = 2;
        dist_sel8 = 0;
        dist_sel9 = 0;
        
        % task distr. across timlines
        std8 = 0.4;
        
        % task spacing distr. 
        std7 = 0.8;
        
        % task length distr.
        std4 = 0.4;
        
        if arg1 == 1
            if density == 0
                % Attune slider + occupancy.
                occupancy = 0.1;
                set(slider5,'Value',occupancy);
            else
                occupancy = 0.9;
                set(slider5,'Value',occupancy);
            end
        else
            if dummy2_selector == 2
                % Attune slider + occupancy.
                occupancy = max_occupancy_level;
                set(slider5,'Value',occupancy);
            else
                occupancy = min_occupancy_level;
                set(slider5,'Value',occupancy);
            end
        end
        
        
        if dep_intervals == 0
            % min time
            std6 = std_low;
            mu4 = mu_low;
            
            % max time
            std2 = std_low;
            mu2 = mu_low;
        else
            % min time
            std6 = 0.4;
            mu4 = 0.9;
            
            % max time
            std2 = 0.4;
            mu2 = 0.9;
        end
        
        if attr_intervals == 0
            % min time
            std3 = std_low;
            mu1 = mu_low;
            
            % max time
            std5 = std_low;
            mu3 = mu_low;
        else
            % min time
            std3 = 0.4;
            mu1 = 0.9;
            
            % max time
            std5 = 0.4;
            mu3 = 0.9;
        end
        
        % Dependency level depends on whether we are in the dummies or
        % dummies2 mode.
        if arg1 == 1
            if dep_intensity == 0
                dependency_level = 0.05;
                Ndeps = round(N*dependency_level);
            else
                dependency_level = 0.95;
                Ndeps = round(N*dependency_level);
            end
        else
            if dummy2_selector == 1
                dependency_level = max_dependency_level;
                Ndeps = round(N*dependency_level);
            else
                dependency_level = min_dependency_level;
                Ndeps = round(N*dependency_level);
            end
        end
        
        % Attune text boxes.
        set(txtbox1,'String',num2str(L));
        set(txtbox2,'String',num2str(T));
        set(txtbox3,'String',num2str(N));
        set(txtbox5,'String',num2str(Ndeps));
        
        % Update sliders and choice of distributions
        set(distr3,'Value',1);
        set(distr5,'Value',1);
        set(dead_distr1,'Value',1);
        set(mint_distr1,'Value',1);
        set(taskdstr1,'Value',1);
        
        set(mint2_slider,'Value',mu4);
        set(mint_slider,'Value',std6);
        set(maxt_slider,'Value',std2);
        set(maxt2_slider,'Value',mu2);
        
        set(ms2_slider,'Value',mu1);
        set(dd2_slider,'Value',mu3);
        set(dd_slider,'Value',std5);
        set(ms_slider,'Value',std3);
        
        set(tdt_slider,'Value',std8);
        set(slider5,'Value',occupancy);


        set(tlength_distr3,'Value',1);
        set(mode_distr3,'Value',1);
        set(tl_slider,'Value',std4);


        set(mode_std_slider,'Value',std7);
    end
%%%%%%%%%%%%%%%%%%%%%%% Discrete or continuous difficulties %%%%%%%%%%%%%%%%%%%%%%%%%%%%

diff_type_selector = uibuttongroup(f,'Title','Continuous or discrete difficulties',...
    'Position',[.275 .85 .20 .08], 'BackgroundColor',color2);

diff_type_btn1 = uicontrol(diff_type_selector,'Style','radiobutton','String','Continuous',...
    'Units','normalized',...
    'Position',[.1 .3 .6 .4], ...
    'Callback',@diff_type_btn1_callback, ...
    'Tag', 'rab_mode1', 'BackgroundColor',color2);

    function diff_type_btn1_callback(source,eventdata)
        diff_type = 0;
        set(diff_slider,'SliderStep',[0.05 0.2]);
    end

diff_type_btn2 = uicontrol(diff_type_selector,'Style','radiobutton','String','Discrete',...
    'Units','normalized',...
    'Position',[.6 .3 .6 .4], ...
    'Callback',@diff_type_btn2_callback, ...
    'Tag', 'rab_mode2', 'BackgroundColor',color2);

    function diff_type_btn2_callback(source,eventdata)
        diff_type = 1;
        difficulty_number = 50*round(difficulty_number/50);
        
        set(diff_slider,'Value',difficulty_number);
        set(diff_slider,'SliderStep',[0.5 0.5]);
        update_fields(dummies_selector);
    end

set(allchild(diff_type_selector),'Enable','off');

%%%%%%%%%%%%%%%%%%%%%%%%% Difficulty slider %%%%%%%%%%%%%%%%%%%%%%%%%%
diff_slider = uicontrol(f,'Style','slider',...
    'Min',0,'Max',100,'Value',difficulty_number,...
    'SliderStep',[0.05 0.2], ...
    'Units','normalized',...
    'Position',[0.5 0.85 0.2 0.04], ...
    'Enable','off', ...
    'Callback',@diff_cb, 'BackgroundColor',color2);

    function diff_cb(source,eventdata)
        if diff_type == 0
        difficulty_number = get(diff_slider,'Value');
        else
            difficulty_number = round(get(diff_slider,'Value')/50)*50;
            
            set(diff_slider,'Value',difficulty_number);
            
            
        end
        update_fields(dummies_selector);
        % Uppdatera  här alla fält, också när man aktiverar/avaktiverar
        % detta reglage.
    end

htext7  = uicontrol('Style','text','String','Level of difficulty:', 'Units','normalized',...
    'Position',[0.55,0.895,0.1,0.02], 'Enable','off');
%%%%%%%%%%%%%%%%%%%%%%%%% Task distribution across time-lines %%%%%%%%%%%%%%%%%%%%%%%%%%

task_group = uibuttongroup(f,'Title','Task distribution across time-lines',...
    'Position',[.05 .25 .20 .08], 'BackgroundColor',color1);

taskdstr1 = uicontrol(task_group,'Style','radiobutton','String','Normal',...
    'Units','normalized',...
    'Position',[.1 .3 .6 .4], ...
    'Callback',@taskdstr1_callback, ...
    'Tag', 'rab1', 'BackgroundColor',color1);
taskdstr2 = uicontrol(task_group,'Style','radiobutton','String','Uniform',...
    'Units','normalized',...
    'Position',[.35 .3 .6 .4], ...
    'Callback',@taskdstr2_callback, ...
    'Tag', 'rab2', 'BackgroundColor',color1);

    function taskdstr1_callback(source,eventdata)
        distrib8 = norm_distr;
        dist_sel8 = 0;
        
    end


    function taskdstr2_callback(source,eventdata)
        distrib8 = unif_distr;
        dist_sel8 = 1;
    end

taskdstr3 = uicontrol(task_group,'Style','radiobutton','String','Chi-squared',...
    'Units','normalized',...
    'Position',[.6 .3 .6 .4], ...
    'Callback',@taskdstr3_callback, ...
    'Tag', 'rab2', 'BackgroundColor',color1);

    function taskdstr3_callback(source,eventdata)
        distrib8 = chi2_distr;
        dist_sel8 = 2;
    end

tdt_text  = uicontrol('Style','text','String','Standard deviation:', 'Units','normalized',...
    'Position',[0.1,0.195,0.1,0.02]);
            
tdt_slider = uicontrol(f,'Style','slider',...
                'Min',0.05,'Max',0.95,'Value',std8,...
                'SliderStep',[0.05 0.1], ...
                'Units','normalized',...
                'Position',[0.05 0.15 0.2 0.04], ...
                'Callback',@tdt_slider_cb, 'BackgroundColor',color1);
            
    function tdt_slider_cb(source,eventdata)
        std8 = get(tdt_slider,'Value');
    end

%%%%%%% Dependencies spatial distribution %%%%%%
depspat_group = uibuttongroup(f,'Title','Spatial distribution of dependencies',...
    'Position',[.275 .25 .20 .08]);

depspat_dstr1 = uicontrol(depspat_group,'Style','radiobutton','String','Normal',...
    'Units','normalized',...
    'Position',[.1 .3 .6 .4], ...
    'Callback',@depspat_dstr1_callback, ...
    'Tag', 'rab1');
depspat_dstr2 = uicontrol(depspat_group,'Style','radiobutton','String','Uniform',...
    'Units','normalized',...
    'Position',[.6 .3 .6 .4], ...
    'Callback',@depspat_dstr2_callback, ...
    'Tag', 'rab2');

    function depspat_dstr1_callback(source,eventdata)
        distrib9 = norm_distr;
        dist_sel9 = 0;
    end


    function depspat_dstr2_callback(source,eventdata)
        distrib9 = unif_distr;
        dist_sel9 = 1;
    end

depspat_text  = uicontrol('Style','text','String','Standard deviation:', 'Units','normalized',...
    'Position',[0.325,0.195,0.1,0.02]);
            
depspat_slider = uicontrol(f,'Style','slider',...
                'Min',0.05,'Max',0.95,'Value',std9,...
                'SliderStep',[0.05 0.1], ...
                'Units','normalized',...
                'Position',[0.275 0.15 0.2 0.04], ...
                'Callback',@depspat_slider_cb);
            
    function depspat_slider_cb(source,eventdata)
        std9 = get(depspat_slider,'Value');
    end

set(allchild(depspat_group),'Enable','off');
set(depspat_slider,'Enable','off');
set(depspat_text,'Enable','off');
            
%%%%%%%%%%%%%%%%%%%%%%%%%%% Level of occupancy %%%%%%%%%%%%%%%%%%%%%%%%%

htext6  = uicontrol('Style','text','String','Level of occupancy:', 'Units','normalized',...
    'Position',[0.1,0.795,0.1,0.02]);
            
slider5 = uicontrol(f,'Style','slider',...
                'Min',0.05,'Max',0.95,'Value',0.5,...
                'SliderStep',[0.05 0.1], ...
                'Units','normalized',...
                'Position',[0.05 0.75 0.2 0.04], ...
                'Callback',@slider5_cb, 'BackgroundColor',color1);
            
    function slider5_cb(source,eventdata)
        occupancy = get(slider5,'Value');
    end

% Callback for the creation of test data
    function testdatagen_callback(source,eventdata)
        
        set(checkbox,'Value',0);
        
        timeline_selection=1;
        set(listbox1,'Value',timeline_selection);
        
        % Reset data variables.
        TimelineSolution_mater = [];
        attributes_mater = [];
        DependencyMatrix_mater = [];
        DependencyAttribute_mater = [];
        TimelineSolution = [];
        attributes = [];
        DependencyMatrix = [];
        DependencyAttribute = [];
        Modified_DependencyMatrix = [];
        Modified_DependencyMatrix_mater = [];
        
        % Save current values
        L_prev = L;
        T_prev = T;
        
        % We need to iterate across the number of test data to be created.
        for it=1:Num_data
            [ TimelineSolution, attributes, DependencyMatrix, DependencyAttribute ] = Testdatagenerator(N, L, T, gentasks, ...
                gendepmatrix,gendepattr, Ndeps, occupancy, genlistoflst, rectify, std1,std2,std3,std4,std5,std6,std7,std8, ...
                std9,mu1,mu2,mu3,mu4,distrib1,distrib2,distrib3,distrib4,distrib5,distrib6,distrib7,distrib8,distrib9,constrain, chains);
            
            % Clear colors
            Task_color_matrix = [];
            Dep_color_matrix = [];
            Task_timeline_color_matrix = [];
            
            trash_dep = [];

            index_iterator = 1;
            
            TimelineSolution_mater_prel = [];
            
            % Convert the cell array to a regular array
            for k=1:length(TimelineSolution)

                TimelineSolution_mater_prel = [TimelineSolution_mater_prel; TimelineSolution{k}, k*ones(size(TimelineSolution{k},1),1), it*ones(size(TimelineSolution{k},1),1)];
                attributes_mater = [attributes_mater; attributes{k}, k*ones(size(attributes{k},1),1), it*ones(size(attributes{k},1),1)];
                
                index_iterator = index_iterator+size(TimelineSolution{k},1);
            end
            
            index_vector = 1:index_iterator-1;
            index_vector = index_vector';
            
            TimelineSolution_mater = [TimelineSolution_mater; index_vector, TimelineSolution_mater_prel];
            
            % Need to convert dependency coordinates
            if ~isempty(DependencyMatrix)
                for l=1:size(DependencyMatrix,1)
                    trash_dep = [trash_dep; ConvertToLong(DependencyMatrix(l,1),DependencyMatrix(l,2)) ConvertToLong(DependencyMatrix(l,3),DependencyMatrix(l,4))];
                end
            end
            
            index_vector = 1:size(DependencyMatrix,1);
            index_vector = index_vector';
            
            % Modified matrices for the demands of the group.
            Modified_DependencyMatrix = [index_vector, trash_dep(:,1) DependencyMatrix(:,2) trash_dep(:,2) DependencyMatrix(:,4)];
            DependencyMatrix_mater = [DependencyMatrix_mater; DependencyMatrix, it*ones(size(DependencyMatrix,1),1)];
            DependencyAttribute_mater = [DependencyAttribute_mater; DependencyAttribute, it*ones(size(DependencyAttribute,1),1)];
            Modified_DependencyMatrix_mater = [Modified_DependencyMatrix_mater; Modified_DependencyMatrix, it*ones(size(Modified_DependencyMatrix,1),1)];
            
        end
        
        
        % Must convert long Timelinesolution and attributes to
        % cell-array when reading files (not implemented).
        
        % Visualize test data!!
        print_correct();
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% difficulties = 0:5:45;
% modes = 1:6;
data_sets = 10;

    function change_modes(int)
%         set(dummy2_group,'Value',int);
        switch int
            case 1
                % Must do set(...'Value') here!
                % + change the corresponding variable!
                set(high_deps,'Value',1);
                high_deps_callback([],[]);
            case 2
                set(high_density,'Value',1);
                high_density_callback([],[]);
            case 5
                set(many_timelines,'Value',1);
                many_timelines_callback([],[]);
            case 6
                set(normal_data,'Value',1);
                normal_data_callback([],[]);
        end
    end

% Function for creating and saving test data with different settings.
    function make_multi_callback(source,eventdata)
        
        % Number of data sets for each setting.
        set(txtbox4,'String',10);
        txt4_callback([],[]);
        
        set(mode_btn3,'Value',1);
        mode_btn3_callback([],[]);
        
        
        % Run the callback for the diff slider.
        for diff_it = 0:5:60
            set(diff_slider,'Value',diff_it);
            diff_cb([],[]);
            
            
            for modes = 1:4
                % Skip the long intervals at this moment.
                if modes <= 2
                    change_modes(modes);
                else
                    change_modes(modes+2);
                end
                
                set(checkbox,'Value',0);
                
                timeline_selection=1;
                set(listbox1,'Value',timeline_selection);
                
                
                TimelineSolution_mater = [];
                attributes_mater = [];
                DependencyMatrix_mater = [];
                DependencyAttribute_mater = [];
                TimelineSolution = [];
                attributes = [];
                DependencyMatrix = [];
                DependencyAttribute = [];
                Modified_DependencyMatrix = [];
                Modified_DependencyMatrix_mater = [];
                
                L_prev = L;
                T_prev = T;
                
                % We need to iterate across the number of test data to be created.
                for it=1:Num_data
                    [ TimelineSolution, attributes, DependencyMatrix, DependencyAttribute ] = Testdatagenerator(N, L, T, gentasks, ...
                        gendepmatrix,gendepattr, Ndeps, occupancy, genlistoflst, rectify, std1,std2,std3,std4,std5,std6,std7,std8, ...
                        std9,mu1,mu2,mu3,mu4,distrib1,distrib2,distrib3,distrib4,distrib5,distrib6,distrib7,distrib8,distrib9,constrain);
                    
                    % Clear colors
                    Task_color_matrix = [];
                    Dep_color_matrix = [];
                    Task_timeline_color_matrix = [];
                    trash_dep = [];
                    
                    index_iterator = 1;
                    
                    TimelineSolution_mater_prel = [];
                    
                    for k=1:length(TimelineSolution)
                        
                        TimelineSolution_mater_prel = [TimelineSolution_mater_prel; TimelineSolution{k}, k*ones(size(TimelineSolution{k},1),1), it*ones(size(TimelineSolution{k},1),1)];
                        attributes_mater = [attributes_mater; attributes{k}, k*ones(size(attributes{k},1),1), it*ones(size(attributes{k},1),1)];
                        
                        index_iterator = index_iterator+size(TimelineSolution{k},1);
                    end
                    
                    index_vector = 1:index_iterator-1;
                    index_vector = index_vector';
                    
                    TimelineSolution_mater = [TimelineSolution_mater; index_vector, TimelineSolution_mater_prel];
                    
                    % Need to convert dependency coordinates
                    if ~isempty(DependencyMatrix)
                        for l=1:size(DependencyMatrix,1)
                            trash_dep = [trash_dep; ConvertToLong(DependencyMatrix(l,1),DependencyMatrix(l,2)) ConvertToLong(DependencyMatrix(l,3),DependencyMatrix(l,4))];
                        end
                    end
                    
                    index_vector = 1:size(DependencyMatrix,1);
                    index_vector = index_vector';
                    
                    % Modified matrices for the demands of the group.
                    Modified_DependencyMatrix = [index_vector, trash_dep(:,1) DependencyMatrix(:,2) trash_dep(:,2) DependencyMatrix(:,4)];
                    DependencyMatrix_mater = [DependencyMatrix_mater; DependencyMatrix, it*ones(size(DependencyMatrix,1),1)];
                    DependencyAttribute_mater = [DependencyAttribute_mater; DependencyAttribute, it*ones(size(DependencyAttribute,1),1)];
                    Modified_DependencyMatrix_mater = [Modified_DependencyMatrix_mater; Modified_DependencyMatrix, it*ones(size(Modified_DependencyMatrix,1),1)];
                    
                end
                
                % Print the results
                print_correct();
                testdatasave_callback();
                % Display the progress
                modes
            end
            % Display the progress
            diff_it
        end
        
    end
%%%%%%%%%%%%%%%% Convert to long index %%%%%%%%%%%%%%%%%%
    function longindex = ConvertToLong(number, timeline)
%         number
%         timeline
        longindex = 1;
        for k=1:timeline-1
            longindex = longindex+size(TimelineSolution{k},1);
        end
        longindex = longindex + number-1;
    end
    
% Print tasks and task attributes like a machine gun.
    function print_selection
        set(0, 'currentfigure', f3);
        Color = diag(ones(3,1));
        
        
        xlevel=size(TimelineSolution{timeline_selection},1);
        
        if ~isempty(TimelineSolution)
            prel_string = 1:length(TimelineSolution);
            
            string1 = mat2cell(prel_string,1,ones(1,size(prel_string,2)));
            
            set(listbox1,'String',string1);
        end
        set(f3, 'currentaxes', ha3);
        
        cla reset
        
        set(gca,'FontSize',10);
        title('Plot of tasks and task attributes');
        xlabel('Time');
        ylabel('Tasks');
        axis([-0.1*L_prev,1.1*L_prev,-0.1*xlevel,1.1*xlevel])
        hold(ha3, 'on')
        
        % Length of the entire solution
        timeline_length = 0;
        for it4 = 1:timeline_length
            timeline_length = timeline_length+size(TimelineSolution{it4},1);
        end
        
        % Create color matrix if it doesn't exist.
        if size(Task_timeline_color_matrix,1) < timeline_length
            
            for i=1:size(TimelineSolution,1)
                keycol = [rand() rand() rand()];
                Task_timeline_color_matrix = [Task_timeline_color_matrix; keycol]; 
            end
            
        end
        
        for k=1:size(TimelineSolution{timeline_selection},1)
            
            i = timeline_selection;
            % Print grey lines for the admissible intervals of tasks.
            line([attributes{i}(k,1) TimelineSolution{i}(k,1)], [k k], 'Color',[0.5 0.5 0.5]);
            line([attributes{i}(k,1) attributes{i}(k,1)], [k-0.1 k+0.1], 'Color',[0.5 0.5 0.5]);
            %             line([TimelineSolution{i}(k,1) TimelineSolution{i}(k,1)+TimelineSolution{i}(k,2)], [k k], 'Color',Color(1+mod(k,3),:));
            line([TimelineSolution{i}(k,1)+TimelineSolution{i}(k,2) attributes{i}(k,2)], [k k], 'Color',[0.5 0.5 0.5]);
            line([attributes{i}(k,2) attributes{i}(k,2)], [k-0.1 k+0.1], 'Color',[0.5 0.5 0.5]);
            
            %             line([TimelineSolution{i}(k,1) TimelineSolution{i}(k,1)], [k-0.1 k+0.1], 'Color',Color(1+mod(k,3),:));
            %             line([TimelineSolution{i}(k,1)+TimelineSolution{i}(k,2) TimelineSolution{i}(k,1)+TimelineSolution{i}(k,2)], [k-0.1 k+0.1], 'Color',Color(1+mod(k,3),:));
            
            % Print tasks as rounded rectangles.
            
            % Are colours already set or not?
            % Another condition is needed to distinguish time-lines.
            
            rectangle('Position',[TimelineSolution{i}(k,1),k-0.1,TimelineSolution{i}(k,2),0.2],'FaceColor',Task_timeline_color_matrix(ConvertToLong(k,timeline_selection),:),'EdgeColor','None','Curvature',[0.5, 1])
            
        end
        
        hold(ha3, 'off')
        set(0, 'currentfigure', f);
    end
        
        function print_correct
        
        
        % Visualize test data:
        set(0, 'currentfigure', f2);
        
        set(f2, 'currentaxes', ha2);
        
        cla reset
        
        axis([-0.1*L_prev,1.1*L_prev,0,T_prev+1])
        set(gca,'FontSize',10);
        title('Plot of timelines and tasks');
        xlabel('Time');
        ylabel('Time-line');
        hold(ha2, 'on')
        Color = diag(ones(3,1));
        
        timeline_length = 0;
        for it4 = 1:length(TimelineSolution)
            timeline_length = timeline_length+size(TimelineSolution{it4},1);
        end
        
        
        for i=1:length(TimelineSolution)
            for k=1:size(TimelineSolution{i},1)
                % Print randomly coloured rectangles for tasks
                keycol = [rand() rand() rand()];
                %                 line([TimelineSolution{i}(k,1) TimelineSolution{i}(k,1)+TimelineSolution{i}(k,2)], [i i], 'Color',Color(1+mod(k,3),:));
                %                 line([TimelineSolution{i}(k,1) TimelineSolution{i}(k,1)], [i-0.1 i+0.1], 'Color',Color(1+mod(k,3),:));
                %                 line([TimelineSolution{i}(k,1)+TimelineSolution{i}(k,2) TimelineSolution{i}(k,1)+TimelineSolution{i}(k,2)], [i-0.1 i+0.1], 'Color',Color(1+mod(k,3),:));
                
                
                
                if size(Task_color_matrix,1) < timeline_length
                    rectangle('Position',[TimelineSolution{i}(k,1),i-0.1,TimelineSolution{i}(k,2),0.2],'FaceColor',keycol,'EdgeColor','None','Curvature',[0.5, 1])
                    Task_color_matrix = [Task_color_matrix; keycol];
                else
                    rectangle('Position',[TimelineSolution{i}(k,1),i-0.1,TimelineSolution{i}(k,2),0.2],'FaceColor',Task_color_matrix(ConvertToLong(k,i),:),'EdgeColor','None','Curvature',[0.5, 1])
                end
                
            end
        end
        
        hold(ha2, 'off')
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%% timeline attributes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        set(0, 'currentfigure', f3);
        
        % Draw dependency attributes like a machine gun.
        
        if ~isempty(TimelineSolution)
            xlevel=size(TimelineSolution{timeline_selection},1);
        else
            xlevel=1;
        end
        
        if ~isempty(TimelineSolution)
            prel_string = 1:length(TimelineSolution);
            
            string1 = mat2cell(prel_string,1,ones(1,size(prel_string,2)));
            
            set(listbox1,'String',string1);
        end
        set(f3, 'currentaxes', ha3);
        
        cla reset
        
        set(gca,'FontSize',10);
        title('Plot of tasks and task attributes');
        xlabel('Time');
        ylabel('Tasks');
        axis([-0.1*L_prev,1.1*L_prev,-0.1*xlevel,1.1*xlevel])
        hold(ha3, 'on')
        
        % Length of the entire solution
        timeline_length = 0;
        for it4 = 1:length(TimelineSolution)
            timeline_length = timeline_length+size(TimelineSolution{it4},1);
        end
        
        % Create color matrix if it doesn't exist.
        if size(Task_timeline_color_matrix,1) < timeline_length
            
            for i=1:timeline_length
                keycol = [rand() rand() rand()];
                Task_timeline_color_matrix = [Task_timeline_color_matrix; keycol]; 
            end
            
        end
        
        if ~isempty(TimelineSolution)
            for k=1:size(TimelineSolution{timeline_selection},1)
                % keycol = [rand() rand() rand()];
                
                i = timeline_selection;
                % Plot grey lines for the attributes intervals.
                line([attributes{i}(k,1) TimelineSolution{i}(k,1)], [k k], 'Color',[0.5 0.5 0.5]);
%                 line([TimelineSolution{i}(k,1) TimelineSolution{i}(k,1)+TimelineSolution{i}(k,2)], [k k], 'Color',Color(1+mod(k,3),:));
                line([TimelineSolution{i}(k,1)+TimelineSolution{i}(k,2) attributes{i}(k,2)], [k k], 'Color',[0.5 0.5 0.5]);
                
                line([attributes{i}(k,1) attributes{i}(k,1)], [k-0.1 k+0.1], 'Color',[0.5 0.5 0.5]);
                
                line([attributes{i}(k,2) attributes{i}(k,2)], [k-0.1 k+0.1], 'Color',[0.5 0.5 0.5]);
                
                
                %                 line([TimelineSolution{i}(k,1) TimelineSolution{i}(k,1)], [k-0.1 k+0.1], 'Color',Color(1+mod(k,3),:));
                %                 line([TimelineSolution{i}(k,1)+TimelineSolution{i}(k,2) TimelineSolution{i}(k,1)+TimelineSolution{i}(k,2)], [k-0.1 k+0.1], 'Color',Color(1+mod(k,3),:));
                rectangle('Position',[TimelineSolution{i}(k,1),k-0.1,TimelineSolution{i}(k,2),0.2],'FaceColor',Task_timeline_color_matrix(ConvertToLong(k,timeline_selection),:),'EdgeColor','None','Curvature',[0.5, 1])
            end
        end
        hold(ha3, 'off')
        %%%%%%%%%%%%%%%%%%%%%% Draw dependencies and their attributes. %%%%%%%%%%%%%%%%%%%%%%%%%%%
        set(0, 'currentfigure', f4);
        
        set(f4, 'currentaxes', ha4);
        
        cla reset
        
        xlevel2 = size(DependencyMatrix,1);
        
        set(gca,'FontSize',10);
        title('Plot of dependencies and dependency attributes');
        xlabel('Time');
        ylabel('Dependencies');
        
        if xlevel2 > 0
            axis([-0.1*L_prev,1.1*L_prev,-0.1*xlevel2,1.1*xlevel2])
            hold(ha4, 'on')
            
            for k=1:xlevel2
                keycol = [rand() rand() rand()];
                task1_start = TimelineSolution{DependencyMatrix(k,2)}(DependencyMatrix(k,1),1);
                task1_length = TimelineSolution{DependencyMatrix(k,2)}(DependencyMatrix(k,1),2);
                task2_start = TimelineSolution{DependencyMatrix(k,4)}(DependencyMatrix(k,3),1);
                
                fdmin = DependencyAttribute(k,1);
                fdmax = DependencyAttribute(k,2);
                
                % Print boxes or intervals in order to illustrate tasks.
                
                line([task1_start+task1_length+fdmin task1_start+task1_length+fdmax], [k k], 'Color',[0.5 0.5 0.5]);
                plot(task2_start,k,'Marker','.','Color',[1 0 0],'MarkerSize',14)
                
%                 line([task1_start task1_start+task1_length], [k k], 'Color',Color(1+mod(k,3),:));
%                 line([task1_start task1_start], [k-0.3 k+0.3], 'Color',Color(1+mod(k,3),:));
%                 line([task1_start+task1_length task1_start+task1_length], [k-0.3 k+0.3], 'Color',Color(1+mod(k,3),:));
                
                rectangle('Position',[task1_start,k-0.3,task1_length,0.6],'FaceColor',keycol,'EdgeColor','None')
                
                line([task1_start+task1_length+fdmin task1_start+task1_length+fdmin], [k-0.3 k+0.3], 'Color',[0.5 0.5 0.5]);
                line([task1_start+task1_length+fdmax task1_start+task1_length+fdmax], [k-0.3 k+0.3], 'Color',[0.5 0.5 0.5]);
                
            end
            
            hold(ha4, 'off')
        end
        set(0, 'currentfigure', f);
    end

% Print dependencies as splines.
    function print_arrows
        
        
        
        for i=1:size(DependencyMatrix,1)
            % Colour for splines
                %             Dep_color_matrix = [];
            
            if size(Dep_color_matrix) < size(DependencyMatrix,1)
                col = [rand() rand() rand()];
                Dep_color_matrix = [Dep_color_matrix; col];
            else
                col = Dep_color_matrix(i,:);
            end
            
            set(0, 'currentfigure', f2);
            
            set(f2, 'currentaxes', ha2);
            hold(ha2, 'on')
            task1_start = TimelineSolution{DependencyMatrix(i,2)}(DependencyMatrix(i,1),1);
            task1_length = TimelineSolution{DependencyMatrix(i,2)}(DependencyMatrix(i,1),2);
            task2_start = TimelineSolution{DependencyMatrix(i,4)}(DependencyMatrix(i,3),1);
            
            x_start = task1_start+task1_length;
            x_end = task2_start;
            
            % Draw splines differently depending on the positions
            % of the time-lines of the constituent tasks.
            if DependencyMatrix(i,2) < DependencyMatrix(i,4)
                disp1 = 0.1;
                disp2 = 0.1;
            elseif DependencyMatrix(i,2) > DependencyMatrix(i,4)
                disp1 = -0.1;
                disp2 = -0.1;
            else
                disp1 = 0.1;
                disp2 = 0.1;
            end
            
            y_start = DependencyMatrix(i,2)+disp1;
            y_end = DependencyMatrix(i,4)+disp2;
            
            % line([x_start, x_end], [y_start, y_end],'Color',[0.1,0.8,0.1])
            
            
            
            X = [x_start x_end];
            Y = [y_start y_end];
            % intermediate point (you have to choose your own)
            Xi = mean(X);
            Yi = mean(Y) + 0.5*(y_end-y_start)+0.1+0.1*rand();
            
            Xa = [X(1) Xi X(2)];
            Ya = [Y(1) Yi Y(2)];
            
            t  = 1:numel(Xa);
            ts = linspace(min(t),max(t),numel(Xa)*10); % has to be a fine grid
            xx = spline(t,Xa,ts);
            yy = spline(t,Ya,ts);
            
            plot(xx,yy,'Color',col); hold on; % curve
            
%             str1 = strcat('\leftarrow ', num2str(i));
%             text(Xi,Yi,str1)
            
            plot(x_end,y_end,'Marker','.','Color',[1 0 0],'MarkerSize',22)
            hold(ha2, 'off')
            set(0, 'currentfigure', f);
        end
    end
end
