function obj = Pro_bundle(p,p1,p2,mu_vec, sigma)

integrand = @(x1, x2) reshape(mvnpdf([x1(:), x2(:)],mu_vec',sigma), size(x1));

obj1 = p1 * integral2(integrand,p1,inf,-inf,p-p1);
obj2 = p2 * integral2(integrand,-inf,p-p2,p2,inf);

x2min = @(x1) max(p-p1,p-x1);
obj3 = p * integral2(integrand,p-p2,inf,x2min,inf);

obj = obj1 + obj2 + obj3;

end