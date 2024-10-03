%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Program :: Phase_shift.m
%
% Coded by: Mrinal Bhaumik, Tarun naskar, Sayan Mukherjee and Sai Vivek Adari.
% Indian Institute of Technology Madras, India

% Last revision date:
% 03/10/2024
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% "Phase_shift.m" is a Matlab script to generate dispersion spectrum of using 
% phase_shift method. Users are encouraged to refer to the corresponding research 
% paper for a detailed explanation of the underlying concepts and methods.

% Reference:
% Park, C.B., R.D. Miller, R.D., and J. Xia, 1998, Imaging dispersion curves
% of surface waves on multichannel record: Society of Exploration of Geophysics,
% 68th Annual Meeting, New Orleans, Louisiana, 1377-1380.

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

% Output

% Phase velocity spectra


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%__________________________________________________________________________
%__________________________________________________________________________


clc
clear all

%% Insert data
% Data = xlsread('');
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
dv   = 1 ;
time_pad  = 4;

[f,c,FV] = phase_shift_fun(Data, T, fmin, fmax, vmin, dv, vmax, S, dx, time_pad);

%% Plot

FV = FV./max(FV);
figure; pcolor(f,c,FV); shading interp;
colormap jet; axis xy; box off;
ylim([vmin vmax]);xlim([fmin fmax]);
set(gca,'Ydir','normal','FontSize',11,'FontName','Times New Roman','TickDir','out');
xlabel('Frequency (Hz)','FontSize',12,'FontWeight','normal','FontName','Times New Roman');
ylabel('Phase velocity (m/s)','FontSize',12,'FontWeight','normal','FontName','Times New Roman');

title('Phase shift','FontSize',10,'FontName','Times New Roman');

%%
