function obj = find_para(theta,p1,p2,utility,n)

obj = nan(3,1);
mu = theta(1);
sig = theta(2);
sig12 = theta(3);
mu_vec = [mu;mu];
sig21 = sig12;

if abs(sig12) >= sig || sig <= 0
    obj(1:3) = inf;
else
    sigma = [sig, sig12; sig21, sig];
    c1 = sum(utility(:,1) < p1 & utility(:,2) < p2)/n;
    c2 = sum(utility(:,1) > p1 & utility(:,2) < p2)/n;
    c3 = sum(utility(:,1) > p1 & utility(:,2) > p2)/n;
    integrand = @(x1, x2) reshape(mvnpdf([x1(:), x2(:)],mu_vec',sigma), size(x1));
    
    obj(1) = integral2(integrand,-inf,p1,-inf,p2)-c1;
    obj(2) = integral2(integrand,p1,inf,-inf,p2)-c2;
    obj(3) = integral2(integrand,p1,inf,p2,inf)-c3;
end

end