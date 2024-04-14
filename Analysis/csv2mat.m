function [folderName, ax] = csv2mat(start, stop)
    phase_string = 'phase';
    MVC_string = 'MVC';
    % with'*.' dir will read folder names only
    folderName = dir('*');
    
    % i starts fom 3 becasue folderName first two elements are '.' and '..'
    for i = start:stop
% for i=12:12
        % go to the folder
        folderName = dir('*');
        folderName(i).name
        cd(folderName(i).name);
        folderName_phase = dir('*');
        % folderName_phase.name
        n_phase = length(folderName_phase) - 2;

        for k = 3:3+n_phase-1
            
%             folderName_phase(k).name
            if contains(folderName_phase(k).name, phase_string)
%              folderName_phase(k).name
                cd(folderName_phase(k).name);
                
                % with'*.csv' dir will read csv files only
                fileName = dir('*.csv');
            
                if ~isempty(fileName)
                    for j = 1:length(fileName)
                        % convert the '.csv' file into a '.mat' file. 
                         data = csv22mat(string(fileName(j).name));
                         
                        % (1:end-4) removes the '.csv' from the end of the fileName(4) letting matlab save delsys as a '.mat' file.
                        save(strcat(string(fileName(j).name(1:end-4)), ".mat"), "data");
                    end
                end

                % Search through the folders to find the folder EMG
                % which should contain the EMG data of each trial 
                % (excluding MVC)
                folderName = dir('*EMG');
                if ~isempty(folderName)
                    % Go to the folder EMG
                    cd(folderName.name)
                    

                    % Find the .csv files in the folder EMG
                    fileName = dir('*.csv');

                     
                    if ~isempty(fileName)
                        for j = 1:length(fileName)
                            % convert the '.csv' file into a '.mat' file. 
                            string(fileName(j).name);

                            [data, ax] = csvEMGmat(string(fileName(j).name), i);
                            
                            % (1:end-4) removes the '.csv' from the end of the fileName(4) letting matlab save delsys as a '.mat' file.
                            save(strcat(string(fileName(j).name(1:end-4)), ".mat"), "data");
                        end
                    end
                    % Go to the previous folder
                    cd ..
                end
                % Go to the previous folder
                cd ..

            % Go to the folder MVC, and convert the .csv file into .mat file    
            elseif contains(folderName_phase(k).name, MVC_string) 
%                 folderName_phase(k).name
% disp("MVC----------------")
                cd(folderName_phase(k).name);

                % with'*.csv' dir will read csv files only
                fileName = dir('*.csv');
                if ~isempty(fileName)
                    for j = 1:length(fileName)
                        % convert the '.csv' file into a '.mat' file. 
                         [data, ax] = csvEMGmat(string(fileName(j).name), i);
                         
                         
                        % (1:end-4) removes the '.csv' from the end of the fileName(4) letting matlab save delsys as a '.mat' file.
                        save(strcat(string(fileName(j).name(1:end-4)), ".mat"), "data");
                    end
                end
                % Go to the previous folder
                cd ..
            end
        end
        % go back to the main folder
        cd ..
    end
