function [B_coeffs] = coded_to_natural(b_coeffs, coded_terms, X0, n)
    if numel(b_coeffs) ~= numel(coded_terms)
        error('Количество коэффициентов должно совпадать!');
    end
    term_indices = parse_terms(coded_terms);
    B_coeffs = zeros(size(b_coeffs));
    X0 = X0(:);
    n = n(:);
    if numel(X0) ~= numel(n)
        error('Lengths of X0 and n must match!');
    end
    num_factors = numel(X0);
    
    indices_to_coef_idx = containers.Map('KeyType', 'char', 'ValueType', 'double');
    for i = 1:numel(term_indices)
        if ~isempty(term_indices{i})
            key = sprintf('%d,', sort(term_indices{i}));
            indices_to_coef_idx(key) = i;
        else
            indices_to_coef_idx('0') = i;
        end
    end

    b0_idx = indices_to_coef_idx('0');
    

    linear_indices = cell(num_factors, 1);
    for i = 1:num_factors
        key = sprintf('%d,', i);
        if indices_to_coef_idx.isKey(key)
            linear_indices{i} = indices_to_coef_idx(key);
        else
            linear_indices{i} = -1; % Нет такого коэффициента
        end
    end
    

    interaction_indices = {};
    count = 1;
    % Взаимодействия двух факторов
    for i = 1:num_factors
        for j = i+1:num_factors
            key = sprintf('%d,%d,', i, j);
            if indices_to_coef_idx.isKey(key)
                interaction_indices{count} = indices_to_coef_idx(key);
                count = count + 1;
            end
        end
    end
    % Взаимодействия трех факторов
    for i = 1:num_factors
        for j = i+1:num_factors
            for k = j+1:num_factors
                key = sprintf('%d,%d,%d,', i, j, k);
                if indices_to_coef_idx.isKey(key)
                    interaction_indices{count} = indices_to_coef_idx(key);
                    count = count + 1;
                end
            end
        end
    end

    

    % Сначала B0
    B0 = b_coeffs(b0_idx);
    
    % Вычитаем линейные члены
    for i = 1:num_factors
        if linear_indices{i} > 0
            B0 = B0 - b_coeffs(linear_indices{i}) * X0(i) / n(i);
        end
    end
    
    % Добавляем взаимодействия двух факторов
    for i = 1:num_factors
        for j = i+1:num_factors
            key = sprintf('%d,%d,', i, j);
            if indices_to_coef_idx.isKey(key)
                idx = indices_to_coef_idx(key);
                B0 = B0 + b_coeffs(idx) * X0(i) * X0(j) / (n(i) * n(j));
            end
        end
    end
    
    % Вычитаем взаимодействия трех факторов
    for i = 1:num_factors
        for j = i+1:num_factors
            for k = j+1:num_factors
                key = sprintf('%d,%d,%d,', i, j, k);
                if indices_to_coef_idx.isKey(key)
                    idx = indices_to_coef_idx(key);
                    B0 = B0 - b_coeffs(idx) * X0(i) * X0(j) * X0(k) / (n(i) * n(j) * n(k));
                end
            end
        end
    end
    
    
    B_coeffs(b0_idx) = B0;
    

    for i = 1:num_factors
        if linear_indices{i} <= 0
            continue;
        end
        
        idx = linear_indices{i};
        B_i = b_coeffs(idx) / n(i);
        

        for j = 1:num_factors
            if j ~= i
                key = sprintf('%d,%d,', min(i, j), max(i, j));
                if indices_to_coef_idx.isKey(key)
                    interaction_idx = indices_to_coef_idx(key);
                    B_i = B_i - b_coeffs(interaction_idx) * X0(j) / (n(i) * n(j));
                end
            end
        end
        
        % Добавляем трехфакторные взаимодействия
        for j = 1:num_factors
            for k = j+1:num_factors
                if j ~= i && k ~= i
                    indices = sort([i, j, k]);
                    key = sprintf('%d,%d,%d,', indices(1), indices(2), indices(3));
                    if indices_to_coef_idx.isKey(key)
                        interaction_idx = indices_to_coef_idx(key);
                        B_i = B_i + b_coeffs(interaction_idx) * X0(j) * X0(k) / (n(i) * n(j) * n(k));
                    end
                end
            end
        end
        
        B_coeffs(idx) = B_i;
    end
    
    % Обрабатываем взаимодействия двух факторов
    for i = 1:num_factors
        for j = i+1:num_factors
            key = sprintf('%d,%d,', i, j);
            if indices_to_coef_idx.isKey(key)
                idx = indices_to_coef_idx(key);
                B_ij = b_coeffs(idx) / (n(i) * n(j));
                
                % Вычитаем трехфакторные взаимодействия
                for k = 1:num_factors
                    if k ~= i && k ~= j
                        indices = sort([i, j, k]);
                        key_ijk = sprintf('%d,%d,%d,', indices(1), indices(2), indices(3));
                        if indices_to_coef_idx.isKey(key_ijk)
                            interaction_idx = indices_to_coef_idx(key_ijk);
                            B_ij = B_ij - b_coeffs(interaction_idx) * X0(k) / (n(i) * n(j) * n(k));
                        end
                    end
                end
                
                B_coeffs(idx) = B_ij;
            end
        end
    end
    

    for i = 1:numel(term_indices)
        indices = term_indices{i};
        if length(indices) >= 3
            B_coeffs(i) = b_coeffs(i) / prod(n(indices));
        end
    end
end