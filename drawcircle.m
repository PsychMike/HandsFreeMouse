
function [O]=drawcircle(I,C,r,n)
if nargin==3
    n=600;
end
theta=(2*pi)/n;% angle subtended at the centre by the sides
%orient one of the radii to lie along the y axis
%positive angle ic ccw
rows=size(I,1);
cols=size(I,2);
angle=theta:theta:2*pi;
%to improve contrast and help in detection
x=C(1)-r*sin(angle);%the negative sign occurs because of the particular choice of coordinate system
y=C(2)+r*cos(angle);
if any(x>=rows)|any(y>=cols)|any(x<=1)|any(y<=1)%if circle is out of bounds return image itself
    O=I;
    return
end
for i=1:n
I(round(x(i)),round(y(i)))=1;
end
O=I;
