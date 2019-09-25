% run_the_calculation

clear; close all;
load Nodes_Coord.mat
load disp_rota_DAMP_cpx.mat
M = create_M_matrix(disp_rota_DAMP_cpx,nodes_coord);

load freq_DAMP

freq = freq_damp;

os_fac = 100;
ntime = 500;

ny = size(M,2);

[SWR_y, e_y, maxTiDo_y,W_pos,W_neg,k0] = calc_SWR_harmonic(M,ny,freq,ntime,os_fac);

% Dimension of " SWR_y, e_y, W_pos, W_neg ": 10 rows and 15 columns 
% 10 rows indicate 10 natural modes
% 15 columns indicate 15 lines of nodes that are parallel with x-axis and each of these lines has an unique y coordinate.
 
save ('results.mat','SWR_y','e_y','W_pos','W_neg','k0')


%{

%% plot SWR in one figure
% DAMP

x_line = 1:15;
load results_real_DAMP.mat

plot( x_line,e_y_real )
title('e in x-direction   solver: DAMP')
xlabel('n.th line in x-direction')
ylabel('Standing Wave Ratio')

 A = cell(10,1);
for i = 1:10
   A{i} = [num2str(i),'.th Mode']; 
   legend(A{i})
end

legend(A)


%% plot a figure for each mode
% DAMP
 
for i = 1:10
    figure
    plot( x_line,e_y_real(i,:) )

    title(['e in x-direction  solver: DAMP','  Mode.',num2str(i)])
    xlabel('n.th line in x-direction')
    ylabel('Standing Wave Ratio')

    A{i} = [num2str(i),'.th Mode']; 
    legend(A{i})
end



%% plot SWR in one figure
% QRDAMP(Frequenz:damped)
x_line = 1:15;
load results_real_QRDAMP(damped).mat

plot( x_line,SWR_y_real )
title('SWR in x-direction   solver: QRDAMP')
xlabel('n.th line in x-direction')
ylabel('Standing Wave Ratio')

 A = cell(10,1);
for i = 1:10
   A{i} = [num2str(i),'.th Mode']; 
   legend(A{i})
end

legend(A)

%% plot a figure for each mode
% QRDAMP(Frequenz:damped)
 
for i = 1:10
    figure
    plot( x_line,SWR_y_real(i,:) )

    title(['SWR in x-direction  solver: QRDAMP','  Mode.',num2str(i)])
    xlabel('n.th line in x-direction')
    ylabel('Standing Wave Ratio')

    A{i} = [num2str(i),'.th Mode']; 
    legend(A{i})
end


 A = cell(10,1);
for i = 1:10
   
end

%}

%{
% draw mixture of standing and travelling waves

% QRDAMP, average W in x-direction
W_p = sum(W_pos,2)/15 ;
W_n = sum(W_neg,2)/15 ;

x = 0.001:0.005:0.45;  % x range of Ansys model

W = zeros(10,length(x));

for m = 1:10
    W(m,:) = W_p(m)*exp(1i*k0(m)*x) - W_n(m)*exp(-1i*k0(m)*x) ;
end 

plot(x,W)
xlabel('x')
ylabel('W')
A = cell(1,10);
for p = 1:10
   A{p} = ['mode ',num2str(p)]; 
end
legend(A)

%}

%% Elipse
x = 0.001:0.005:4.5;  % x range of Ansys model
%{
for qq1 = 1:10
    W_posElipse(qq1,:) = W_pos(qq1,3)*exp(1i*k0(qq1)*x);
    W_negElipse(qq1,:) = W_neg(qq1,3)*exp(-1i*k0(qq1)*x) ;
    W_Elipse(qq1,:) = W_posElipse(qq1,:) - W_negElipse(qq1,:) ;
end 
%}
W_posElipse = zeros(10,length(x));
W_negElipse = zeros(10,length(x));
W_Elipse = zeros(10,length(x));

for qq1 = 1:10
    W_posElipse(qq1,:) = W_pos(qq1)*exp(1i*k0(qq1)*x);
    W_negElipse(qq1,:) = W_neg(qq1)*exp(-1i*k0(qq1)*x);
    W_Elipse(qq1,:) = W_posElipse(qq1,:) - W_negElipse(qq1,:);
end 

figure('NumberTitle', 'off', 'Name', '10 ellipses of task 1');
for qq1 = 1:10
% mode i
subplot(3,4,qq1)
plot( real( W_Elipse(qq1,:) ), imag( W_Elipse(qq1,:) ),'--k')
hold on
plot(real(W_posElipse(qq1,:)),imag(W_posElipse(qq1,:)),'--r')
plot(real(W_negElipse(qq1,:)),imag(W_negElipse(qq1,:)),'--g')
hold off
title(['DAMP  Mode ',num2str(qq1)])

end




%% Plot e_y for each mode
figure('NumberTitle', 'off', 'Name', 'e_y plots of task 1');
for qq1= 1:10
    subplot(3,4,qq1)
    plot(e_y(qq1,:))
    hold on
    title(['DAMP   Mode ' num2str(qq1)])
    
end

%% plot mode shape
load disp_rota_DAMP_cpx.mat
load Nodes_Coord.mat

x = nodes_coord(:,2);
y = nodes_coord(:,3);
z = zeros(2085,10);
figure('NumberTitle', 'off', 'Name', 'Mode Shape for all 10 modes');
for qq1 = 1:10
    z(:,qq1) = real( disp_rota_DAMP_cpx(:,4,qq1) );
    subplot(3,4,qq1)
    [xx,yy] = meshgrid(0:0.0025:0.45,0:0.0025:0.035);
    zz = griddata(x,y,z(:,qq1),xx,yy,'v4');
    surf(xx,yy,zz)
    title(['Mode shape ' num2str(qq1)])
    axis([0,0.45,0,0.035,min(z(:,qq1)),max(z(:,qq1))])
    shading interp
    
end
