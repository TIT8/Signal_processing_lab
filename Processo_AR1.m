%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PROCESSO AR(1)
% GENERAZIONE E STIMA DI DENSITà SPETTRALE DI POTENZA E AUTOCORRELAZIONE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear, clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GENERAZIONE DI Nr REALIZZAZIONI INDIPENDENTI
Nr = 1e3; % numero di realizzazioni
N = 1e4; % numero di campioni per ogni realizzazione

% Parametro del processo (x è stazionario solo per |a|<1)
a = .9;
% Varianza del processo wn
sigma2w = 2;

% Generazione
x = zeros(Nr,N);
for n = 2:N
    wn = sqrt(sigma2w)*randn(Nr,1);
    x(:,n) = a*x(:,n-1) + wn;
end

% Osservo una realizzazione
figure, plot(x(1,:)), grid
xlabel('campioni'), title(['andamento di x_n per a = ' num2str(a)])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STIMA DELLA DENSITà SPETTRALE DI POTENZA E CONFRONTO CON RISULTATO
% TEORICO
% Trasformata di Fourier
Nf = 2*2^ceil(log2(N)); % numero di punti da calcolare in frequenza
% Trasformata di ogni realizzazione tramite la funzione dft
[X,f] = dft(transpose(x),(0:N-1),Nf);
% la trasposizione serve perché la funzione dft lavora lungo le colonne
X = transpose(X); % realizzazioni, frequenza

% Densità Spettrale di Potenza
Sx_stim = 1/N*abs(X).^2;
% Media sulle realizzazioni
Sx_stim_med = 1/Nr*sum(Sx_stim,1);

% Densità Spettrale di Potenza teorica
H = 1./(1 - a*exp(-1i*2*pi*f));
Sx = sigma2w*abs(H.^2);

% Figure
figure, plot(f,Sx_stim_med,f,Sx), grid
xlabel('frequenza'), title('Densità Spettrale di Potenza')
legend('Stima','DSP Teorica')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STIMA DELL'AUTOCORRELAZIONE E CONFRONTO CON RISULTATO TEORICO
tau = (-50:50); % in campioni
Rx_stim_med = idft(transpose(Sx_stim_med),f,tau); 
Rx_stim_med = transpose(Rx_stim_med); 
% Attenzione: l'autocorrelazione dev'essere reale perché il processo è
% reale.
% Controllo allora che la parte immaginaria sia attribuibile a piccoli
% errori numerici dovuti alla rappresentazione con un numero finito di bit
% (le variabili double di Matlab sono rappresentati con 8 Byte)
max_err_imag = max(abs(imag(Rx_stim_med(:))))
Rx_stim_med = real(Rx_stim_med); 

% Fattore di scala per consistenza dimensionale
% (!!!: la funzione idfft è basata sulla funzione built-in ifft, 
% che divide il risultato per il numero di punti in frequenza
% Per questo script non si fa riferimento al tempo di campionamento, che
% pertanto viene assunto pari a 1 => df = 1/Nf
% => visto che ifft divide già per Nf, in questo caso non serve fare altro

% Autocorrelazione teorica
sigma2x = sigma2w/(1-a^2);
Rx = sigma2x*(a.^abs(tau));

% Figure
figure, plot(tau,Rx_stim_med,tau,Rx), grid
xlabel('tau [campioni]'), title('Autocorrelazione')
legend('Stima','Rx Teorica')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




