local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local backgroundGenerationSet = {
	[AvatarExperienceNavigation.Enums.AvatarScreen.BackgroundGeneration] = true
}

local function isVRHiddenRobuxBalanceScreen(p: string?): boolean
	return p ~= nil and backgroundGenerationSet[p] == true
end

return isVRHiddenRobuxBalanceScreen
