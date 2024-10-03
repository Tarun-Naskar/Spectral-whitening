%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Program :: HRLRT_main.m
%
% Coded by: Tarun naskar, Mrinal Bhaumik, Sayan Mukherjee and Sai Vivek Adari
% Indian Institute of Technology Madras, India

% Last revision date:
% 03/10/2024
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% "HRLRT_main.m" is a Matlab script to generate dispersion spectrum of using 
% HRLRT method. Users are encouraged to refer to the corresponding research 
% paper for a detailed explanation of the underlying concepts and methods.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Input:

% fmin      - Minimum frequency of velocity spectra
% fmax      - Maximum frequency of velocity spectra
% vmin      - Minimum velocity of velocity spectra
% vmax      - Maximum velocity of velocity spectra
% T         - Recording time
% dx        - sensor spacing
% S         - Source to 1st receiver distance
% dv        - velocity resolution of phase velocity spectra
% time_pad  - zero pading
% space_pad - insert vertual receivers
% maxitr_inner - max no. of inner iteration for LRT
% maxitr_outer - max no. of outer iteration for LRT
% lamda        - damping parameter for LRT

% Output

% Phase velocity spectra

% This code contain parallel pool. It takes few seconds for the first run.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%__________________________________________________________________________
%__________________________________________________________________________

clc
clear all

%% Insert data

Data = xlsread('Nandanam_4s_2.5m@1m.xlsx');
% Data = xlsread('iisc_aerofield noisy_2s_2.5m@0.5m.xlsx');
% Data = xlsread('Love_2s_5m@1m.xlsx');
% Data = xlsread('dalmoro_1s_5m@2m.xlsx');

fmin = 10;
fmax = 100;
vmin = 50;
vmax = 400;
T    = 4;
dx   = 1;
S    = 2.5;
dv   = 2 ;
maxitr_inner = 5; % max no. of inner iteration for LRT
maxitr_outer = 3; % max no. of outer iteration for LRT
lamda        = 1; % damping parameter for LRT
pad          = 1;

Trace_normalisation = 'yes'; % 'yes' or 'no'
Spectral_whitening  = 'yes'; % 'yes' or 'no'

%% Preprocessing

% Trace normalization
if strcmp(Trace_normalisation,'yes')
    Data = Data./(max(abs(Data)));
end

% Spectral whitening
if strcmp(Spectral_whitening,'yes')
    Data = ifft(fft(Data) ./ abs( fft(Data) ) );
end

%% HRLRT
[f, c, amp] = HRLRT_fun(Data, T, fmin, fmax, vmin, dv, vmax, S, dx, maxitr_inner, maxitr_outer, lamda, pad); 

%% Postprocessing and plot

normed_amp = amp./(max(amp));

figure; pcolor(f,c,normed_amp); shading interp; colormap jet;
ylim([vmin vmax]); xlim([fmin fmax]); box off
set(gca,'YDir','normal'); colormap jet; axis xy;
set(gca,'Ydir','normal','FontSize',11,'FontName','Times New Roman','TickDir','out');
xlabel('Frequency (Hz)','FontSize',12,'FontWeight','normal','FontName','Times New Roman');
ylabel('Phase velocity (m/s)','FontSize',12,'FontWeight','normal','FontName','Times New Roman');
title('HRLRT (in, out itr =',num2str([ maxitr_inner maxitr_outer]),'fontweight','bold','fontsize',10);

%%