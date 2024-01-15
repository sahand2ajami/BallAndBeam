% Pipeline to process the raw experimental data
clc; clear; close all;
format compact

%% Convert .csv files to .mat format

start = 3; %Starting folder from 3, ignoring '.' and '..' in the directory
num_participants = 1;
stop = start + (num_participants - 1); %final folder depends on the number of participants

% This is where each participants' data are stored for this project
cd ('C:\Users\s2ajami\OneDrive - University of Waterloo\BallAndBeam-project\BallAndBeam\data\pilot')

% This function loops in every participant's folder and makes a .mat copy
% of their .csv data 
% Input: start and stop numbers for looping the participants' folders
csv2mat(start, stop)


