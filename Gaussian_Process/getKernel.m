% For GP given depth and nonlinearity, grid of σ_w^2
% of evenly spaced 30 points from 0.1 to 5.0 and σ_b^2 
% of evenly spaced 30 points from 0 to 2.0 was evaluated 
% to generate the heatmap. The best GP run was chosen
% among 900 evaluation of σ_w^2 - σ_b^2 grid.

function [K,F] = getKernel(X,psi)

	[u,s,c,Network_Depth,sig_w,sig_b] = auxFunc();

	K = [];
	K_aux = [];

	[N d_in] = size(X);

	

	% Calculate base-case for layer 0 
	for i = 1:N
		for j = 1:N
			K(i,j) = sig_b^2+sig_w^2*(dot(X(i,:),X(j,:)))/d_in;
		end
	end

	% Use their calculated analytical form for ReLU kernel
	if(isstr(psi))
		h = waitbar(1/Network_Depth,'Layer 0');
		if(psi ~= 'ReLU')
			disp('Error');
			return;
		end
		for l = 2:Network_Depth
			waitbar(l/Network_Depth,h,['Layer' int2str(l-1)]);
			for i = 1:N
				for j = 1:N
					T = acos(K(i,j)/sqrt(K(i,i)*K(j,j)));
					K_aux(i,j) = sig_b^2 + sig_w^2/(2*pi) * sqrt(K(i,i)*K(j,j)) * sin(T) + sig_w^2/(2*pi) * (pi - T) * K(i,j);
				end
			end
			K = K_aux;
		end
	% Or use their nummerical algorithm
	else
		% first dimension is s dimension and second is the c dimension
		F = F_Phi_Matrix(u,s,c,psi);

		h = waitbar(1/Network_Depth,'Layer 1');

		for l = 2:Network_Depth
			waitbar(l/Network_Depth,h,['Layer' int2str(l-1)]);
			for i = 1:N
				PK = K(i,i);
				for j = 1:N
					K_aux(i,j) = interp2(s,c,F,PK,K(i,j)/PK,'linear');
				end
			end
			K = K_aux;
		end
	end

	close(h);

end

function F = F_Phi_Matrix(u,s,c,psi)


	I = length(s);
	J = length(c);
	
	[A,B] = meshgrid(u,u);


	parfor i = 1:I
		disp(i);
		for j = 1:J
			if(s(i) == 0 || abs(c(j)) == 1)
				F(i,j) = 0;
			else
				X = (A.^2 - c(j) * A .* B - c(j) * B .* A - B.^2) / (s(i) - s(i)*c(j)^2);
				Y = psi(A).*psi(B);
				F(i,j) = sum(sum(Y.*X))/sum(sum(X));
			end
		end
	end

end





