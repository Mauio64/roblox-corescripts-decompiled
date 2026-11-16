require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/DiscoveryTypes")

return function(p2, p3)
	if p3 == nil then
		return nil
	end

	for k, filterOption in p2.filterOptions do
		if filterOption.optionId == p3 then
			if filterOption.optionContextTag and filterOption.optionContextTag ~= "" then
				return filterOption.optionContextTag
			end

			return nil
		end
	end

	return nil
end
