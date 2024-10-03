%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Program :: fk_main.m
%

% This code was obtained from:
% Naskar, T., and Kumar, J., (2022). MATLAB codes for generating dispersion 
% images for ground exploration using different multichannel analysis of 
% surface wave transforms, GEOPHYSICS 87: F15-F24.

% Modified by: Tarun naskar, Mrinal Bhaumik, Sayan Mukherjee and Sai Vivek Adari.
% Indian Institute of Technology Madras, India

% Last revision date:
% 03/10/2024
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% "fk_main.m" is a Matlab script to generate dispersion spectrum of using 
% f-k method. Users are encouraged to refer to the corresponding research 
% paper for a detailed explanation of the underlying concepts and methods.

% References: 

% Yilmaz, O., (1987). Seismic data processing: Society of Exploration Geophysicists,
% Tulsa Oklahoma; 526 pp.

% Gabriels, P., R. Snider, and G. Nolet, (1987). In situ measurements of shear-wave 
% velocity in sediments with higher mode Rayleigh waves: Geophysics, 35, 187-196.

% Naskar, T., and Kumar, J., (2022). MATLAB codes for generating dispersion 
% images for ground exploration using different multichannel analysis of 
% surface wave transforms, GEOPHYSICS 87: F15-F24.

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

% Output

% Phase velocity spectra


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
dv   = 1 ;

time_pad  = 8;
space_pad = 2;

Trace_normalisation = 'no'; % 'yes' or 'no'
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

%% f-k transform
[X,Y,C] = fk_fun(Data, T, fmin, fmax, vmin, vmax, S, dx, time_pad, space_pad);


%% Postprocessing and plot
C = C./max(C);

figure;
pcolor(X,Y,C); shading interp;
ylim([vmin vmax]); xlim([fmin fmax]); box off
set(gca,'YDir','normal'); colormap jet; axis xy; grid off
set(gca,'Ydir','normal','FontSize',11,'FontName','Times New Roman','TickDir','out');
xlabel('Frequency (Hz)','FontSize',12,'FontWeight','normal','FontName','Times New Roman');
ylabel('Phase velocity (m/s)','FontSize',12,'FontWeight','normal','FontName','Times New Roman');

% title('fk','FontSize',10,'FontName','Times New Roman');
%%
        