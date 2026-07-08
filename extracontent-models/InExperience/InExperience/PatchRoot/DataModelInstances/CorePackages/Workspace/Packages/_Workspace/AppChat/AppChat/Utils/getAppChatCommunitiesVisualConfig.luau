local Parent = script:FindFirstAncestor("AppChat").Parent
local GetFFlagUseCommunitiesTranslation = require(Parent.SharedFlags).GetFFlagUseCommunitiesTranslation

return function() -- line: 13
	-- upvalues: GetFFlagUseCommunitiesTranslation (copy)
	local s1 = "CommonUI.Features.Label.sGroups"

	if GetFFlagUseCommunitiesTranslation() then
		s1 = "Feature.SocialTab.Label.Groups"
	end

	return {
		icon = "icons/menu/groups",
		iconLarge = "icons/menu/groups_large",
		label = s1
	}
end
