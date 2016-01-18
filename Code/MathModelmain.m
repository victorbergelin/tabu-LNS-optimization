function status = MathModelmain(dataParameters, tabuParameters, logfileParameters, resultParameters)
%%
% This code selects the correct data-file for the mathematical 
% model to solve. It finds the result file and manipulate it 
% in order to be used for the GUI table and plots. 
%
%
% Made by: Hendric Kjellström

status = 0;

try
    
    
    
    % Get data from dataParameters:
    ampl_data_name = horzcat(dataParameters.path,'AMPL.dat');
    ampl_mod_name = 'src/main/ampl/MathModel.mod';
    ampl_res_name = 'src/main/ampl/MathModel.res';
    
    % Open and replace fields in files:
    fin = fopen('Mathmodel.run','rt');
    fout = fopen('Mathmodel_clone.run','wt');
    while ~feof(fin)
        s = fgets(fin);
        s = strrep(s, '***DATAFILE***', char(ampl_data_name));
        s = strrep(s, '***MODFILE***', char(ampl_mod_name));
        s = strrep(s, '***RESFILE***', char(ampl_res_name));
                
        fprintf(fout,'%s\n',s);
    end
    fclose(fin);
    fclose(fout);
    close_msgbox1 = msgbox('Wait');
    
    
    % Run Mathematical Model
    system('module add cplex/12.5-fullampl; ampl < Mathmodel_clone.run  >/dev/null')
    
    delete(close_msgbox1);
    msgbox('Finished')
    
    % Creates a result and deletes unnecessary spaces and words
    fid = fopen('MathModel.res','r');
    initial_res_LNS_gui = fscanf(fid,'%s\n');
    initial_res_LNS_gui = strrep(initial_res_LNS_gui,'total_cost=',sprintf('\n'));
    initial_res_LNS_gui = strrep(initial_res_LNS_gui,'number_of_iterations=',sprintf('\n'));
    initial_res_LNS_gui = strrep(initial_res_LNS_gui,'time_elapsed=',sprintf('\n'));
    initial_res_LNS_gui = strrep(initial_res_LNS_gui,'iteration_time=',sprintf('\n'));
    result_vector_LNS = str2num(sprintf(initial_res_LNS_gui,'%s'));
    
    % Builds result matrix for GUI
    for LNS_res_it = 1:(length(result_vector_LNS)/4)
    
       result_matrix_LNS(LNS_res_it,1) = result_vector_LNS(2+4*(LNS_res_it-1));
       result_matrix_LNS(LNS_res_it,2) = result_vector_LNS(1+4*(LNS_res_it-1));
       result_matrix_LNS(LNS_res_it,3) = result_vector_LNS(3+4*(LNS_res_it-1));
    end
    fclose(fid);
    
    % Save result
    resultPath = resultParameters.path;
    
    % Create result file
    filename = strsplit(dataParameters.path,'/');
    resultPath = [resultPath,'/M_',char(filename(end-1))];
    
    try
        Resultfile = fopen(resultPath, 'wt');
    catch err
        status = -1;
        rethrow(err)
    end
    
    % Save result
    fprintf(Resultfile,'%14.3f %14.3f %14.3f\n',result_matrix_LNS(:,:).');  % The format string is applied to each element of a
    
    status = 1;
catch err
    disp(getReport(err,'extended'))
    % In case of an error, set statuscode to -1
    status = -1;
end


end
