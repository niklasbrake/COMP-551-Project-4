function [u,s,c,Network_Depth] = auxFunc()

	Network_Depth;
	u_max;
	s_max;
	n_g;
	n_v;
	n_c;

	u = linspace(-u_max,u_max,n_g);
	s = linspace(0,s_max,n_v);
	c = linspace(-1,1,n_c);

end