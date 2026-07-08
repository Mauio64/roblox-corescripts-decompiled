local Parent = script:FindFirstAncestor("GameFilters").Parent

require(Parent.DiscoveryTypes)

local function getSelectedGameFilterOptions(t1: {[any]: any}) -- line: 6
	local t2 = {}

	for _, v6 in t1 do
		if v6.selectedOptionId ~= v6.defaultOptionId then
			t2[v6.filterType] = v6.selectedOptionId
		end
	end

	return t2
end

return getSelectedGameFilterOptions
