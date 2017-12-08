% For GP given depth and nonlinearity, grid of σ_w^2
% of evenly spaced 30 points from 0.1 to 5.0 and σ_b^2 
% of evenly spaced 30 points from 0 to 2.0 was evaluated 
% to generate the heatmap. The best GP run was chosen
% among 900 evaluation of σ_w^2 - σ_b^2 grid.

function [K,F] = getKernel(X,psi)

	[u,s,c,Network_Depth] = auxFunc();

	K = [];
	K_aux = [];

	N = size(X,1);

	% Calculate base-case for layer 0 
	for i = 1:N
		for j = 1:N
			K(i,j) = sig_b^2+sig_w^2*(dot(X(i,:),X(j,:)))/d_in;
		end
	end

	% Use their calculated analytical form for ReLU kernel
	if(psi == 'ReLU')
		for l = 2:Network_Depth
			for i = 1:N
				for j = 1:N
					T = acos(K(i,j)/sqrt(K(i,i)*K(j,j));
					K_aux(i,j) = sig_b^2 + sig_w^2/(2*pi) * sqrt(K(i,i)*K(j,j)) * sin(T) + sig_w^2/(2*pi) * (pi - T) * K(i,j);
				end
			end
			K = K_aux;
		end
	% Or use their nummerical algorithm
	else
		% first dimension is s dimension and second is the c dimension
		F = F_Phi_Matrix(u,s,c,psi);

		for l = 2:Network_Depth
			for i = 1:N
				PK = K(i,i);
				for j = 1:N
					K_aux(i,j) = interp2(s,c,F,PK,K(i,j)/PK,'linear');
				end
			end
			K = K_aux;
		end
	end

end

function F = F_Phi_Matrix(u,s,c,psi)

	for i = 1:I
		for j = 1:J
			NUM = 0;
			DEM = 0;
			for a = 1:A
				for b = 1:B
					X = -[u(a) u(b)]*inv([s(i) s(i)*c(j); s(i)*c(j) s(i)])*[u(a);u(b)];
					NUM = NUM + psi(u(a))*psi(u(b))*exp(X);
					DEM = DEM + exp(X);
				end
			end
			F(i,j) = NUM/DEM;
		end
	end

end





