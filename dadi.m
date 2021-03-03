Nt = 1e4; d = randi(3,2,Nt);
X = d(1,:); Y = d(1,:) + d(2,:);
x = min(X):max(X);  y = min(Y):max(Y);
Nx = length(x); Ny = length(y); P = zeros(Nx,Ny);
for jx = 1:Nx
    for jy = 1:Ny
        P(jx,jy) = sum(X==x(jx) & Y==y(jy));
    end
end
Pxy = P/Nt;
my_bar3(P', 1)
