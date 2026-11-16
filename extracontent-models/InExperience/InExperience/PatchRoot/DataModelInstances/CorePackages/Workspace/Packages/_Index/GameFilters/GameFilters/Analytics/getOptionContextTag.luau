local parent = script:FindFirstAncestor("GameFilters").Parent
require(parent.DiscoveryTypes)

return function(p, p2: string?)
	if p2 == nil then
		return nil
	end

	for _, filterOption in p.filterOptions do
		if filterOption.optionId == p2 then
			if filterOption.optionContextTag and filterOption.optionContextTag ~= "" then
				return filterOption.optionContextTag
			end

			return nil
		end
	end

	return nil
end
