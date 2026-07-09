local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SelectOutfitTryOnMostRecentAssetId = require(Modules.AvatarExperience.Common.Selectors.SelectOutfitTryOnMostRecentAssetId)
local Constants = require(Modules.AvatarExperience.Common.Constants)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

return function(p1) -- line: 14
	-- upvalues: SelectOutfitTryOnMostRecentAssetId (copy), Constants (copy)
	return SelectOutfitTryOnMostRecentAssetId(p1, Constants.AssetTypeIdStrings.IdleAnimation)
end
