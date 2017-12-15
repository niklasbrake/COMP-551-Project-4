
% if(splitl{itt}{1} == 'MNIST')
% 	getMNISTdata;
% else
% 	getCIFARdata;
% end

% N = 10000;
% N2 = 100;
N = str2num(splitl{itt}{3});
N2 = size(test_data,1);

% Use tanh as activation function
% psi ='tanh';
% Use ReLU as activation function
% psi = 'ReLU';
psi = splitl{itt}{2};

% [~,~,~,Network_Depth,sig_w,sig_b] = auxFunc();
Network_Depth = str2num(splitl{itt}{4});
sig_w = str2num(splitl{itt}{5});
sig_b = str2num(splitl{itt}{6});

K = getKernel(training_data(1:N,:),psi,Network_Depth,sig_w,sig_b);

sig_eps = 0;
% disp('Inverting Matrix...');
inv_K = inv(K + sig_eps^2*eye(N));
save(['MNIST_' psi '_Kernel_N=' int2str(N) '.mat'],'K','inv_K');
% disp('Complete.');

[Y_Hat, confidence] = predict(test_data(1:N2,:),training_data(1:N,:),training_labels(1:N),psi);

Accuracy(itt) = sum(Y_Hat == test_labels(1:N2)) / N2;

disp(['Accuracy: ' num2str(Accuracy(i))]);