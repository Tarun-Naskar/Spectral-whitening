function [Spectrum, freq, trial_v] = Modified_FJ_fun(fmin,fmax,V_min,V_max,dv,y,Fs,cha,r,Spec_Whitening,Trace_norm)


% Input: Parameters required enough to generate the dispersion image
% Output : Spectrum -  Rayleigh Wave Dispersio Spectrogram

%% Trace normalization 

if strcmp(Trace_norm,'yes')

    y = y./max(abs(y));

end


%% 1D Temporal Fourier Transform within the required frequency

S_x_w = fft(y,2*length(y));

[mm,~] = size(S_x_w);

% divide entire sampling frequency into Ns

F = (0:round(mm/2)-1)*Fs/mm;

freq_bin = round(fmin*mm/Fs+1):1:round(fmax*mm/Fs+1);
freq = F(freq_bin);                                       % Required Frequency Vector

S_x_w = S_x_w(freq_bin,:);                                % Required Fourier Transform

%% Spectral Whitening 

if strcmp(Spec_Whitening,'yes')

    norm = abs(S_x_w);
    
    norm(norm< 1e-08) = 1e-08; 

    S_x_w = S_x_w./norm;                                % Required Fourier Transform after spectral whitening

end

%% Cross Correlation between every pair of sensors based on the station indices

a = 1;

for ll = 1:cha-1

    R_req(:, a:a+cha-ll-1) = S_x_w(:, ll) .* conj(S_x_w(:, ll+1:end));
    
    a = a + cha - ll;

end

% Sort the pair of sensors in the increasing order of their spacings

[~, index] = sort(r,'ascend');

r_sort = r(index);
R_sort = R_req(:,index);

%% Spatial Stacking to improve the SNR

[r_new, ~, indx] = unique(r_sort);       % Find the stations with same spacings

R_stack = zeros(length(freq),length(r_new));

for kk = 1:length(freq)
    R_stack(kk, :) = accumarray(indx, R_sort(kk, :), [], @sum)./length(r_new);
end


%% F-J Spectrum Calculation


trial_v = V_min:dv:V_max;                       % Trial Velocity Vector

[Velo,freqq] = meshgrid(trial_v,freq);

k = 2* pi*freqq./Velo;                          % Wavenumber matrix [Frequency x Velocity]
kr = k.*reshape(r_new,1,1,[]);


hankel0 = besselh(0,2,kr);                      % Hankel function of second kind - Zeroth order

Spectrum=zeros(length(freq),length(trial_v));


for i = 1:length(r_new)-1

    dr = r_new(i+1)-r_new(i);

        Spectrum = Spectrum + (R_stack(:,i).*hankel0(:,:,i).*r_new(i) + R_stack(:,i+1).*hankel0(:,:,i+1).*r_new(i+1))*0.5*dr; 
    

end



Spectrum=abs(Spectrum)./max(abs(Spectrum),[],2);


end