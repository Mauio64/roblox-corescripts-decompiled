local module = require("@luauforge/bundled/gqj")

local function selectShowColorQuickButton(p2): boolean
	local v5 = module(p2)

	local lastToggledItem = p2.AvatarExperience.AvatarScene.OutfitTryOn.LastToggledItem

	for k, v6 in v5 do
		local bundleInfo = p2.AvatarExperience.Common.BundleInfos[v6]

		if bundleInfo and bundleInfo.isRecolorable and lastToggledItem and lastToggledItem.itemId == v6 then
			return true
		end
	end

	return false
end

return selectShowColorQuickButton
