%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Program :: F_J_Main.m
%
% Coded by: Tarun Naskar, Vivek Adari, Mrinal Bhaumik and Sayan Mukherjee
% Indian Institute of Technology Madras, India

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% "F_J_Main.m" is a Matlab script to generate dispersion spectrum of using 
% Frequency-Bessel method. Users are encouraged to refer to the corresponding research 
% paper for a detailed explanation of the underlying concepts and methods.

% References: 

% 1. Wang (2019) : Frequency-Bessel Transform Method for Effective Imaging of Higher-Mode Rayleigh Dispersion Curves From Ambient Seismic Noise Data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Input:

% fmin      - Minimum frequency of velocity spectra
% fmax      - Maximum frequency of velocity spectra
% V_min     - Minimum velocity of velocity spectra
% V_max     - Maximum velocity of velocity spectra
% t         - Recording time
% del_x     - sensor spacing
% S         - Source to 1st receiver distance
% dv        - velocity resolution of phase velocity spectra


% Output

% Phase velocity spectra

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
close all
clearvars
dbstop if error

%% Load Seismic Data 

Data = readmatrix('D:\Vivek-7\PhD\References\Lab Papers\Spectral-whitening-main\Spectral-whitening-main\Zomo_10m_2mspac_5sec_noisy');


y = Data(:,1:end);                         % Modify to consider only few traces (if)  

[Ns, cha] = size(y); 
                                 

S = 10;                                   % Source to 1st geophone
del_x = 2;                                 % Spacing of geophones
t = 5;                                     % Total aquisition time;
dt = t/Ns;                                 % Sampling time
Fs = 1/dt;                                 % Sampling frequency

%% Required Frequency

fmin = 0;     % Minimum Frquency
fmax = 30;    % Minimum Frquency - Cannot be beyond Nyquist: Fs/2

%% Required Velocity

V_min = 100;
V_max = 900;
dv = 1;

%% Noise Removal

Trace_norm  = 'yes' ;         % 'yes' or 'no'     % Trace Normalizaton
Spec_Whitening = 'no';        % 'yes' or 'no'     % Spectral Whitening

%% Inter Distance between each sensor or reference sensor to other sensors

x = (S: del_x : S+(cha-1)*del_x);      % Receiver Distances from the source (Can be row or column vector)-Uniform spacing 

r = abs(nonzeros(tril(x' - x, -1)));       % Interstation spacings for different pairs of stations


%% F-J Dispersion Spectrum Calculation

tic

[Spectrum, freq, trial_v] = FJ_fun(fmin,fmax,V_min,V_max,dv,y,Fs,cha,r,Spec_Whitening,Trace_norm);

toc

%% Dispersion Imaging 

% figure();

[Velo,freqq] = meshgrid(trial_v,freq);


figure;
pcolor(freqq,Velo,Spectrum); shading interp;
ylim([V_min V_max]); xlim([fmin fmax]); box off
set(gca,'YDir','normal'); colormap jet; axis xy; grid off
set(gca,'Ydir','normal','FontSize',11,'FontName','Times New Roman','TickDir','out');
xlabel('Frequency (Hz)','FontSize',12,'FontWeight','normal','FontName','Times New Roman');
ylabel('Phase velocity (m/s)','FontSize',12,'FontWeight','normal','FontName','Times New Roman');

