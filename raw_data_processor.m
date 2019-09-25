% This script loads raw data from txt-file and integrate them in one
% 3-d complex matrix.

% Dimension of this matrix: 2085 rows,7 columns,10 planes
% 1.D: 2085 nodes from finite-element model
% 2.D: 1.column is node ordinal,  2-4.columns are displacements in x,y,z direction respectively
% 3.D: 10 natural modes

%% real components

disp_rota_DAMP_real = zeros(2085,7,10);

for mode1 = 1:10
    
% Combine literal text with array values to create a character vector with
% function 'sprintf()'
    str1 = 'Disp_Rota%d_real.%s';
    filetype = 'txt';
    filename1 = sprintf(str1,mode1,filetype);
    
    % don't forget to transpose the matrix, because the original values are
    % stored in 
    disp_rota_DAMP_real(:,:,mode1) = textread(filename1).';
     
end

% save('DAMP_realPart.mat','disp_rota_DAMP_real')

%% imaginary components
disp_rota_DAMP_imag = zeros(2085,7,10);

for mode2 = 1:10
    
% Combine literal text with array values to create a character vector with
% function 'sprintf()'
    str2 = 'Disp_Rota%d_imag.%s';
%   filetype = 'txt';
    filename2 = sprintf(str2,mode2,filetype);
    
    % don't forget to transpose the matrix
    disp_rota_DAMP_imag(:,:,mode2) = textread(filename2).';
     
end

% save('DAMP_imagPart.mat','disp_rota_DAMP_real')

%% generate complex vector from raw data


disp_rota_DAMP_cpx = disp_rota_DAMP_real + 1i*disp_rota_DAMP_imag;

save('disp_rota_DAMP_cpx.mat','disp_rota_DAMP_cpx')

%% read nodes coordinates

nodes_coord = textread('Nodes.txt').';
save('Nodes_Coord.mat','nodes_coord')