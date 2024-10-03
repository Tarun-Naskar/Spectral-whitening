

%%                ########### This is a Function   ###############

% Input:

% Data      - Common shot gather data
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

% f    - frequency axis
% c    - phase velocity axis
% amp  - Phase velocity spectra

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[f, c, amp] = HRLRT_fun(Data, T, fmin, fmax, vmin, dv, vmax, S, dx,...
    maxitr_inner, maxitr_outer, lamda, pad)

warning off;

Data(isnan(Data))=0;
Fs   = length(Data)/T;                 % sampling Rate
c    = vmin : dv : vmax; %velocity vector

%% time domain data padding
Data_new = Data;
Data1    = zeros(max(size(Data_new))*pad,min(size(Data_new)));
Data1(1:max(size(Data_new)),:) = Data_new(1:end,:);

%% Run script
Tmax = max(size(Data1))/Fs;
x = S+(0:dx:(min(size(Data1))-1)*dx); %Geophone array
f = fmin:1/Tmax:fmax; %frequency vector

%% Time domain to frequency domain fourier transform
X = fft(Data1);
X = X(fmin*Tmax+1:fmin*Tmax+length(f),:);
X(isnan(X))=0;
X = transpose(X);

%% Distance to velocity domain linear Radon transform
V   = length(c); M = length(x);
amp = zeros(V,length(f));
I   = eye(V,V);
c_1 = repmat((1./c)',1,M);
x_1 = repmat(x,V,1);
xc  = c_1.*x_1;
xc  = transpose(xc);

parfor a = 1:length(f)
    L = exp(-1i*2*pi*f(a)*xc);
    d = X(:,a);
    LT=L';
    m = L'*d;
    r = L*m-d;
    s = [];ss = [];
    epsilon = prctile(abs(d),2);
    nu = repmat(prctile(abs(m),2),V,1);
    
    nitr_out = 1;
    while nitr_out <= maxitr_outer
        
        Wm             = (abs(m)).^(-1/2);
        Wm(abs(m)<=nu) = (nu(abs(m)<=nu)).^(-1/2);
        
        Wr             = (abs(std(r)).^(-1/2));
        Wr(abs(std(r))<=epsilon) = epsilon.^(-1/2);
        
        if nitr_out==1
            r = Wr.*r;
        else
            r = Wr.*(L*(m_pi./Wm)-d);
        end
        
        mp = (LT.*Wr)./Wm;
        m  = (mp*(Wr.*(L./Wm'))+lamda*I)\(mp*(Wr.*d));
        
        niter_in = 0;
        while niter_in <= maxitr_inner
            
            del_m = mp*r;
            del_r = Wr.*(L*(del_m./Wm));
            
            [m,r,s,ss] = cgstep(niter_in,V,m,del_m,s,M,r,del_r,ss);
            niter_in   = niter_in+1;
        end
        m_pi = m;
        m    = m./Wm;
        r    = r./Wr;
        nitr_out=nitr_out+1;
        
    end
    amp(:,a)=m;
    
end
amp = abs(amp);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%  CGSTEP %%%%%%%%%%%%%%
function [m,r,s,ss]=cgstep(niter_in,V, m, del_m, s, M, r, del_r, ss)
if niter_in==0
    
    s=zeros(V,1);ss=zeros(M,1);
    if (del_r'*del_r)==0
        error('del_r = 0');
    end
    
    alfa =  (del_r'*r) /(del_r'*del_r);
    beta = 0;
    
else
    
    gdg = del_r'*del_r;
    sds = ss'*ss;
    gds = del_r'*ss;
    determ = gdg*sds - gds*gds + (.00001*(gdg*sds)+1e-15);
    
    gdr = del_r'*r;
    sdr = ss'*r;
    alfa = ( sds * gdr - gds * sdr ) / determ;
    beta = (-gds * gdr + gdg * sdr ) / determ;
end

s = alfa * del_m + beta * s;

ss = alfa * del_r + beta * ss;

m = m + s;
r = r - ss;

end