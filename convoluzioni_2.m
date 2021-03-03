clear, clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Asse dei tempi del segnale
% tempo di campionamento
dt = 1e-2 % s
% tempo di osservazione
t_oss = 2; % s
t = (-t_oss/2:dt:t_oss/2);
Nt = length(t)

%  Asse dei tempi del filtro
th = (-50:50)*dt; %
Bh = .1/dt; % banda del filtro
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filtro
h = Bh*sinc(th*Bh);
% Segnale - scegliere uno dei 5 esempi assegnando alla variabile "segnale"
% un valore tra 1 e 5
segnale = 5
switch segnale
    case 1 % Bx<Bh
        Bx = Bh/2;
        x = sinc(t*Bx);
    case 2 % Bx>Bh
        Bx = Bh*2;
        x = sinc(t*Bx);
    case 3 % f0<Bh
        f0 = Bh/3;
        x = cos(2*pi*f0*t);
    case 4 % f0>Bh
        f0 = Bh*2;
        x = cos(2*pi*f0*t);
    case 5
        Bx = Bh;
        x = sinc((t-.5)*Bx);
    otherwise
end

y = conv2(x,h,'same')*dt;

figure
subplot(3,1,1), plot(t,x), grid, xlabel('tempo [s]'), ylabel('x(t)')
subplot(3,1,2), plot(th,h), grid, xlabel('tempo [s]'), ylabel('h(t)')
xlim([t([1 end])])
subplot(3,1,3), plot(t,y), grid, xlabel('tempo [s]'), ylabel('y(t)')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%