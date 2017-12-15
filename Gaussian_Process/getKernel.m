% For GP given depth and nonlinearity, grid of σ_w^2
% of evenly spaced 30 points from 0.1 to 5.0 and σ_b^2 
% of evenly spaced 30 points from 0 to 2.0 was evaluated 
% to generate the heatmap. The best GP run was chosen
% among 900 evaluation of σ_w^2 - σ_b^2 grid.

function K = getKernel(X,psi,Network_Depth,sig_w,sig_b)

	% [u,s,c,Network_Depth,sig_w,sig_b] = auxFunc();
	[u,s,c,~,~,~] = auxFunc();

	K = [];
	K_aux = [];

	[N d_in] = size(X);

	h = waitbar(1/Network_Depth,'Layer 1');
	K = sig_b^2+sig_w^2*(X*transpose(X))/d_in;

	% Use their calculated analytical form for ReLU kernel
	if(~isstr(psi))
		F = getLUT(u,s,c,psi);
	elseif(psi == 'ReLU')

		for l = 2:Network_Depth
			waitbar(l/Network_Depth,h,['Layer' int2str(l)]);
			T = real(acos(K/abs(K(1,1))));
			K = sig_b^2 + sig_w^2/(2*pi) * abs(K(1,1)) * sin(T) + sig_w^2/(2*pi) * (pi - T) .* K;
		end

		close(h);
		return;

	% Or use their nummerical algorithm
	elseif(psi == 'tanh');

		% first dimension is s dimension and second is the c dimension
		load('tanhLUT.mat','F');

	end

	[S C] = ndgrid(s,c);

	I = griddedInterpolant(S,C,F,'linear');

	for l = 2:Network_Depth
		waitbar(l/Network_Depth,h,['Layer' int2str(l)]);
		PK = repmat(diag(K),[1,N]);
		K = sig_b^2+sig_w^2*I(PK,K./PK);
	end


	close(h);

end







