local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local Constants = require(AvatarExperienceCommon.Constants)

local function selectDefaultTryOnBodyColors(p)
	local outfitTryOn = p.AvatarExperience.AvatarScene.OutfitTryOn
	local outfitInfos = p.AvatarExperience.AvatarEditor.OutfitInfos
	local outfitIdMap = outfitTryOn.OutfitIdMap

	for _, tryOnItem in outfitTryOn.TryOnItems do
		if
			outfitIdMap
			and tryOnItem.itemType == "Bundle"
			and tryOnItem.itemSubType == Constants.BODY_BUNDLE_TYPE_ID
			and tryOnItem.receivedBundleInfo
		then
			local outfitId = outfitIdMap[tryOnItem.itemId]
			local v

			if outfitId then
				v = outfitInfos[outfitId]
			end

			return if v then v.bodyColor3s else nil
		end
	end

	return nil
end

return selectDefaultTryOnBodyColors
