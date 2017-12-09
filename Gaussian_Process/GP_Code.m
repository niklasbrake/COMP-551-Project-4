getMNISTdata;
% getCIFARdata;

% Use ReLU as activation function
psi = 'ReLU';

% Use tanh as activation function
psi = @(u) tanh(u);

% "Training" of gaussian process
[K,F] = getKernel(training_data(1:100,:),psi);


Y_Hat = predict(test_data(1:100,:),training_data(1:100,:),training_labels(1:100),K,F);

Accuracy = sum(Y_Hat == test_labels(1:100));