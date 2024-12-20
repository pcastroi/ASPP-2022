% Script explaining how to create an inverse lookup table from eq. 6.19 in 
% Wickens' Elementary Signal Detection Theory  

% calculate the integral for the following dprimes and K
dprime = linspace(-4,4,100); K = 3; 
% Note: dprime below zero do not make sense but since you wish to make an 
% inverse lookup table, where correct-response probabilities below 1/K can 
% be used as input, negative dprime can occur.

% integrate over x with the stepsize dx
dx = 0.01;
x = -10:dx:10; 
% since we know that the noise distribution has a mean at 0 and the signal 
% distribution has a mean at dprime (-4 to 4), we do not have to integrate 
% from -Inf to Inf but -10 to 10 will be sufficient.

% do the numerical integration for each of the dprimes 
pc = zeros(1,numel(dprime));
for idp = 1:numel(dprime),
   pc(idp) = sum( normcdf(x,0,1).^(K-1) .* normpdf(x,dprime(idp),1) ) * dx;
   % this is the integral in eq. 6.19
end
% now we have the corresponding correct-response probabilities for our 
% dprimes.  

% put bounderies on pc and dprime. Note -4 and 4 are -Inf and Inf.
pc = [0 pc 1];
dprime = [-4 dprime 4];

% use pc and dprime to make an inverse lookup table for some given pc.
pcgiven = [0.43 0.5 0.89 0.2 0 1];
dpgiven = interp1(pc,dprime,pcgiven);

% plot lookup table and the 
figure
plot(dprime,pc)
hold on
plot(dpgiven,pcgiven,'r.')
grid on
ylim([0 1])
xlabel('dprime')
ylabel('probability of correct response')
% the right hand-side of the plot is seen in Fig. 6.4 in Wickens.