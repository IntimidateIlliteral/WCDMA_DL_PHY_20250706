function i = inner_product256(a,b)

% AKA weighted_mean, linear_combination 

i = a.*b;

i = sum(i,1);

end

