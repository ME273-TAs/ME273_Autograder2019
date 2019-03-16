%============================================BEGIN-HEADER=====
% FILE: main.m
% AUTHOR: Caleb Groves
% DATE: 14 August 2018
%
% PURPOSE:  
%   This script creates a GUI that allows you to control the autograder
%   functions.
%
% INPUTS:
%   None
%
%
% OUTPUTS:
%   None, though it will write out several files.
%
%
% NOTES:
%   
%
%
% VERSION HISTORY TRACKED WITH GIT
%
%==============================================END-HEADER======
close all;
clear;
clc;

L = labSetupFile(); % run lab setup file

G = AutograderGUI(L); % create gui object
