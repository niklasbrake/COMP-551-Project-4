function [mu,sig] = predict(X_T,X,Y,psi)

	[~,s,c,Network_Depth,sig_w,sig_b] = auxFunc();

	sig_eps = 0;

	[N d_in] = size(X);
	N2 = size(X_T,1);

	h = waitbar(1/Network_Depth,'Layer 1');

	% First dimension is test data and second is training. So K_x(1,:) is K_xD for test point 1
	K_x = sig_b^2 + sig_w^2*(X_T*transpose(X))/d_in;
	K_x(:,N+1) = sig_b^2 + sig_w^2 * dot(X_T,X_T,2) / d_in;

	if(~isstr(psi))
		mu = [];
		return;
	end
	if(psi == 'ReLU')
		
		for l = 2:Network_Depth
			waitbar(l/Network_Depth,h,['Layer ' int2str(l)]);
			PK = repmat(K_x(:,N+1),[1 N+1]);
			T = acos(K_x./sqrt(K_x.*PK));
			K_x = sig_b^2 + sig_w^2/(2*pi) * sqrt(K_x .* PK) .* sin(T) + sig_w^2/(2*pi) * (pi - T) .* K_x;
		end
		
	% Or use their nummerical algorithm
	else

		% first dimension is s dimension and second is the c dimension
		load([psi 'LUT.mat'],'F');

		[S C] = ndgrid(s,c);

		I = griddedInterpolant(S,C,F,'linear');

		for l = 2:Network_Depth
			waitbar(l/Network_Depth,h,['Layer ' int2str(l)]);
			PK = repmat(K_x(:,N+1),[1 N]);
			K_x = sig_b^2+sig_w^2*I(PK,K_x(:,1:N)./PK);
			K_x(:,N+1) = sig_b^2 + sig_w^2 * PK(:,1);
		end

	end

	K_xD = K_x(:,1:N);
	K_xx = K_x(:,N+1);

	waitbar(l/Network_Depth,h,['Calculating Test Labels...']);

	load(['MNIST_' psi '_Kernel_N=' int2str(N) '.mat'],'inv_K');
	% Normalized one-hot
	t = -0.1*ones([length(Y),length(unique(Y))]);
	for i = 1:length(Y)
		t(i,Y(i)+1) = 0.9;
	end

	mu = K_xD * inv_K * t;
	% sig = K_xx - K_xD* inv_K *transpose(K_xD);
	sig = [];

	[~, mu] = max(mu,[],2);

	mu = mu - 1;

	close(h);

end