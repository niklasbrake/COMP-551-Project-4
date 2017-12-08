function [mu,sig] = predict(x,X,Y,K_DD,F)

	[~,s,c,~,Network_Depth] = auxFunc();

	K_xD = [];
	K_aux = [];

	N = size(X,1);

	for i = 1:N
		K_xD(i) = sig_b^2+sib_w^2*(dot(x,X(i,:)))/d_in;
	end

	for l = 2:Network_Depth
		for i = 1:N
			PK = K_DD(i,i);
			K_aux(i,l) = interp2(s,c,F,PK,K_xD(i)/PK,'linear')
		end
		K_xD = K_aux;
	end

	% Preprocessing means constant norm
	K_xx = K(1,1);

	mu = K_xD*inv(K_DD + sig_eps^2*eye(N))*Y;
	sig = K_xx - K_xD*inv(K_DD + sig_eps^2*eye(N))*transpose(K_XD);

end