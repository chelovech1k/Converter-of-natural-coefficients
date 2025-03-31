function term_indices = parse_terms(terms)
    term_indices = cell(numel(terms), 1);
    for i = 1:numel(terms)
        term = terms{i};
        if isempty(term)
            term_indices{i} = [];
        else
            factors = regexp(term, 'z(\d+)', 'tokens');
            factors = [factors{:}];
            term_indices{i} = cellfun(@(x) str2double(x), factors);
        end
    end
end