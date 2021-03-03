y=randn(1,1000); 
z=randn(1,1000); 
a=0.1; 
x=a*y+z;
R=corrcoef(x',y')
y=randn(1,100); 
z=randn(1,100); 
a=0.1; 
x=a*y+z; 
plot(x,y ,'o')
axis([-3 3 -3 3]) 
R=corrcoef(x',y')
y=randn(1,100); z=randn(1,100); a=0.1; x=a*y+z; plot(x,y ,'o')
axis([-3 3 -3 3])