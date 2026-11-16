local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
require(ProfilePlatform.Components.CTARow.Types)
require(ProfilePlatform.Common.Enums)

local function contextualMenuContainsAction(items, p): boolean
	if not items then
		return false
	end

	for _, item in items do
		for _, item2 in item.items do
			if item2.id == p then
				return true
			end
		end
	end

	return false
end

return contextualMenuContainsAction
