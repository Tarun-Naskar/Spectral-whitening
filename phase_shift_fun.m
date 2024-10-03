
%%                ########### This is a Function   ###############
function[f,c,FV]  = phase_shift_fun(Data, T, fmin, fmax, vmin, dv, vmax, S, dx, time_pad)


N = size(Data,2);
L = length(Data);
Data1 = zeros(time_pad*L,N);
Data1(1:L,:) = Data;
Data = Data1;
T = time_pad*T;

%% Input requirements

f = 0: 1/T : fmax-1/T;
F = length(f);
B1 = fft(Data);
B1 = B1(1:F,:);
Uxw = B1;
R = Uxw./abs(Uxw);
R(isnan(R))=0;

xj = S:dx:((N-1)*dx) + S;


c = vmin:dv:vmax;
for w=1:1:F
    
    for n=1:1:N
        Vc=exp(1i*2*pi*f(w)*xj(n)./c)*R(w,n);
        Vc1(n,:)=Vc;
    end
    Vc2(w,:)=abs(sum(Vc1));
    
end
FV = transpose(Vc2);
FV = FV./max(max(FV));


end
