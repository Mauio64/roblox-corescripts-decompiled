local backgroundGenerationSet = {
	[require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceNavigation").Enums.AvatarScreen.BackgroundGeneration] = true
}

local function isVRHiddenRobuxBalanceScreen(p2): boolean
	return p2 ~= nil and backgroundGenerationSet[p2] == true
end

return isVRHiddenRobuxBalanceScreen
