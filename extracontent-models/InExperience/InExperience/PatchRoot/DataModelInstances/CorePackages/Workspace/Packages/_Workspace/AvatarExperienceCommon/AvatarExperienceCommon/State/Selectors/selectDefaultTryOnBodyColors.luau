local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local Constants = require(AvatarExperienceCommon.Constants)

local function selectDefaultTryOnBodyColors(p1) -- line: 4
	-- upvalues: Constants (copy)
	local OutfitTryOn = p1.AvatarExperience.AvatarScene.OutfitTryOn
	local OutfitInfos = p1.AvatarExperience.AvatarEditor.OutfitInfos
	local OutfitIdMap = OutfitTryOn.OutfitIdMap

	for _, v9 in OutfitTryOn.TryOnItems do
		if OutfitIdMap and v9.itemType == "Bundle" and v9.itemSubType == Constants.BODY_BUNDLE_TYPE_ID and v9.receivedBundleInfo then
			local v10 = OutfitIdMap[v9.itemId]
			local v11 = if not v10 then nil else OutfitInfos[v10]

			if v11 then
				return v11.bodyColor3s
			end

			return nil
		end
	end

	return nil
end

return selectDefaultTryOnBodyColors
