function F = getLUT(u,s,c,psi)


	I = length(s);
	J = length(c);
	
	[A,B] = meshgrid(u,u);
	AS = A.^2;
	BS = B.^2;

	Y = psi(A).*psi(B);

	parfor i = 1:I
		for j = 1:J
			if(abs(c(j)) == 1)
				F(i,j) = 1;
			else
				X = exp(-((AS - 2* c(j) * A .* B + BS) ./ (s(i) - s(i)*c(j)^2)));
				ssumm = sum(sum(X));

				% If ((AS - 2* c(j) * A .* B + BS) ./ (s(i) - s(i)*c(j)^2)) ~= Inf
				if(ssumm == 0)
					F(i,j) = 1;
				% If ((AS - 2* c(j) * A .* B + BS) ./ (s(i) - s(i)*c(j)^2)) ~= - Inf
				elseif(ssumm == Inf)
					F(i,j) = -1;
				else
					F(i,j) = sum(sum(Y.*X))/ssumm;
				end
			end
		end
	end

end