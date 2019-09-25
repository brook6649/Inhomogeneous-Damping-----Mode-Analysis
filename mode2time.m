function [w, t] = mode2time(M,freq,ntime,os_fac)

% calculate vibration pattern in a time range

% M - complex eigenvector
% freq - frequencies of vibration
% ntime - number of time signal samples 
% os_fac - over sampling factor for freq

% t - time vector
% w - vibration pattern


omega = 2*pi * freq;         % angular frequency
d_t = 1 / (freq*os_fac);     % time step  % freq*os_fac = sampling frequency
t = d_t : d_t : d_t*ntime;     % time vector

parfor t_i = 1 : ntime
    
        w(t_i,:,:) = real( M.* exp( 1i * omega * t(t_i) ) );   
        
                                                         % here M is 2-D;       w: 3-D(t,x,y) 
                                                         % this equation is calculated in 'calc_SWR_harmonic.m'
                                                        
end

end