local Parent = script:FindFirstAncestor("DataHydration").Parent

require(Parent.MomentsTypes)

return {
	resolveEmoteIdForReaction = function(t1: {[any]: any}, p1) -- line: 22
		local v6 = string.gsub(string.lower(p1), "%-", "")
		local v7 = if v6 ~= "crying" then v6 else "cry"

		for _, v9 in t1 do
			if p1 == v9.id then
				return v9.id
			end

			local name = v9.name
			local v11 = string.gsub(string.lower(name), "%-", "")

			if v7 == if v11 ~= "crying" then v11 else "cry" then
				return v9.id
			end
		end

		return p1
	end,
	reactionTypeForEmoteId = function(t2: {[any]: any}, s1: string) -- line: 36
		for _, v15 in t2 do
			if s1 == v15.id then
				local name = v15.name
				local v17 = string.gsub(string.lower(name), "%-", "")

				if v17 == "crying" then
					return "cry"
				end

				return v17
			end
		end

		return s1
	end,
	normalizeName = function(s2: string) -- line: 12
		local v3 = string.gsub(string.lower(s2), "%-", "")

		if v3 == "crying" then
			return "cry"
		end

		return v3
	end
}
