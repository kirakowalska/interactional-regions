adj = csvread('data/mobilitynet_adjacency.csv');
adjnet = csvread('data/streetnet_adjacency.csv');

%% Def 3
% Normalize actual and expected vectors
adj_norm = adj./(sum(sum(adj)));     % Actual links
adjnet_norm = adjnet./(sum(sum(adjnet)));    % Expected links

% Calcualte modularity (actual - expected)
B = adj_norm - adjnet_norm;

[S_def2,Q_def2] = genlouvain(B);

%% Standard

gamma = 1;
k = full(sum(adj));
twom = sum(k);
B = full(adj - gamma*k'*k/twom);
[S,Q] = genlouvain(B);
Q = Q/twom;

%% Standard on AB-roads network 

adj_ab = csvread('data/mobilitynet_ABroads_adjacency.csv');

gamma = 1;
k = full(sum(adj_ab));
twom = sum(k);
B = full(adj_ab - gamma*k'*k/twom);
[S_ab,Q_ab] = genlouvain(B);
Q_ab = Q_ab/twom;

csvwrite('results/com_def1_ABroads.csv',S_ab);

%% Standard on scaled up network (only A, B and Minor roads)

adj_major = csvread('data/mobilitynet_major_adjacency.csv');

gamma = 1;
k = full(sum(adj_major));
twom = sum(k);
B = full(adj_major - gamma*k'*k/twom);
[S_major,Q_major] = genlouvain(B);
Q_major = Q_major/twom;

%csvwrite('results/com_def1_major.csv',S_major);

%% Standard on scaled up network (only A, B and Minor roads) subject to min threshold

adj_major = csvread('data/streetnet_major_adjacency.csv');
%adj_major(adj_major<20)=0;
adj_major = adj_major + 20;

gamma = 1;
k = full(sum(adj_major));
twom = sum(k);
B = full(adj_major - gamma*k'*k/twom);
[S_major,Q_major] = genlouvain(B);
Q_major = Q_major/twom;

%csvwrite('results/com_def1_major.csv',S_major);

%% Angualrity net 1 - standard Louvain
% Scenario 1: completely aspatial, edges are connected based on their
% angular distances, regardless of their physical location

angadj = csvread('data/angularnet_edge_adjacency.csv');

gamma = 1;
k = full(sum(angadj));
twom = sum(k);
B = full(angadj - gamma*k'*k/twom);
[S_ang,Q_ang] = genlouvain(B);
Q_ang = Q_ang/twom;

csvwrite('results/com_ang.csv',S_ang);

%% Angualrity net 2 - standard Louvain
% Scenario 2: now only adjacent edges can be connected. The strength of
% their connection is equal to (1- angular difference between them).

angadj2 = csvread('data/angularnet_conn_edge_adjacency.csv');
angadj2(angadj2<30)=0;

gamma = 1;
k = full(sum(angadj2));
twom = sum(k);
B = full(angadj2 - gamma*k'*k/twom);
[S_ang2,Q_ang2] = genlouvain(B);
Q_ang2 = Q_ang2/twom;

csvwrite('results/com_ang_conn_thres30.csv',S_ang2);

%% Output results
csvwrite('results/com_def1.csv',S);
csvwrite('results/com_def2.csv',S_def2);