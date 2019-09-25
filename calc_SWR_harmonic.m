function [SWR_y,e_y,maxTiDo_y,W_pos,W_neg,k0]= calc_SWR_harmonic(M,ny,freq,ntime,os_fac)
% In our case, this function calculates SWR in y-direction for each line of nodes

SWR_y = zeros(length(freq),ny); 
e_y = zeros(length(freq),ny);
% maxTiDo: the maximal amplitude in a single line in x- or y-direction under a certain mode
maxTiDo_y = zeros(length(freq),ny);



for m = 1 : size(M,3)       % for every modes
    % Übertragen in Zeitbereich
    [timeDomain(:,:,:), t] = mode2time(M(:,:,m),freq(m),ntime,os_fac);

    % SWR für jede Y-Reihe (X-Richtung)
    for p = 1 : ny
        
        % the w vector when t = 0 in m.th mode and p.th column
        % this vector is used in function "SWR_calculation"
        % change the shape of vector w 
        w_t0 = M(:,p,m)'; 
        
        w_y(:,:) = timeDomain(:,:,p);
        [SWR_y(m,p),e_y(m,p),W_pos(m,p),W_neg(m,p),k0(m)] = SWR_calculation(t,w_y(:,:),freq(m),w_t0);
        % Max Ampl. aus allen Zeitpkt entlang der x-Reihen für jede Frq.
        maxTiDo_y(m,p) = max(max(abs(w_y(:,:)),[],2));
    end
    
    clear t timeDomain w_t0 w_y
end


end