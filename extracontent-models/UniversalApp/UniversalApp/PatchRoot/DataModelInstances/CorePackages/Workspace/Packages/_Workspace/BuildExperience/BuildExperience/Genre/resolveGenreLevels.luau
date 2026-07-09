local GenreTaxonomy = require(script.Parent.GenreTaxonomy)

return {
	resolveGenreLevels = function(s1: string) -- line: 7
		-- upvalues: GenreTaxonomy (copy)
		for _, v4 in GenreTaxonomy.genres do
			if s1 == v4.id then
				return s1, nil
			end

			for _, v6 in v4.subgenres do
				if s1 == v6.id then
					return v4.id, s1
				end
			end
		end

		return nil, s1
	end
}
