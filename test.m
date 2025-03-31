% b_coeffs = [0.2010; 0.0023; 0.0993; 0.0231; 0; -0.0027; 0.0122; 0.0024];
% coded_terms = {'', 'z1', 'z2', 'z3', 'z1z2', 'z1z3', 'z2z3', 'z1z2z3'};
% X0 = [0.1, 0.01, 20];
% n = [0.005, 0.005, 10];

% b_coeffs = [0.187259; 0.054032; 0.036423; 0.010936; -0.013518; 0.009965; -0.004604; -0.002741];
% coded_terms = {'', 'z1', 'z2', 'z3', 'z1z2', 'z1z3', 'z2z3', 'z1z2z3'};
% X0 = [30, 40, 0.001];
% n = [20, 25, 0.0005];
b_coeffs = [0.183976; 0.049534; 0.046484; -0.002529];
coded_terms = {'', 'z1', 'z2', 'z3'};
X0 = [30, 40, 0.001];
n = [20, 25, 0.0005];



B_coeffs = coded_to_natural(b_coeffs, coded_terms, X0, n);

fprintf('Натуральные коэффициенты:\n');
for i = 1:numel(B_coeffs)
    current_term = coded_terms{i};
    if isempty(current_term)
        coeff_name = 'B0';
    else
        digits = current_term(current_term ~= 'z');
        coeff_name = ['B', digits];
    end
    fprintf('%s = %.6f\n', coeff_name, B_coeffs(i));
end