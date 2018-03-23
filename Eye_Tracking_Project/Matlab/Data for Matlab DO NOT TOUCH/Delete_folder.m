% Bestimmte Dateien löschen

% Tina Weis (November 2014)

clear all 
close all
clc

datapath = 'H:\Data for Matlab DO NOT TOUCH\Data';

load(['H:\Data for Matlab DO NOT TOUCH\Data\subjects.mat']);
        
for sub = 1:length(subjects)
        
   delete([datapath filesep subjects{sub} filesep 'RT_' subjects{sub} '.mat'])
   
end;

