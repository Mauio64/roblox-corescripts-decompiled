local Modules = game:GetService("CoreGui").RobloxGui.Modules

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local Constants = require(Modules.AvatarExperience.Common.Constants)
local SelectOutfitTryOnMostRecentAssetId = require(Modules.AvatarExperience.Common.Selectors.SelectOutfitTryOnMostRecentAssetId)

return function(p1) -- line: 14
	-- upvalues: SelectOutfitTryOnMostRecentAssetId (copy), Constants (copy)
	return (SelectOutfitTryOnMostRecentAssetId(p1, Constants.AssetTypeIdStrings.DynamicHead))
end
