%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STIMA DI VALORE ATTESO E AUTOCORRELAZIONE DI UN PROCESSO STAZIONARIO
% VENGONO CONSIDERATI DUE APPROCCI
% 1) STIMA TRAMITE MEDIE SULLE REALIZZAZIONI
% 2) STIMA TRAMITE MEDIE TEMPORALI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear, clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GENERAZIONE DI Nr REALIZZAZIONI INDIPENDENTI DI UN PROCESSO FILTRATO
dt = 1e-3; % tempo di campionamento
t = (0:5000)*dt; % asse dei tempi
Nt = length(t);
Tobs = Nt*dt % tempo di osservazione
Nr = 100; % numero di realizzazioni

% generazione di una matrice di Nr x Nt variabili Gaussiane con media nulla
% e varianza unitaria
x = randn(Nr,Nt); 

% Filtro: l'istruzione fir1(L,B*dt) genera la risposta all'impulso 
% di un filtropassa-basso di durata L+1 campioni e di banda (in Hz) 
% pari a B 
h = fir1(50,.1); % risposta all'impulso del filtro (vettore riga)

% Convoluzione
x = conv2(x,h,'same')*dt;

figure
for n = 1:4 % displays the first four realizations
    subplot(4,1,n), plot(t,x(n,:)), grid
    xlabel('tempo [s]'), title(['x_' num2str(n) '(t)'])
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STIMA TRAMITE MEDIE SULLE REALIZZAZIONI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stima di valore atteso e Potenza ( = varianza, dato che E[x] = 0)
Ex_stim = 1/Nr*sum(x,1); 
Px_stim = 1/Nr*sum(x.^2,1);
figure,
subplot(2,1,1), plot(t,Ex_stim), grid
xlabel('tempo [s]'), title('Stima di E[x]')
subplot(2,1,2), plot(t,Px_stim), grid
xlabel('tempo [s]'), title('Stima di Px')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stima dell'autocorrelazione tramite media sulle realizzazioni
n_max = 100;
tau = (-n_max:n_max)*dt; % asse temporale per l'autocorrelazione
Rx_stim = zeros(2*n_max+1,Nt);
for n = -n_max:n_max
    xxx = x.*circshift(x,[0 n]); % circshift = circular shift
    Rx_stim(n+n_max+1,:) = 1/Nr*sum(xxx,1);
end
figure
imagesc(t,tau,Rx_stim), colorbar, axis xy
xlabel('tempo [s]'), ylabel('tau = differenza di tempo [s]')
title('Stima di R_x(tau,t)')
Rx_stima_realizzazioni = Rx_stim;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STIMA TRAMITE MEDIE TEMPORALI, SOTTO L'ASSUNZIONE DI STAZIONARIETà
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stima di valore atteso e Potenza ( = varianza, dato che E[x] = 0)
Ex_stim = 1/Tobs*sum(x,2)*dt;
Px_stim = 1/Tobs*sum(x.^2,2)*dt;
figure,
subplot(2,1,1), plot(1:Nr,Ex_stim), grid
xlabel('realizzazioni'), title('Stima di E[x]')
subplot(2,1,2), plot(1:Nr,Px_stim), grid
xlabel('realizzazioni'), title('Stima di Px')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STIMA DELLA DENSITà SPETTRALE DI POTENZA
% Trasformata di Fourier
Nf = 2*2^ceil(log2(Nt)); % numero di punti da calcolare in frequenza
% Trasformata di ogni realizzazione tramite la funzione dft
[X,f] = dft(transpose(x),t,Nf);
% la trasposizione serve perché la funzione dft lavoro lungo le colonne
X = transpose(X); % realizzazioni, frequenza
X = X*dt; % fattore di scala per consistenza dimensionale 
% (vedi le slide sulle trasformate numeriche)

% Densità Spettrale di Potenza
Sx_stim = 1/Tobs*abs(X).^2;
figure
for n = 1:4 % displays four realizations
    subplot(4,1,n), plot(f,Sx_stim(n,:)), grid
    xlabel('frequenza [Hz]'), title(['Stima di Sx_' num2str(n) '(f)'])
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AUTOCORRELAZIONE COME TRASFORMATA INVERSA DELLA DENSITà SPETTRALE DI
% POTENZA
Rx_stim = idft(transpose(Sx_stim),f,tau); 
Rx_stim = transpose(Rx_stim); % realizzazioni, tau
% Attenzione: l'autocorrelazione dev'essere reale perché il processo è
% reale.
% Controllo allora che la parte immaginaria sia attribuibile a piccoli
% errori numerici dovuti alla rappresentazione con un numero finito di bit
% (le variabili double di Matlab sono rappresentati con 8 Byte)
max_err_imag = max(abs(imag(Rx_stim(:))))
Rx_stim = real(Rx_stim); 

% Fattore di scala per consistenza dimensionale
% (!!!: la funzione idfft è basata sulla funzione built-in ifft, 
% che divide il risultato per il numero di punti in frequenza
df = f(2)-f(1);
Rx_stim = Rx_stim*df*Nf; 
%
figure
imagesc(tau,1:Nr,Rx_stim), colorbar, axis xy
xlabel('tau   [s]'), ylabel('realizzazioni')
title('Stima di R_x(realizzazioni,tau)')
Rx_stima_temporale = Rx_stim;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONFRONTO TRA I DUE APPROCCI
Rx1 = 1/Nt*sum(Rx_stima_realizzazioni,2); % media sui tempi
Rx2 = 1/Nr*sum(Rx_stima_temporale,1); % media sulle realizzazioni
figure
plot(tau,Rx2,tau,Rx1), grid
xlabel('tau [s]'), 
title('stima di R_x(tau)')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%







