local module = require("@luauforge/bundled/dPN")
require("@luauforge/bundled/dKT")

local function selectDefaultTryOnBodyColors(p2)
	local outfitTryOn = p2.AvatarExperience.AvatarScene.OutfitTryOn
	local outfitInfos = p2.AvatarExperience.AvatarEditor.OutfitInfos
	local outfitIdMap = outfitTryOn.OutfitIdMap

	for k, tryOnItem in outfitTryOn.TryOnItems do
		if
			outfitIdMap
			and tryOnItem.itemType == "Bundle"
			and module.BundleTypeIdStringToNameForBackend[tryOnItem.itemSubType] == "Body"
			and tryOnItem.receivedBundleInfo
		then
			local outfitId = outfitIdMap[tryOnItem.itemId]
			local v5 = if outfitId then outfitInfos[outfitId] else nil

			if v5 then
				return v5.bodyColor3s
			end

			return nil
		end
	end

	return nil
end

return selectDefaultTryOnBodyColors
