clear, clc

% Genero due segnali discreti come sequenze casuali
Nx = 6;
Nh = 5;
x = randn(1,Nx); % randn genera numeri casuali con distribuzione Gaussiana
h = randn(1,Nh); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Convoluzione tramite doppia sommatoria
Ny = Nx + Nh - 1 % lunghezza dell'uscita y
y = zeros(1,Ny);
num_camp = zeros(1,Ny); 
% = numero di campioni del filtro utilizzati nella sommatoria per ogni
% campione dell'uscita y
for n = 0:Ny-1
    y(n+1) = 0;
    num_camp(n+1) = 0;
    for k = 0:Nx-1
        n_meno_k = n-k;
        if and(n_meno_k>=0,n_meno_k<=Nh-1)
            y(n+1) = y(n+1) + x(k+1)*h(n_meno_k+1);
            num_camp(n+1) = num_camp(n+1) + 1;
        end
    end
end
y
num_camp
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Convoluzione tramite funzione built-in di Matlab

% Calcolo di tutti i campioni non nulli dell'uscita y
y_matlab = conv(x,h) 

% Calcolo dei campioni di y calcolati usando tutti i campioni del filtro
y_matlab_valid = conv(x,h,'valid') 

% Calcolo dei campioni di y sullo stesso asse dei tempi del segnale x
y_matlab_same = conv(x,h,'same')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%