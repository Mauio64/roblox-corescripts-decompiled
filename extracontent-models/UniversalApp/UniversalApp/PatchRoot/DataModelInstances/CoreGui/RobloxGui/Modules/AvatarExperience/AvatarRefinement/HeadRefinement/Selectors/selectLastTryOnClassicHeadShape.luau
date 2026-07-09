local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")

require(CorePackages.Workspace.Packages.AvatarExperienceHeadRefinement)
require(Modules.AvatarExperience.Common.AvatarExperienceState)

local function selectLastSelectedHeadShape(p1) -- line: 8
	return p1.AvatarExperience.AvatarScene.OutfitTryOn.LastTryOnClassicHeadShape
end

return selectLastSelectedHeadShape
