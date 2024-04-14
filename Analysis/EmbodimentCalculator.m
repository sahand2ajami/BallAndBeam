function [overall_ownership, overall_agency, overall_tactile] = ...
    EmbodimentCalculator(fileContent)

% Embodiment categories in each phase
    ownership = table2array(fileContent(:, 19:21));
    ownership = ownership - 4;
    
    overall_ownership = (nanmean(ownership(:, 1), 2) - nanmean(ownership(:, 2), 2) - nanmean(ownership(:, 3), 2)) ;
    overall_ownership = overall_ownership / 3;
%     overall_ownership = (overall_ownership + 3) / 6;
    %     overall_ownership = (overall_ownership+9) / 18;

    agency = table2array(fileContent(:, 21:25));
    agency = agency - 4;
    overall_agency = (nanmean(agency(:, 1), 2) + nanmean(agency(:, 2), 2) + nanmean(agency(:, 3), 2) - nanmean(agency(:, 4), 2));
    overall_agency = overall_agency / 4;
%     overall_agency = (overall_agency+4) / 8;

    tactile = table2array(fileContent(:, 26:28));
    tactile = tactile - 4;
    
    overall_tactile = (nanmean(tactile(:, 1), 2) - nanmean(tactile(:, 2), 2) + nanmean(tactile(:, 3), 2));
    overall_tactile = overall_tactile / 3; 
%     overall_tactile = (overall_agency+3) / 6;
end

