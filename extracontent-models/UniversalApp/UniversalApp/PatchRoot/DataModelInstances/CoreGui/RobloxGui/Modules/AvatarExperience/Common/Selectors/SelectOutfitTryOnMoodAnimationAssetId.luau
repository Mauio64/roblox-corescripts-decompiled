local Modules = game:GetService("CoreGui").RobloxGui.Modules

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local Constants = require(Modules.AvatarExperience.Common.Constants)
local SelectOutfitTryOnMostRecentAssetId = require(Modules.AvatarExperience.Common.Selectors.SelectOutfitTryOnMostRecentAssetId)

return function(p1) -- line: 38
	-- upvalues: SelectOutfitTryOnMostRecentAssetId (copy), Constants (copy)
	local _, v6, v7 = SelectOutfitTryOnMostRecentAssetId(p1, Constants.AssetTypeIdStrings.DynamicHead)
	local _, _, v10 = SelectOutfitTryOnMostRecentAssetId(p1, Constants.AssetTypeIdStrings.Head)

	if v10 and (not v7 or v7 < v10) then
		return nil
	end

	if not v6 then
		return nil
	end

	assert(v6, "tryOnBundleInfo is non-nil. Silence type checker")

	for v11, v12 in v6 do
		if v12.assetType == Constants.AssetTypeIdStrings.MoodAnimation then
			return v11
		end
	end

	return nil
end
