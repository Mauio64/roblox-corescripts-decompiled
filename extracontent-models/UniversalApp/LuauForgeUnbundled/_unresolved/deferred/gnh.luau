local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
local inventoryItemAvailability = require("@luauforge/bundled/fuM").Enums.InventoryItemAvailability

local fFlagAXModeratedItemsFlow = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXModeratedItemsFlow

return (memoize(function(items, p2)
	local result = {}

	for k, item in items do
		for k2, v5 in item do
			table.insert(result, fFlagAXModeratedItemsFlow and { k2, v5.availabilityStatus } or k2)
		end
	end

	if p2 ~= nil then
		local v5 = tostring(p2)
		table.insert(
			result,
			fFlagAXModeratedItemsFlow and { v5, inventoryItemAvailability.Available } or v5
		)
	end

	return result
end))
