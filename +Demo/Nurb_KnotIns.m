%function [new_xi,new_knots] = Nurb_KnotIns( p, xi, knots, u)
clc;clear;
p={2 2 2}
knots{1}=[0,0,0,0.25,0.5,0.75,0.75,1,1,1];
knots{2}=[0,0,0,0.25,0.5,0.75,0.75,1,1,1];
knots{3}=[0,0,0,0.25,0.5,0.75,0.75,1,1,1];
u=[0.375 0.5 0.5 0.75];
xi=[0.500000000000000,1.50000000000000,4.50000000000000,3,7.50000000000000,6,8.50000000000000];




Qw = xi;
UQ = knots;
uni = unique(u);
n = histc(u,uni);
for i = 1:length(uni)
    u = uni(i);
    r = n(i);
 %  [Qw, UQ] = KnotIns(p, Qw, UQ, u,r);
end
new_xi = Qw
new_knots = UQ

%end


function [Qw, UQ] = KnotIns(p, Pw, UP, u, r)
% Input: p, UP, Pw, u, r, 
% Output: UQ, Qw
import BasisFunction.IGA.NurbsBasisFunction
np = length(UP) - p - 2;
k = NurbsBasisFunction.FindSpan(np, p, u, UP);
k = k+1;
mp = np + p + 1;
nq = np + r;

for i = 1:k UQ(i) = UP(i);end
for i = 1:r UQ(k + i) = u;end                             %for i = 1 : r+s UQ(k + i) = u;end
for i = (k + 1):(mp + 1) UQ(i + r) = UP(i);end            %for i = (k + 1) : (mp + 1) UQ(i + r+s) = UP(i);end

for i = 1:(k - p) Qw(i) = Pw(i);end                       %for i = 1 : (k - p+s) Qw(i) = Pw(i);end
for i = k:(np + 1) Qw(i + r) = Pw(i);end                  %for i = (k - s) : (np + 1-s) Qw(i + r+s) = Pw(i+s);end      

for i = 1:(p + 1) Rw(i) = Pw(k - p + i - 1) ;end          %for i = 1 : (p - s + 1) Rw(i) = Pw(k - p + i-1+s) ;end

for j = 1:r
   L = k - p + j;                                           %L = k - p + j+s;
   for i = 1:(p - j + 1)                                  %for i = 1 : (p - j - s + 1)
       alpha = (u - UP(L + i - 1))/(UP(i + k) - UP(L + i - 1));
       Rw(i) = alpha * Rw(i + 1) + (1.0 - alpha) * Rw(i);
   end
    Qw(L) = Rw(1);
    Qw(k + r - j) = Rw(p - j + 1);                          %Qw(k + r - j) = Rw(p - j - s + 1);
end 

for i = (L + 1):k Qw(i) = Rw(i - L + 1);end               %for i = L + 1 : (k - s)    

end