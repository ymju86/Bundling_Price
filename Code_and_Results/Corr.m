clc
clear

tic % start timer

cd /home/rcf-proj3/ms7/sharifva/My_Projects/Term_Paper

addpath /home/rcf-40/sharifva/.matlab/matlab-slurm-master
c = get_SLURM_cluster('--time=1:00:00 --account=lc_ms7 --mem-per-cpu=2GB --mail-type=ALL');
c.parpool(128)

% parameters of the problem

n = 1000; % totall number of potential customers
p1 = 1; % price of good one
p2 = 1; % price of good two
mu = 1; % mean of customers' utilities from good one and two
sig12_set = -0.75:0.25:0.75; % covariance between utility from good one and two
sig = 1; % variance of utilities for good one and two

sim = 1000; % number of simulations

Ave_gain_known = nan(length(sig12_set),1);
Ave_gain_unknown = nan(length(sig12_set),1);
p_star = nan(length(sig12_set),1);
p_star_unknown_Ave = nan(length(sig12_set),1);

for z = 1:length(sig12_set)
    sig12 = sig12_set(z);
    sig21 = sig12; % covariance between utilities from good one and two
    mu_vec = [mu;mu];
    sigma = [sig, sig12; sig21, sig];
    
    % finding the optimal bundling price in the case that we know all the parameters
    fun = @(p) -1 * Pro_bundle(p,p1,p2,mu_vec, sigma);
    p_star(z) = fminbnd(fun,p1,p1+p2);
    
    gain_known = nan(sim,1);
    for i = 1:sim
        
        rng(125+i)
        % generating utilies of good one and two for n customers
        utility = mvnrnd(mu_vec,sigma,n);
        
        % finding the customers who will buy good one, two or both and then finding the total sales with bunlding
        index1_b = utility(:,1) > p1 & utility(:,2) < p_star(z) - p1 ;
        index2_b = utility(:,1) < p_star(z) - p2 & utility(:,2) > p2 ;
        index3_b = utility(:,1) + utility(:,2) > p_star(z) & utility(:,1) > p_star(z) - p2 & utility(:,2) > p_star(z) - p1 ;
        Sale_b = (p1*sum(index1_b) + p2*sum(index2_b) + p_star(z)*sum(index3_b));
        
        
        % finding the customers who will buy good one, two or both and then finding the total sales without bunlding
        index1_nb = utility(:,1) > p1 ;
        index2_nb = utility(:,2) > p2 ;
        Sale_nb = (p1*sum(index1_nb) + p2*sum(index2_nb));
        
        % finding the gain from bundling in terms of sales
        gain_known(i) = Sale_b - Sale_nb;
        
    end
    Ave_gain_known(z) = mean(gain_known);
    
    
    gain_unknown = nan(sim,1);
    p_star_unknown = nan(sim,1);
    
    parfor i = 1:sim
        
        rng(1125+i)
        % generating utilies of good one and two for n customers for estimation
        utility = mvnrnd(mu_vec,sigma,n);
        fun = @(x) find_para(x,p1,p2,utility,n);
        x0 = [0,1,0];
        theta_hat = fsolve(fun,x0);
        mu_hat = theta_hat(1);
        sig_hat = theta_hat(2);
        sig12_hat = theta_hat(3);
        
        mu_vec_hat = [mu_hat;mu_hat];
        sig21_hat = sig12_hat;
        sigma_hat = [sig_hat,sig12_hat;sig21_hat,sig_hat];
        
        % finding optimal bundling price using estimated parameters
        fun = @(p) -1 * Pro_bundle(p,p1,p2,mu_vec_hat, sigma_hat);
        p_star_unknown(i) = fminbnd(fun,p1,p1+p2);
        
        % new customers
        rng(125+i)
        utility = mvnrnd(mu_vec,sigma,n);
        
        % finding the customers who will buy good one, two or both and then finding the total sales with bunlding
        index1_b = utility(:,1) > p1 & utility(:,2) < p_star_unknown(i) - p1 ;
        index2_b = utility(:,1) < p_star_unknown(i) - p2 & utility(:,2) > p2 ;
        index3_b = utility(:,1) + utility(:,2) > p_star_unknown(i) & utility(:,1) > p_star_unknown(i) - p2 & utility(:,2) > p_star_unknown(i) - p1 ;
        Sale_b = (p1*sum(index1_b) + p2*sum(index2_b) + p_star_unknown(i)*sum(index3_b));
        
        
        % finding the customers who will buy good one, two or both and then finding the total sales without bunlding
        index1_nb = utility(:,1) > p1 ;
        index2_nb = utility(:,2) > p2 ;
        Sale_nb = (p1*sum(index1_nb) + p2*sum(index2_nb));
        
        % finding the gain from bundling in terms of sales
        gain_unknown(i) = Sale_b - Sale_nb;
        
    end
    
    Ave_gain_unknown(z) = mean(gain_unknown);
    p_star_unknown_Ave(z) = mean(p_star_unknown);
end

save('Corr.mat','Ave_gain_unknown','Ave_gain_known','p_star_unknown_Ave','p_star')
toc % stop timer
delete(gcp('nocreate'))