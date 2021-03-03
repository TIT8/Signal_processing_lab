clear, clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONVOLUTION VIA FOURIER TRANSFORM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Signals
Nx = 10
Ny = 5
x = randn(Nx,1);
y = randn(Ny,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fourier Transform
tx = (0:Nx-1);
ty = (0:Ny-1);

Nf = 15 % how to set the minimum number of samples in the frequency domain?
[X,f] = dft(x,tx,Nf);
[Y,f] = dft(y,ty,Nf);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Anti-transform
xx = idft(X,f,tx);
yy = idft(Y,f,ty);
txx = (0:length(xx)-1);
tyy = (0:length(yy)-1);

figure
subplot(3,1,1), plot(tx,x,txx,xx,'r'), grid
xlabel('samples'), title('x')
subplot(3,1,2), plot(ty,y,tyy,yy,'r'), grid
xlabel('samples'), title('y')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Convolution between x and y
z = conv2(x,y);
Nz = length(z)
tz = (0:Nz-1);
% Convolution using the FT
Z = X.*Y;
zz = idft(Z,f,tz);
Nzz = length(zz)
tzz = (0:Nzz-1);
whos z zz
subplot(3,1,3), plot(tz,z,tzz,zz), grid
xlabel('samples'), title('z')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


