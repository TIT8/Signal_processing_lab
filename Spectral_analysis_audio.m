%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPECTRAL ANALYSIS OF AN AUDIO SIGNAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 1
    clear, clc
    song = 3
    switch song
        case 1
            [y,Fs] = audioread('D:\OneDrive - Politecnico di Milano\RSEOS_2020_2021\Codes\Signals\01 Lonely Woman.m4a');
            whos
            Fs % Sampling Frequency [Hz]
        case 2 % change of pitch
            Fs = 44100;
            dt = 1/Fs;
            t = 0:dt:10;
            f0 = 440;
            f1 = 880;
            y = zeros(length(t),1);
            y(t<5) = cos(2*pi*f0*t(t<5));
            y(t>=5) = cos(2*pi*f1*t(t>=5));
        case 3 % chirp
            Fs = 44100;
            dt = 1/Fs;
            t = 0:dt:10;
            f0 = 440;
            k = 100;
            y = cos(2*pi*f0*t + pi*k*t.^2);
            y = y(:);
        otherwise
    end
    
    %
    player = audioplayer(y,Fs);
    play(player);
    % stop(player) % stop execution
    
    % time axis
    dt = 1/Fs;
    [N,N_tracce] = size(y);
    t = (0:length(y)-1)*dt;
    figure, plot(t,y), grid, xlabel('time [s]')
    % Fourier Transform
    Nf = 2^ceil(log2(N));
    [Y,f] = dft(y,t,Nf);
    figure, plot(f,abs(Y)), grid
    xlabel('frequency [Hz]')
    xlim([0 Fs/2])
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analysis by time blocks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% time window
T_oss = .1 % [s]
Nt = round(T_oss/dt)
Nf = 2^ceil(log2(Nt));
Nb = floor(N/Nt)
player = audioplayer(y,Fs);
play(player);
figure
for b = 1:Nb-1 
    ind = [1:Nt] + (b-1)*Nt;
    % spectral analysis
    [Y,f] = dft(y(ind,:),t(ind),Nf);
    plot(f,abs(Y)), grid, ylim([0 200])
    xlim([0 10e3])
    xlabel('frequency [Hz]'), drawnow
    while player.CurrentSample < b*Nt
    end
end
stop(player)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
