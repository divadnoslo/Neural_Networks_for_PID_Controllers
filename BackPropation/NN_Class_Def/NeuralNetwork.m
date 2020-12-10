classdef NeuralNetwork
    %NEURALNETWORK Comprises of Network Layers and Perceptrons
    
    properties
        hiddenLayer;
        outputLayer;
        eta;
        
        
    end
    
    methods
        function obj = NeuralNetwork(hiddenLayer, outputLayer, eta)
            %NEURALNETWORK makes the network
            obj.hiddenLayer = hiddenLayer;
            obj.outputLayer = outputLayer;
            obj.eta = eta;
            
        end
        
        %% Print Neural Network Data
        function print_NN(obj)
            
            % Hidden Layer Data
            disp('Hidden Layer')
            for ii = 1 : length(obj.hiddenLayer.layer)
                str1 = ['Perceptron #', num2str(ii), ': '];
                str2 = [];
                for jj = 1 : length(obj.hiddenLayer.layer{1}.weights)
                    w = num2str(obj.hiddenLayer.layer{ii}.weights(jj));
                    str2 = [str2, ' ', num2str(w), ' '];
                end
                b = num2str(obj.hiddenLayer.layer{ii}.bias);
                str = [str1, str2, ' | ', b, '\n'];
                fprintf(str)
            end
            
            % Output Layer Data
            fprintf('\n')
            disp('Output Layer')
            for ii = 1 : length(obj.outputLayer.layer)
                str1 = ['Perceptron #', num2str(ii), ': '];
                str2 = [];
                for jj = 1 : length(obj.outputLayer.layer{1}.weights)
                    w = num2str(obj.outputLayer.layer{ii}.weights(jj));
                    str2 = [str2, ' ', num2str(w), ' '];
                end
                b = num2str(obj.outputLayer.layer{ii}.bias);
                str = [str1, str2, ' | ', b, '\n'];
                fprintf(str)
            end
            
            fprintf('\n\n')
            
        end
                
        %% Forward Propogation
        function obj = forward_prop(obj, inputs)
            % Forward Propogation of the Entire Network
            
            % Forward Prop Hidden Layer
            obj.hiddenLayer = obj.hiddenLayer.forward_prop_layer(inputs);
            
            % Forward Prop Output Layer
            obj.outputLayer = obj.outputLayer.forward_prop_layer(obj.hiddenLayer.layer_output);
            
        end
        
        %% Back Propogation
        function obj = back_prop(obj, desiredOutputs, inputs)
            
            % Get Error Vector
            obj.outputLayer = obj.outputLayer.get_error_vector(desiredOutputs);
            
            % Calculate Delta Values
            obj.outputLayer = obj.outputLayer.set_output_deltas();
            obj.hiddenLayer = obj.hiddenLayer.set_hidden_deltas(obj.outputLayer);
            
            % Calculate Delta Weights and Delta Biases
            obj.outputLayer = obj.outputLayer.calc_layer_delta_weights(obj.eta, obj.hiddenLayer.layer_output);
            obj.hiddenLayer = obj.hiddenLayer.calc_layer_delta_weights(obj.eta, inputs);
            
            % Set New Weights
            obj.outputLayer = obj.outputLayer.update_layer_weights();
            obj.hiddenLayer = obj.hiddenLayer.update_layer_weights();
            
        end
        
        %% Training Cycle
        function obj = training_cycle(obj, inputs, desiredOutputs, numCycles)
            
            for ii = 1 : numCycles
                obj = obj.forward_prop(inputs);
                obj = obj.back_prop(desiredOutputs, inputs);
            end
            
        end
        
        %% Assess Performance
        function fitness = test_NN(obj, test_case, in, out, controller)
            
            % Input desired specs to NN, get gains
            specs = in(test_case, :);
            GA_gains = out(test_case, :);
            obj = obj.forward_prop(specs);
            
            % Select the Gains
            kp = obj.outputLayer.layer{1}.activation;
            ki = obj.outputLayer.layer{2}.activation;
            kd = obj.outputLayer.layer{3}.activation;
            NN_gains = [kp ki kd];
            
            % Run generated gains through simulator
            if (controller == "PID")
                [M, Tp, Ts] = PID_controller_sim(kp, ki, kd, 1);
            elseif (controller == "PIwRFB")
                [M, Tp, Ts] = PIwRFB_controller_sim(kp, ki, kd, 1);
            end
            perf = [M, Tp, Ts];
            
            % Calc Fitness
            fitness = assess_fitness(NN_gains, perf, controller);
            
            % Build Table
            PE1 = 100 * ((perf - specs) ./ specs);
            tab = [specs', perf', PE1'];
            column_names = {'NN Input Specs', 'DC Servomotor Perf.', 'Percent Error'};
            row_names = {'Overshoot (ratio)', 'Peak Time (s)', 'Settling Time (s)'};
            T1 = array2table(tab, 'RowNames', row_names, 'VariableNames', column_names)
            
            PE2 = 100 * ((NN_gains - GA_gains) ./ GA_gains);
            tab = [GA_gains', NN_gains', PE2'];
            column_names = {'GA Gains', 'NN Gains', 'Percent Error'};
            row_names = {'k_p', 'k_i', 'k_d'};
            T2 = array2table(tab, 'RowNames', row_names, 'VariableNames', column_names)
            
        end
            
    end
end

