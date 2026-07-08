local Parent = script:FindFirstAncestor("GameFilters").Parent

require(Parent.DiscoveryTypes)

return function(p1, s1: string?) -- line: 6
	if s1 == nil then
		return nil
	end

	for _, v5 in p1.filterOptions do
		if s1 == v5.optionId then
			if not v5.optionContextTag or v5.optionContextTag == "" then
				return nil
			end

			return v5.optionContextTag
		end
	end

	return nil
end
