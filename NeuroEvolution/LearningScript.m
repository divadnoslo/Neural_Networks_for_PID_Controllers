close all
clear;
clc;

rng default %For reproducibility

%% Run NeuroEvolution

popSize = 50; %Population size to use
numGen = 30; %Number of generations to run for

ne = Evolver(popSize);
ne.evolve(numGen);

%% Construct neural network object and plot validation data scatter plot

%Get best candidate
bestCan = ne.BestCandidate;

%Construct neural network
nn = NeuralNetworkNE(bestCan.InDim, bestCan.HidDim, bestCan.OutDim, bestCan.Wi, bestCan.Bi, bestCan.Wo, bestCan.Bo);

M_des = 1;
Tp_des = 0.15;
Ts_des = 0.2;

%Input desired specs into NN, take K-value outputs and run PID
%simulation with them
spec = [M_des Tp_des Ts_des];
k_vals = nn.outputsForDataset(spec);
[M, Tp, Ts] = PID_controller_sim(k_vals(1), k_vals(2), k_vals(3), 1);

% Plot Results
n = 1 : numGen;
figure
plot(n, ne.FitnessOverTime, 'r*')
title('Evolution of the Fitness of the Population')
xlabel('Generations')
xlim([1 numGen])
ylabel('Fitness of Each Generation')
ylim([0 1])
grid on
legend('Max Fitness', 'Location', 'Best')
