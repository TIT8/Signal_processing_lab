%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMPORTANTE: per garantire la compatibilità tra differenti versioni di
% Matlab, gli script dovranno fare uso delle seguenti funzioni:
%
% • Operazione matematiche: exp(), log(), abs(), angle(), +, -, * , /, .*, ./, .^p, sqrt()
%
% • Convoluzioni/filtraggi: conv( ), conv2( )
% 
% • Trasformate/Antitrasformate di Fourier: fft( ),fftshift( ), dft( ), idft( )
% 
% • Creazione di filtri: fir1( ), firls( )
% 
% • Istogrammi: hist( ), hist3( )
% 
% • Massimo/minimo di una funzione: max( ), min( )
% 
% • ricerca di un elemento: find()
%
% • Somma cumulata: cumsum( )
% 
% • media, varianza: mean( ), var( )
% 
% • inversione di matrici: inv( )
%
% • operazioni sui segnali: fliplr(), flipud(), conj(), circshift 
% 
% • rappresentazione di grafici/immagini: figure, subplot( ), plot( ),
% grid, imagesc( ), xlabel(), ylabel(), title()
% 
% • ascolto di file musicali: soundsc( )
%
% • caricamento file matlab: load nome_file
%
% L'uso di ulteriori funzioni di Matlab andrà preventivamente concordato
% con i docenti
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ESEMPI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creazione di un segnale causale complesso
Nt = 1e4;
x = randn(Nt,1);
y = randn(Nt,1);
z = x + 1i*y;
dt = .1; % tempo di campionamento
t = (0:Nt-1)*dt; % asse dei tempi
figure,
subplot(3,1,1), plot(t,real(z),t,imag(z)), grid
xlabel('tempo [s]'), title('real e imag')
subplot(3,1,2), plot(t,abs(z)), grid
xlabel('tempo [s]'), title('abs')
subplot(3,1,3), plot(t,angle(z)), grid
xlabel('tempo [s]'), title('fase')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filtraggio - si veda l'help di Matlab alla voce fir1
h_fir1 = fir1(30,.1); 
zf = conv2(z,h_fir1(:),'same');
figure
subplot(3,1,1), plot(t,abs(z)), grid
xlabel('tempo [s]'), title('abs(z)')
subplot(3,1,2), plot(t,abs(zf)), grid
xlabel('tempo [s]'), title('abs(z filtrato)')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filtraggio - si veda l'help di Matlab alla voce firls
h_firls = firls(30,[0 .1 .2 .5]*2,[.5 1 0 0]); 
zf = conv2(z,h_firls(:),'same');
subplot(3,1,3), plot(t,abs(zf)), grid
xlabel('tempo [s]'), title('abs(z filtrato)')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Trasformate di Fourier
th = (-15:15)*dt; % asse dei tempi dei filtri  (per convenzione centrati in 0)
[H1,f] = dft(h_fir1,th,128);
[H2,f] = dft(h_firls,th,128);
figure, plot(f,abs(H1),f,abs(H2)), grid
xlabel('frequenza [Hz]'), title('abs(H)')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filtraggio adattato 
dt = .1;
tg = (-200:200)*dt; % asse dei tempi (per convenzione centrati in 0)
% forma d'onda trasmessa
g = randn(1,length(tg)) + 1i*randn(1,length(tg));
% segnale - assumo ritardo di 40 campioni esatti
s = circshift(g,[0 40]); 
% filtro adattato: sf = s(t)*conj(g(-t))
sf = conv2(s,fliplr(conj(g)),'same');
figure, 
subplot(2,1,1), plot(tg/dt,abs(s)),grid
xlabel('campioni'), title('s(t)')
subplot(2,1,2), plot(tg/dt,abs(sf)),grid
xlabel('campioni'), title('s(t)*conj(g(-t))')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Istogrammi
[h,bin] = hist(real(z),100);
figure, plot(bin,h), grid
xlabel('parte reale'),title('istogramma')

[h,bin] = hist3([real(z) imag(z)],[100 100]);
figure
imagesc(bin{1},bin{2},h)
xlabel('parte reale'),ylabel('parte immaginaria'), title('istogramma')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Massimo di un segnale
[z_max,n_max] = max(abs(z))
t_max = t(n_max)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% somma cumulata
z_cum = cumsum(z);
figure, plot(t,abs(z_cum)), grid
% media, varianza
mean_z = mean(z)
var_z = var(z)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inversione di matrici
A = randn(5,5);
A_inv = inv(A)
A*A_inv
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Immagini
x = randn(1e3,1e3);
x = conv2(x,h_fir1(:),'same'); % filtraggio lungo le colonne
x = conv2(x,h_fir1(:)','same'); % filtraggio lungo le righe
figure
imagesc(x)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ascolto
fs = 44100; % frequenza di campionamento
dt = 1/fs;
f0 = 440;
t = (0:1e5)*dt;
alfa = 1e2;
t0 = 0;
x = cos(2*pi*f0*t + pi*alfa*(t-t0).^2);
soundsc(x,fs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ricerca
n = find(x>0); % trova le posizioni dei valori di x > 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

