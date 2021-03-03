clear, clc

% time axis
dt = 1e-2; % s sampling time
t_obs = 2; % s total observation time

t = (-t_obs/2:dt:t_obs/2)'; % column vector
Nt = length(t);

% Signals
signal = 1
switch signal
    case 1 % rectangular pulse
        T0 = 1.01;
        x = double(rectpuls(t/T0));
    case 2 % delayed rectangular pulse
        T0 = 1;
        t0 = .3;
        x = double(rectpuls((t-t0)/T0));
    case 3 % complex sinusoid
        f0 = .1/dt;
        x = exp(1i*2*pi*f0*t);
    case 4 % cardinal sine
        B = .1/dt;
        x = sinc(t*B);
    otherwise
end

fig_time = figure;
subplot(2,1,1), plot(t,real(x)), grid, 
xlabel('time [s]'), ylabel('real part')
ylim([-2 2])
subplot(2,1,2), plot(t,imag(x)), grid, 
xlabel('time [s]'), ylabel('imaginary part')
ylim([-2 2])

% Definition of frequency points to be evaluated
Nf = 4*Nt; % number of points in the frequency domain
% frequency axis (as a column vector)
f = (-Nf/2:Nf/2-1)'/Nf/dt;
% frequency sampling interval
df = f(2)-f(1);
% Fourier Transform Matrix
W = exp(-1i*2*pi*f*t'); 

X = W*x*dt; % Fourier Transform of x

% comparison against theory
switch signal
    case 1 
        X_th = T0*sinc(f*T0);
    case 2
        X_th = T0*sinc(f*T0).*exp(-1i*2*pi*f*t0);
    case 3
        X_th = t_obs*sinc((f-f0)*t_obs);
        % calcolo esatto con seno cardinale periodico
        % dd = (f-f0)*T;
        % X_th = sin(pi*dd*Nt)./sin(pi*dd)*T;
    case 4
        X_th = 1/B*double(rectpuls(f/B));
    otherwise
end

fig_freq = figure;
subplot(2,1,1), plot(f,abs(X),f,abs(X_th)), grid, 
xlabel('frequency [Hz]'), ylabel('abs value')
subplot(2,1,2), plot(f,angle(X),f,angle(X_th)), grid, 
xlabel('frequency [Hz]'), ylabel('phase')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inverse Fourier Transform
y = W'*X*df;

figure(fig_time)
subplot(2,1,1), plot(t,real(x),t,real(y)), grid, 
xlabel('time [s]'), ylabel('real part')
subplot(2,1,2), plot(t,imag(x),t,imag(y)), grid,
xlabel('time [s]'), ylabel('imaginary part')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
