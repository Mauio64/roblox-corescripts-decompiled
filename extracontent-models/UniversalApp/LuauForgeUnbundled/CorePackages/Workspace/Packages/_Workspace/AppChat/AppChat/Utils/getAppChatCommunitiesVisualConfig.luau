local getFFlagUseCommunitiesTranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").GetFFlagUseCommunitiesTranslation

return function()
	return {
		label = getFFlagUseCommunitiesTranslation() and "Feature.SocialTab.Label.Groups" or "CommonUI.Features.Label.sGroups",
		icon = "icons/menu/groups",
		iconLarge = "icons/menu/groups_large"
	}
end
