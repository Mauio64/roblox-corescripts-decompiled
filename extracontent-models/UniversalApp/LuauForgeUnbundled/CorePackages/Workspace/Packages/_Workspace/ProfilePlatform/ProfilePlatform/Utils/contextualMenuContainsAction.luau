require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/Types")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")

local function contextualMenuContainsAction(items, p2): boolean
	if not items then
		return false
	end

	for k, item in items do
		for k2, item2 in item.items do
			if item2.id == p2 then
				return true
			end
		end
	end

	return false
end

return contextualMenuContainsAction
