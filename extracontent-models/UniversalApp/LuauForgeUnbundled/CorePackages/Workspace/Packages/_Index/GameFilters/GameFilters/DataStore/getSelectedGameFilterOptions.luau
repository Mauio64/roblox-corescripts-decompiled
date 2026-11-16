require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/DiscoveryTypes")

local function getSelectedGameFilterOptions(items)
	local selectedOptionIdsByFilterType = {}

	for k, item in items do
		if item.selectedOptionId ~= item.defaultOptionId then
			selectedOptionIdsByFilterType[item.filterType] = item.selectedOptionId
		end
	end

	return selectedOptionIdsByFilterType
end

return getSelectedGameFilterOptions
