%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Program :: Phase_shift.m
%
% Coded by: Mrinal Bhaumik and Tarun naskar
% Indian Institute of Technology Madras, India

% Last revision date:
% 01/05/2024
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
Data = xlsread('dalmoro_24@2m_1s@1000ps_5m.xlsx');
% Data = xlsread('Nandanam_T_4s_source_2.5m@1m.xlsx');


fmin = 0;
fmax = 30;
vmin = 50;
vmax = 500;
T    = 1;
dx   = 2;
S    = 5;
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
