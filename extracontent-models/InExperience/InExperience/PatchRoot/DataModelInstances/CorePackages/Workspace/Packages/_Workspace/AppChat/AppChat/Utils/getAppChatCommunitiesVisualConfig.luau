local parent = script:FindFirstAncestor("AppChat").Parent

local SharedFlags = require(parent.SharedFlags)
local GetFFlagUseCommunitiesTranslation = SharedFlags.GetFFlagUseCommunitiesTranslation

return function()
	return {
		label = GetFFlagUseCommunitiesTranslation() and "Feature.SocialTab.Label.Groups" or "CommonUI.Features.Label.sGroups",
		icon = "icons/menu/groups",
		iconLarge = "icons/menu/groups_large"
	}
end
