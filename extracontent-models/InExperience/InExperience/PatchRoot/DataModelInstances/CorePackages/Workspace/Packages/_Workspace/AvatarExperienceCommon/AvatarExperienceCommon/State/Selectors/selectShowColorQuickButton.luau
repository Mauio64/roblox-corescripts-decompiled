local selectTryOnBodyIds = require(script.Parent.selectTryOnBodyIds)

local function selectShowColorQuickButton(p): boolean
	local v = selectTryOnBodyIds(p)

	local lastToggledItem = p.AvatarExperience.AvatarScene.OutfitTryOn.LastToggledItem

	for _, v2 in v do
		local bundleInfo = p.AvatarExperience.Common.BundleInfos[v2]

		if bundleInfo and bundleInfo.isRecolorable and lastToggledItem and lastToggledItem.itemId == v2 then
			return true
		end
	end

	return false
end

return selectShowColorQuickButton
