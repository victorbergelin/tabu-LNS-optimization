function varargout = test_launcher(varargin)
% This code handles every button, checkbox and listbox in the GUI. The
% only files the user needs is test_launcher.m, test_launcher.fig and
% t_dist_values_095.dat.
%
% Made by: Hendric Kjellström

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_launcher_OpeningFcn, ...
                   'gui_OutputFcn',  @test_launcher_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% --- Executes just before test_launcher is made visible.
function test_launcher_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = test_launcher_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)

% Important global values.
global run_cb_files
global index_listbox2

dataParameters = struct('name',{},'path',{});

% Retrieve name from data-sets.
A=dir('src/test/testdata/*_*');
value = [];
for i = 1:length(A)

    value = [value; cellstr(getfield(A,{i},'name'))];

end

% Create models when user selects them:
modelParameters = struct( ...
    'tabu', struct('active',0,'initial',1,'phases',[1]), ...
    'LNS' , struct('active',0,'initial',1,'phases',[1]), ...
    'LNSlist' , struct('active',0,'initial',1,'phases',[1]), ...
    'MathModel', struct('active',0,'initial',1,'phases',[1]));

input = get(handles.edit1,'String');
input = str2num(input);

global cb_checkbox_run

% Runs solver with all data-sets.
if (get(handles.pushbutton1,'Value'))==1
if run_cb_files==2
    for i = 1:length(value)
        dataObj.name = value(i);
        dataObj.path = horzcat('src/test/testdata/',char(value(i)),'/');
        dataObj.path;
        dataParameters{i} = dataObj;
    end

% Checks global variable index_listbox2 which data-sets to use.
elseif run_cb_files==1
    for k = 1:length(index_listbox2)
    dataObj.name = value(index_listbox2(k));
    dataObj.path = horzcat('src/test/testdata/',char(value(index_listbox2(k))),'/');
    dataObj.path;
    dataParameters{k} = dataObj;
    end
end
     % Setup for Tabu search.
     if cb_checkbox_run==1
          modelParameters.tabu = setfield(modelParameters.tabu,'active',1);
          modelParameters.tabu = setfield(modelParameters.tabu,'phases',input);
         
          status = mainlauncher(dataParameters, modelParameters);
         
     % Setup for LNS.
     elseif cb_checkbox_run==2
         modelParameters.LNS = setfield(modelParameters.LNS,'active',1);
         status = mainlauncher(dataParameters, modelParameters);
         
         
     % Setup for the mathematical model.
     elseif cb_checkbox_run==3
            modelParameters.MathModel = setfield(modelParameters.MathModel,'active',1);
            status = mainlauncher(dataParameters, modelParameters);
            
            
     % Setup for LNS-list.
     elseif cb_checkbox_run==4
         
         modelParameters.LNSlist = setfield(modelParameters.LNSlist,'active',1);
         status = mainlauncher(dataParameters, modelParameters);
         
     end
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)

% Checks which heuristic to use along with checkbox2, checkbox3 and checkbox14.

global cb_checkbox_run
if get(handles.checkbox1,'Value')==1
     cb_checkbox_run=1; 
end

% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)

global cb_checkbox_run
if get(handles.checkbox2,'Value')==1
     cb_checkbox_run=2; 
end

% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)

global cb_checkbox_run
if get(handles.checkbox3,'Value')==1
     cb_checkbox_run=3; 
end

function edit1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)

% Gathers the selected data-sets if run_cb_files == 1.
global index_listbox2

index_listbox2 = get(handles.listbox2,'Value');

% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global test_data_value

% Retrieve name of data-sets.
A=dir('src/test/testdata/*_*');
test_data_value = [];
for i = 1:length(A)

    test_data_value = [test_data_value; cellstr(getfield(A,{i},'name'))];

end

% Fills listbox2 with all the data-sets.
set(hObject,'String',test_data_value);


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)

global index_listbox3

% index_listbox3 is set to the value in the result-listbox in order to
% plot.
index_listbox3 = get(handles.listbox3,'Value');


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


B = dir('target/results/results_201*');
value = [];

% This loop might be obsolete.

% for i = 1:length(B)
% 
%     value = [value; cellstr(getfield(B,{i},'name'))];
% 
% end

% Pick out the name and skip all other information.
p = B(end);
l = p.name;

% Puts together the latest path to the results.
temp_1=strcat('target/results/',l);
temp_2=strcat(temp_1,'/*_*');

new_path = dir(temp_2);

past_value=[];

% Creates a cell array of names from the result.
for i = 1:length(new_path)

    past_value = [past_value; cellstr(getfield(new_path,{i},'name'))];

end

new_past_value=[];

% Makes sure that correct results gets in to the listbox.
for i=1:length(past_value)
    
    b = past_value(i);
    c = b{1};
    
    if or(or(c(1)=='T',c(1)=='L'),c(1)=='A')==1
        new_past_value=[past_value(i) new_past_value];
    else
        new_past_value = new_past_value;
    end
end

% Fills the listbox3 with results from previous run.
set(hObject,'String',new_past_value);




% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)

% When the user selects a result, this part loads the data 
% and plots objective function / time.

global new_value

global l_path_gui

global index_listbox3

global load_data

global cb_checkbox_run

new_past_value=[];

% Same loop as in listbox3.
for i=1:length(new_value)
    
    b = new_value(i);
    c = b{1};
    
    if or(or(c(1)=='T',c(1)=='L'),c(1)=='A')==1
        new_past_value=[new_value(i) new_past_value];
    else
        new_past_value = new_past_value;
    end
end

 % Finds path of the result file to plot.
 if (get(handles.pushbutton3,'Value'))==1
    for k = 1:length(index_listbox3)
    temp_1=strcat('target/results/',l_path_gui);
    temp_2=strcat(temp_1,'/',new_past_value(index_listbox3(k)));
    temp_path = sprintf('%s',temp_2{:});
    load_data = load(temp_path);
    axes(handles.axes3)
    
    % Loops every row of designated column (obj function, time, iteration,
    % etc). Uses natural log to plot. Special case if 0.
    
    % cb_checkbox_run==1 targets the Tabu search.
    if cb_checkbox_run==1
        
        for p = 1:length(load_data(1:end,2))
            
            if load_data(p,2)==0
                ln_data_1(p)=0;
            else
                ln_data_1(p)=log(load_data(p,2));
            end
        end
        
        
        for p = 1:length(load_data(1:end,4))
            
            if load_data(p,4)==0
                ln_data_2(p)=0;
            else
                ln_data_2(p)=log(load_data(p,4));
            end
        end
        
        
        
        for p = 1:length(load_data(1:end,5))
            
            if load_data(p,5)==0
                ln_data_3(p)=0;
            else
                ln_data_3(p)=log(load_data(p,5));
            end
        end
        
        
        for p = 1:length(load_data(1:end,6))
            
            if load_data(p,6)==0
                ln_data_4(p)=0;
            else
                ln_data_4(p)=log(load_data(p,6));
            end
        end
        
        plot(load_data(:,3),ln_data_1(:),'r',load_data(:,3),ln_data_2(:),'m',load_data(:,3),ln_data_3(:),'b',load_data(:,3),ln_data_4(:),'g');
        legend('Total Cost/Time','Dependency Cost/Time','Bounds Cost/Time','Overlap Cost/Time');

    % cb_checkbox_run==2 targets LNS, LNS-list and mathematical model.
    else cb_checkbox_run==2
        
        for p = 1:length(load_data(1:end,2))
            
            if load_data(p,2)==0
                ln_data_1(p)=0;
            else
                ln_data_1(p)=log(load_data(p,2));
            end
        end
        
        plot(load_data(:,3),load_data(:,2));
        legend('Total Cost/Time');
        
    end
    end
 end
 
 
 
 
 % --- Executes on selection change in listbox4.
 function listbox4_Callback(hObject, eventdata, handles)
     
     % --- Executes during object creation, after setting all properties.
     function listbox4_CreateFcn(hObject, eventdata, handles)
     
         if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)

% The user can refresh the result-listbox if new results are 
% present. Same procedure as listbox3 but waits for pushbutton.

global new_value

global l_path_gui

global value

if (get(handles.pushbutton4,'Value'))==1

B = dir('target/results/results_201*');
value = [];

for i = 1:length(B)

    value = [value; cellstr(getfield(B,{i},'name'))];

end

p = B(end);
l_path_gui = p.name;
temp_1=strcat('target/results/',l_path_gui);
temp_2=strcat(temp_1,'/*_*');

new_path = dir(temp_2);

new_value=[];
for i = 1:length(new_path)

    new_value = [new_value; cellstr(getfield(new_path,{i},'name'))];

end
new_past_value=[];
for i=1:length(new_value)
    
    b = new_value(i);
    c = b{1};
    
    if or(or(c(1)=='T',c(1)=='L'),c(1)=='A')==1
        new_past_value=[new_value(i) new_past_value];
    else
        new_past_value = new_past_value;
    end
end

end

get(handles.listbox3,'Value');
set(handles.listbox3,'String',new_past_value);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)

% Checks which checkbox that's been pushed and then presents
% either statistical data or plain data. Each time the Show-
% -button has been pushed, the data is saved in the result-path.

global new_value

global test_data_value

global l_path_gui

global checkbox_result_table

B_2 = dir('target/results/results_201*');
value_2 = [];

for i = 1:length(B_2)

    value_2 = [value_2; cellstr(getfield(B_2,{i},'name'))];

end


new_value_name = new_value;

% Removes unwanted strings.
for new_val_it = 1:length(new_value)
    new_value_temp_1 = strrep(new_value(new_val_it),'result_',' ');
    
    temp_number =  strrep(new_value_temp_1,num2str(new_val_it),' ');
    
    new_value_temp_2 = strrep(temp_number,'_',' ');
    new_value_name(new_val_it) = new_value_temp_2;

end

oldData=[];

new_past_value=[];
for i=1:length(new_value)
    
    b = new_value(i);
    c = b{1};
    
    if or(or(c(1)=='T',c(1)=='L'),c(1)=='A')==1
        new_past_value=[new_value(i) new_past_value];
    else
        new_past_value = new_past_value;
    end
end

 % Loads all the result files and targets each columns last row.
for iter_1 = 1:length(new_past_value)
    
    temp_1=strcat('target/results/',l_path_gui);
    temp_2=strcat(temp_1,'/',new_past_value(iter_1));
    temp_path = sprintf('%s',temp_2{:});
    
    temp_load = load(temp_path);
    
    max_iter(iter_1) = temp_load(end,1);
    
    max_cost(iter_1) = temp_load(end,2);
    
    max_time(iter_1) = temp_load(end,3);
    
end

    % checkbox_result_table==2 will display a simple data-table.
    if checkbox_result_table==2
        cnames = {'Solve','Data set','Max Iteration','Max Cost','Max Time'};
        
        s = char(new_past_value);
        a = 0;

        
        j=1;
        a=[1];
        
        % Counts the amount of same data-sets.
        for i = 1:length(new_past_value)-1

            
            b = s(i,2:1:5)==s(i+1,2:1:5); 
            
            if and(b(1),b(2))==1 
                a(j) = a(j) + 1;
                if i==length(new_past_value)-1
                   a(j) = a(j) + 1;
                end
            elseif and(b(1),b(2))==0 
                a = [a 0];
                j=j+1;
                a(j)=1;
            end
        end
        
        l=1;
         
        % Builds the table with full data-set name, e.g. "A10_4".
        for iter_2 = 1:length(new_past_value)
        
             if s(iter_2,4)=='0'
               
              data_table= [cellstr(s(iter_2,1)),cellstr(s(iter_2,3:1:6)),max_iter(iter_2),max_cost(iter_2),max_time(iter_2)];
              oldData = [oldData;data_table]; 
             else               
                 data_table= [cellstr(s(iter_2,1)),cellstr(s(iter_2,3:1:7)),max_iter(iter_2),max_cost(iter_2),max_time(iter_2)];
              oldData = [oldData;data_table];
             end
              
              
        end
        
        [m n]=size(oldData);
b = [];

 % Converts everything to strings to that uitable can use it.
 for i=1:m
    row=oldData(i,1:end);
    
    a = strcat(row{1},{' '},row{2}, {' '},mat2str(row{3}), {' '},mat2str(row{4}), {' '},mat2str(row{5}));
    b =[b a];
 end

 % Creates a file with the data-table "Plain Table".
%-----------------------------------------------------------
 fileID = fopen('plain_table.dat','w');
 
 fprintf(fileID,'%s\n',b{:});

 fclose(fileID);
%-----------------------------------------------------------
a=value_2(end);

 % Moves file from current directory to current result path.
movefile('plain_table.dat',strcat('target/results/',a{1}));
        
    % check_result_table==1 displays statistical table.
    elseif checkbox_result_table==1
        cnames = {'Solve','Data set','Upper prediction limit','Lower prediction limit','Mean Iteration','Mean Time','Iteration standard deviation','Time standard deviation','Iteration Max','Time max','Iteration min','Time min','Failurekvot'};     
        
        s = char(new_past_value);
       
        
        j=1;
        a=[1];
           for i = 1:length(new_past_value)-1


        b = s(i,3:1:5)==s(i+1,3:1:5);

        if and(and(b(1),b(2)),b(3))==1 
            a(j) = a(j) + 1;
            c=a;
          elseif and(and(b(1),b(2)),b(3))==0
            a = [a 0];
            e=a;
            j=j+1;
            a(j)=1;
        end
    end
        l=1;
    a;
    
    load_t_values=load('t_dist_values_095.dat');
    
 % Computes statistical data for every data-type.
for i=1:length(a)
    
    meaniteration(i)=mean(max_iter(l:l-1+a(i)));
    meantime(i)=mean(max_time(l:l-1+a(i)));
    
    upper_lim(i)=meantime(i)+load_t_values(a(i),2)*std(max_time(l:l-1+a(i)))*sqrt(1+1/a(i));
    lower_lim(i)=meantime(i)-load_t_values(a(i),2)*std(max_time(l:l-1+a(i)))*sqrt(1+1/a(i));
    
    lower_lim(i) = max(lower_lim(i),0);
    
    iterationstandarddeviation(i)=std(max_iter(l:l-1+a(i)));
    timestandarddeviation(i)=std(max_time(l:l-1+a(i)));
    iterationmax(i)=max(max_iter(l:l-1+a(i)));
    timemax(i)=max(max_time(l:l-1+a(i)));
    iterationmin(i)=min(max_iter(l:l-1+a(i)));
    timemin(i)=min(max_time(l:l-1+a(i)));
    failurekvot(i)=(a(i)-sum(max_cost(l:l-1+a(i))==0,2))/a(i);
    l=l+a(i);
   
end

k=1;
        % Builds the table with full data-set name, e.g. "A10_4".
        for iter_3 = 1:length(a)
            if s(k,4)=='0'
            data_table= [cellstr(s(k,1)),cellstr(s(k,3:1:4)),upper_lim(iter_3),lower_lim(iter_3),meaniteration(iter_3),meantime(iter_3),iterationstandarddeviation(iter_3),timestandarddeviation(iter_3),iterationmax(iter_3),timemax(iter_3),iterationmin(iter_3),timemin(iter_3),failurekvot(iter_3)];
            oldData = [oldData;data_table];
            else
            data_table= [cellstr(s(k,1)),cellstr(s(k,3:1:5)),upper_lim(iter_3),lower_lim(iter_3),meaniteration(iter_3),meantime(iter_3),iterationstandarddeviation(iter_3),timestandarddeviation(iter_3),iterationmax(iter_3),timemax(iter_3),iterationmin(iter_3),timemin(iter_3),failurekvot(iter_3)];
            oldData = [oldData;data_table];
            end
            k=k+a(iter_3); 
        end
        
        [m n]=size(oldData);
b = [];

 % Converts everything to strings to that uitable can use it.
 for i=1:m
    row=oldData(i,1:end);
    
    a = strcat(row{1}, {' '},row{2}, {' '},mat2str(row{3}), {' '},mat2str(row{4}), {' '},mat2str(row{5}),{' '},mat2str(row{6}),{' '},mat2str(row{7}),{' '},mat2str(row{8}),{' '},mat2str(row{9}),{' '},mat2str(row{10}),{' '},mat2str(row{11}),mat2str(row{12}), {' '},mat2str(row{13}), {' '});
    b =[b a];
 end

 % Creates a file with the data-table "Statistics Table".
%-----------------------------------------------------------
 fileID = fopen('statistics_table.dat','w');
 
 fprintf(fileID,'%s\n',b{:});

 fclose(fileID);
%-----------------------------------------------------------
a=value_2(end);

 % Moves file from current directory to current result path.
movefile('statistics_table.dat',strcat('target/results/',a{1}));
    end

set(handles.uitable1,'data',oldData,'ColumnName',cnames);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)

% Plots the results chosen by the user (objective function /
% iteration).

global new_value

global l_path_gui

global index_listbox3

global load_data

global cb_checkbox_run

 % Same procedure as in pushbutton3.

new_past_value=[];
for i=1:length(new_value)
    
    b = new_value(i);
    c = b{1};
    
    if or(or(c(1)=='T',c(1)=='L'),c(1)=='A')==1
        new_past_value=[new_value(i) new_past_value];
    else
        new_past_value = new_past_value;
    end
end

if (get(handles.pushbutton6,'Value'))==1
    for k = 1:length(index_listbox3)
    temp_1=strcat('target/results/',l_path_gui);
    temp_2=strcat(temp_1,'/',new_past_value(index_listbox3(k)));
    temp_path = sprintf('%s',temp_2{:});
    load_data = load(temp_path);
    axes(handles.axes4)
    
    if cb_checkbox_run==1
    
        for p = 1:length(load_data(1:end,2))
    
        if load_data(p,2)==0
            ln_data_1(p)=0;
        else
        ln_data_1(p)=log(load_data(p,2));
        end
        end
    
        
        for p = 1:length(load_data(1:end,4))
    
        if load_data(p,4)==0
            ln_data_2(p)=0;
        else
        ln_data_2(p)=log(load_data(p,4));
        end
        end
       
        
        
        for p = 1:length(load_data(1:end,5))
    
        if load_data(p,5)==0
            ln_data_3(p)=0;
        else
        ln_data_3(p)=log(load_data(p,5));
        end
        end
        
        
        for p = 1:length(load_data(1:end,6))
    
        if load_data(p,6)==0
            ln_data_4(p)=0;
        else
        ln_data_4(p)=log(load_data(p,6));
        end
        end
        
    plot(load_data(:,1),ln_data_1(:),'r',load_data(:,1),ln_data_2(:),'m',load_data(:,1),ln_data_3(:),'b',load_data(:,1),ln_data_4(:),'g');
    legend('Total Cost/Iteration','Dependency Cost/Iteration','Bounds Cost/Iteration','Overlap Cost/Iteration');
        
         else cb_checkbox_run==2
        
        for p = 1:length(load_data(1:end,2))
    
        if load_data(p,2)==0
            ln_data_1(p)=0;
        else
        ln_data_1(p)=log(load_data(p,2));
        end
        end
        
        plot(load_data(:,1),load_data(:,2));
    legend('Total Cost/Iteration');
       
    end
    end
end


    
% --- Executes on button press in checkbox10.
function checkbox10_Callback(hObject, eventdata, handles)

% Checks along with checkbox11 if the user wants to solve with
% all sets or some specific sets.

global run_cb_files
if get(handles.checkbox10,'Value')==1
     run_cb_files=1; 
end

% --- Executes on button press in checkbox11.
function checkbox11_Callback(hObject, eventdata, handles)

global run_cb_files
if get(handles.checkbox11,'Value')==1
     run_cb_files=2; 
end


% --- Executes on button press in checkbox12.
function checkbox12_Callback(hObject, eventdata, handles)

% Checks along with checkbox13 if the user wants to present
% statistical results on the table or plain results.

global checkbox_result_table
if get(handles.checkbox12,'Value')==1
     checkbox_result_table=1; 
end

% --- Executes on button press in checkbox13.
function checkbox13_Callback(hObject, eventdata, handles)

global checkbox_result_table
if get(handles.checkbox13,'Value')==1
     checkbox_result_table=2; 
end


% --- Executes on button press in checkbox14.
function checkbox14_Callback(hObject, eventdata, handles)
    
global cb_checkbox_run

if get(handles.checkbox14,'Value')==1
    cb_checkbox_run=4;
end
