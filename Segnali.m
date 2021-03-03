%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RAPPRESENTAZIONE DI SEGNALI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear % Cancella tutte le variabili presenti in memoria
clc % Clear command window
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% asse dei tempi
dt = 0.1 % tempo di campionamento
t = (-250:250)*dt; % asse (vettore) dei tempi
N = length(t) % lunghezza del vettore dei tempi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% segnali nel tempo
Tx = 2;
tau_x = 1;
x = sinc((t-tau_x)/Tx);
figure
subplot(4,1,1), plot(t,x), grid, ylim([-1.2 1.2])
xlabel('tempo [s]'), title('x(t)')

Ty = 3;
tau_y = -1;
y = rectpuls((t-tau_y)/Ty);
subplot(4,1,2), plot(t,y), grid, ylim([-1.2 1.2])
xlabel('tempo [s]'), title('y(t)')

s = x + y; % somma
subplot(4,1,3), plot(t,s), grid
xlabel('tempo [s]'), title('somma')

z = x.*y; % prodotto
subplot(4,1,4), plot(t,z), grid
xlabel('tempo [s]'), title('prodotto')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Integrale = sommatoria moltiplicato per l'intervallo temporale tra due
% campioni successivi
Ax = sum(x)*dt
Ay = sum(y)*dt
As = sum(s)*dt
Az = sum(z)*dt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%













