local parent = script:FindFirstAncestor("GameFilters").Parent
require(parent.DiscoveryTypes)

local function getSelectedGameFilterOptions(items)
	local selectedOptionIdsByFilterType = {}

	for _, item in items do
		if item.selectedOptionId ~= item.defaultOptionId then
			selectedOptionIdsByFilterType[item.filterType] = item.selectedOptionId
		end
	end

	return selectedOptionIdsByFilterType
end

return getSelectedGameFilterOptions
