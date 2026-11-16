require("@luauforge/deferred/gTG")

local function getOrganicResultIdsFromEntries(items)
	local organicResultIds = {}

	for k, item in items do
		if item.id and item.type then
			table.insert(organicResultIds, item.type .. item.id)
		end
	end

	return organicResultIds
end

return getOrganicResultIdsFromEntries
