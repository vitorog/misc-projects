%Code found on http://people.mech.kuleuven.be/~bruyninc/matlab/cubic.m
function  [x] = cubic (a,b,c,d)

% [x] = cubic (a,b,c,d)
%
%   Gives the roots of the cubic equation
%         ax^3 + bx^2 + cx + d = 0    (a <> 0 !!)
%   by Nickalls's method: R. W. D. Nickalls, ``A New Approach to
%   solving the cubic: Cardan's solution revealed,''
%   The Mathematical Gazette, 77(480)354-359, 1993.
%   dicknickalls@compuserve.com

%  Herman Bruyninckx 10 DEC 1996, 19 MAY 1999
%  Herman.Bruyninckx@mech.kuleuven.ac.be 
%  Dept. Mechanical Eng., Div. PMA, Katholieke Universiteit Leuven, Belgium
%  <http://www.mech.kuleuven.ac.be/~bruyninc>
%
% THIS SOFTWARE COMES WITHOUT GUARANTEE.

if (abs(a)<eps) 
  printf('Coefficient of highest power must not be zero!\n'); 
  return; 
end;

x = NaN * ones(3,1);

xN = -b/3/a;
yN = d + xN * (c + xN * (b + a*xN));

two_a    = 2*a;
delta_sq = (b*b-3*a*c)/(9*a*a);
h_sq     = two_a * two_a * delta_sq^3;
dis      = yN*yN - h_sq;
pow      = 1/3;

if dis >= eps
  % one real root:
  dis_sqrt = sqrt(dis);
  r_p  = yN - dis_sqrt;
  r_q  = yN + dis_sqrt;
  p    = -sign(r_p) * ( sign(r_p)*r_p/two_a )^pow;
  q    = -sign(r_q) * ( sign(r_q)*r_q/two_a )^pow;
  x(1) = xN + p + q;
  x(2) = xN + p * exp(2*pi*i/3) + q * exp(-2*pi*i/3);
  x(3) = conj(x(2));
elseif dis < -eps
  % three distinct real roots:
  theta = acos(-yN/sqrt(h_sq))/3;
  delta = sqrt(delta_sq);
  two_d = 2*delta;
  twop3 = 2*pi/3;
  x     = [xN + two_d*cos(theta); ...
           xN + two_d*cos(twop3-theta); ...
           xN + two_d*cos(twop3+theta)];
else % abs(dis) <= -eps
  % three real roots (two or three equal):
  delta = (yN/two_a)^pow;
  x     = [xN + delta; xN + delta; xN - 2*delta];
end;

