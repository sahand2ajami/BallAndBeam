function [Score, Q] = NASATLXCalculator(fileContent)

    % TLX categories in each phase (extracting the questions)
    Q = table2array(fileContent(:, 49:54));
    % where Q is 19x6 matrix for 19 participants and 6 questions     

    % Normalize with the max range of score
    Q_normalized = Q / 21;

    % Weight for each question
    w = [20, 20, 20, 20, 10, 10]';

    % Overall score (out of 100)
    Score = Q_normalized * w;



end

