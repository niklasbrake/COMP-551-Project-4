getMNISTdata();
% getCIFARdata();

% Use ReLU as activation function
psi = 'ReLU';

% Use tanh as activation function
psi = @(u) tanh(u);

% "Training" of gaussian process
[K,F] = getKernel(training_data,psi);


Y_Hat = predict(test_data,training_data,training_labels,K,F);

Accuracy = sum(Y_Hat == test_labels);