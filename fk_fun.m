

%%                ########### This is a Function   ###############


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

% X - frequency axis
% Y - phase velocity axis
% C - dispersion spectra




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[X,Y,C]= fk_fun(Data, T, fmin, fmax, vmin, vmax, S, dx, time_pad, space_pad)


Fs    = length(Data)/T;               % sampling Rate
F_res = 1/T;                          % Frequency Resolution
N     = (1/F_res)*Fs;                 % Desired no of data per traces
f     = 1*(-N/2:N/2-1);               % Partial calculation of frequency (integer array)
f     = f/N*(N-1)/((1/F_res)-(1/Fs)); % Desired Frequency resolution

%% Spatial data padding
dx1 = dx/space_pad;
Data2 = zeros(size(Data,1),size(Data,2)*space_pad-(space_pad-1));
jj = 1:space_pad:size(Data2,2);
for ii = 1:size(Data,2)
    Data2(:,jj(ii)) = Data(:,ii);
end
Data = Data2; dx2 = dx1;

%%
n1   = time_pad*size(Data,2);
Data = fftshift(fft2(Data,N,n1),1);            % Performs 2D Fourier transform on field/synthetic data
Data = abs(abs(transpose(Data)));

x1   = S : dx2 : n1*dx2;                        % Creates the offset array
k1   = 1*(0:n1-1);
k1   = k1/n1*(length(x1)-1)/(max(x1)-min(x1));  % Calculates the wavenumbers
k1   = flip(k1);                                % Flip the wavenumber to bring largest wavenumbers to front

%% Truncating wavenumbers beyond the required range
kmin  = abs(f(2)-f(1))/vmax;
kmax  = fmax/vmin;
kmax1 = max(k1);

if(kmax>kmax1)
    lk_1 = find(k1<=kmin,1);
    k1=k1(1:lk_1);
    lk=1;
else
    lk_1=find(k1<=kmin,1);lk_2=find(k1<=kmax,1);
    k1=k1(lk_2:lk_1);
    lk=lk_2;
end

%% Truncating frequencies and dispersion data beyond the required range
lf_1 = find(f>=fmin,1);
lf_2 = find(f>=fmax,1);
f_1  = f(lf_1:lf_2);

C    = Data(lk:lk_1,lf_1:lf_2);                 % Truncating the dispersion data
cmax = max(max(abs(C)));
C    = C./cmax;                                 % Normalizing the dispersion data

%% Prepare the axis  for the final plot
[X,Y1] = meshgrid(f_1,k1);                 % Prepare frequency and wavenumber axis for 2D plot

n1 = length(f_1);
n2 = length(k1);
Y  = zeros(n2,n1);
for i1 = 1:n1
    for i2 = 1:n2
        Y(i2,i1) = f_1(i1)/Y1(i2,i1);        % Converting wavenumber to velocity
    end
end

end