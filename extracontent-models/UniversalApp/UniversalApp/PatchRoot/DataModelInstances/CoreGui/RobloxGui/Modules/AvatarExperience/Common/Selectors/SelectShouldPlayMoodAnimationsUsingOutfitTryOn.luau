local Modules = game:GetService("CoreGui").RobloxGui.Modules

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local SelectOutfitTryOnMoodAnimationAssetId = require(Modules.AvatarExperience.Common.Selectors.SelectOutfitTryOnMoodAnimationAssetId)
local SelectShouldPlayMoodAnimationsEquipped = require(Modules.AvatarExperience.Common.Selectors.SelectShouldPlayMoodAnimationsEquipped)

return function(p1) -- line: 15
	-- upvalues: SelectOutfitTryOnMoodAnimationAssetId (copy), SelectShouldPlayMoodAnimationsEquipped (copy)
	if SelectOutfitTryOnMoodAnimationAssetId(p1) then
		return true
	end

	return SelectShouldPlayMoodAnimationsEquipped(p1)
end
