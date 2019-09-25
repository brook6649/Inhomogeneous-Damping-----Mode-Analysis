function [SWR,e,W_pos,W_neg,k0] = SWR_calculation(t,w,freq,w_t0)

 omega = 2*pi*freq;    % angular frequency
 c = 200;              % wave velocity
 k0 = omega/c;         % wave number

% clear M
% load M_Damp     % load freq_DAMP

% w_t0 = Mode2time(M,freq_damp,500,100);


% calculate the First Covariance Matrix
% The requied input "w_t0" is calculated in script "calc_SWR_harmonic",
% where "mode2time.m" is called

b = [w_t0; w];        % Here " w " is 2-D, !! Because "SWR_calculation()" takes only 
                      %                         a layer(2-D) of matrix "w" as input.             

A = zeros( size(w,1)+1 ,3 );
A(:,3) = 1;  A(1,2) = 1;    % A(1,1) = 0 as indicated in the thesis;

% Warning: A is rank deficient to within machine precision. But the results
% are still acceptable.

for k = 1:size(w,1)
    
    A(k+1,1) = cos( omega* t(k) );     % x-dimension of " A " is identical to " ntime + 1 "
    A(k+1,2) = sin( omega* t(k) );     % as indicated in the thesis
    endh

% least square solver
X = lscov(A,b);

% now, the Second Covariance Matrix

B = zeros(size(X,2),5);  % First dimension "size(X,2)" = "second dimension of b" is very important to understand

for p = 1:size(X,2)
    
    B(p,1) = X(1,p)^2;
    B(p,2) = X(2,p)^2;
    B(p,2) = X(1,p)*X(2,p);
    B(p,4) = X(1,p);
    B(p,5) = X(2,p);
end

R = ones( size(X,2) ,1 );

% least square solver 
alpha = lscov(B,R);

% A0 and B0 are middel points of the ellipse

% A0 = ( alpha(3)*alpha(5) - 2*alpha(2)*alpha(4) )/( 4*alpha(1)*alpha(2) - alpha(3)^2 );

% B0 = ( alpha(3)*alpha(4) - 2*alpha(1)*alpha(5) )/( 4*alpha(1)*alpha(2) - alpha(3)^2 );

% weighting matrix D 
d11 = alpha(1);   d22 = alpha(2);  d12 = alpha(3)/2;
D = [d11 d12;d12 d22];

% lambda
lambda = eig(D);
% disp(lambda)
% SWR               |W+|: W_pos;      |W-|: W_neg;
W_pos = 0.5*( 1/sqrt( max(lambda) ) +  1/sqrt( min(lambda) ) ) ;
W_neg = 0.5*( 1/sqrt( min(lambda) ) -  1/sqrt( max(lambda) ) ) ;

% disp(['W_pos:',num2str(W_pos),'; W_neg:',num2str(W_neg)])

SWR = ( abs(W_pos) + abs(W_neg) )/( abs(W_pos) - abs(W_neg) );
e = 1/SWR;

end