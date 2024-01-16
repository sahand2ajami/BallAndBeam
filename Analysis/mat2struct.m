function SubjectData = mat2struct(start, stop, n_phase)

    % with'*.' dir will read folder names only
    folderName = dir('*');
    
    % i starts from 3 because folderName first two elements are '.' and '..'
    for i = start:stop
        % go to the folder
        cd(folderName(i).name);
        folderName_phase = dir('*');

        % Make the variable data as a matlab structure
        data = struct();

        % This is in participants folder and loops between each phase the
        % term k starts from 3 to ignore the first two elemets '.' and '..'
        for k = start:start+n_phase-1
            
            % Go through each phase folder
            cd(folderName_phase(k).name);
            
            % read .mat files only
            fileName = dir('*.mat');

            % Saves the .mat files into the data structure only if the
            % folder is not empty
            if ~isempty(fileName)
                for j=1:length(fileName)
                    phase_name = string(folderName_phase(k).name);
                    data_name = string(fileName(j).name(1:end-4));
                    % load the .mat data into the data structure
                    my_file = load(fileName(j).name);
                    for trialnumber = 1:max(my_file.data.TrialNumber)
                        data.(strcat('S', '_', folderName(i).name(1:2))).(phase_name).(strcat("trial", num2str(trialnumber))).(data_name) = my_file.data(my_file.data.TrialNumber==trialnumber, :);
                        SubjectData = data;
                    end
                end
            end
    
            % go back to the previous folder
            cd ..
        end
        % go back to the previous folder
        cd ..
    end
    
end