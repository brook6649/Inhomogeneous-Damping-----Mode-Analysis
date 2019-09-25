function [M] = create_M_matrix(complex_matrix, node_matrix)
% This script reshape the coordinates of nodes into new matrixes so that we can calculate SWR in one direction (parallel with x-axis)


% Sort all rows of "nodes_coord" in this sequence: 1.y-coordinate ascending  2.x-coordinate ascending:
%            nodes_coord = sortrows(nodes_coord,[3,2]);

% Divide all 2085 nodes into 15 files (according to their unique y-coordinates)
% " ny_1 ... ny_15 " (each has 4 columns representing: 1.node ordinal  2.x coordinate  3.y coordinate  4.z coordinate)

node_matrix = sortrows(node_matrix,[3,2]);
y_coord = unique(node_matrix(:,3));
ny = length(y_coord);

for qq1 = 1:ny
    name = ['ny_',num2str(qq1)];
    eval([name,' = node_matrix( node_matrix(:,3) == y_coord(qq1), : );'])
end


% Add 10 new columns to " ny_1 ... ny_15 " and save new matrixes as " damp_ny_1 ... damp_ny_15 "
% The original first 4 columns representing: 1.node ordinal  2.x coordinate  3.y coordinate  4.z coordinate.
% The 5th to 14th columns represents "displacement in z-direction" from mode 1 to mode 10.

%% the first y-coordinate "damp_ny_1" --- the 15.th y-coordinate "damp_ny_15"
for qq2 = 1:ny
    % damp_ny_1 = num2cell(ny_1);
    name1 = ['damp_ny_',num2str(qq2)];
    eval([ name1, ' = num2cell(ny_' num2str(qq2) ');'])
    
    % 1-4 columns: serial number of nodes ,x-y-z coordinates;
    % 5-14 columns: displacement in z-direction in modes 1-10 (one column for the z-displacement in each mode)
    
    % damp_ny_1(:,5:14) = cell( size(ny_1,1), 10 );
    name2 = ['damp_ny_' num2str(qq2) '(:,5:14)'];
    eval([ name2, '= cell( size(ny_' num2str(qq2) ',1), 10 );'])
    for ii = 1:10
        
        if rem(qq2,2) == 1
            lines = 181;
            for jj = 1:lines
                drdc = complex_matrix(:,4,ii);
                % pick out nodes by their serial numbers,
                % and record their z-displacement in matrix "damp_ny_1"
                
                % damp_ny_1{jj,4+ii} = drdc( real(complex_matrix(:,1,ii)) == damp_ny_1{jj,1} );
                name3 = ['damp_ny_' num2str(qq2) '{jj,4+ii}'];
                eval([ name3, '= drdc( real(complex_matrix(:,1,ii)) == damp_ny_' num2str(qq2) '{jj,1} );'])
            end
        elseif rem(qq2,2) == 0
            lines = 91;
            for jj = 1:lines
                drdc = complex_matrix(:,4,ii);
                % pick out nodes by their serial numbers,
                % and record their z-displacement in matrix "damp_ny_1"
                
                % damp_ny_1{jj,4+ii} = drdc( real(complex_matrix(:,1,ii)) == damp_ny_1{jj,1} );
                name3 = ['damp_ny_' num2str(qq2) '{jj,4+ii}'];
                eval([ name3, '= drdc( real(complex_matrix(:,1,ii)) == damp_ny_' num2str(qq2) '{jj,1} );'])
            end
        end
    end
    
end

%% Create M matrix (dimension: 1.D 181 rows; 2.D 15 columns;  3.D 10 planes)

% 2.Dimension: 15 different lines parallel with x-axis, each has an unique y-coordinate
% 1.Dimension: ascending different x-coordinates of nodes that are in the same line
% 3.Dimension: 10 modes

M =  zeros(181,15,10);

for m = 1:10
    
    for qq3 = 1:ny
        if rem(qq3,2) == 1
            lines = 181;
            for q = 1:lines
                % M(q,qq3,m) = damp_ny_1{q,4+m};
                name4 = ['M(' num2str(q) ',' num2str(qq3) ',' num2str(m) ')'];
                eval([ name4, '= damp_ny_' num2str(qq3) '{' num2str(q) ',4+' num2str(m) '};'])
            end
        elseif rem(qq3,2) == 0
            lines = 91;
            for q = 1:lines
                % M(q,qq3,m) = damp_ny_1{q,4+m};
                name4 = ['M(' num2str(q) ',' num2str(qq3) ',' num2str(m) ')'];
                eval([ name4, '= damp_ny_' num2str(qq3) '{' num2str(q) ',4+' num2str(m) '};'])
            end
        end
    end
end

end