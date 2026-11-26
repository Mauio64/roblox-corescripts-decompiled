local module = require("@luauforge/bundled/dPN")
local module2 = require("@luauforge/bundled/fCe")
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
require("@luauforge/bundled/dKU")

local v5 = memoize(function(p2, p3, items)
	local v6 = false
	local v7 = false

	for k, item in items do
		if
			item.itemType == module.ItemType.Asset
			and item.itemSubType == module.AssetTypeIdStrings.Head
		then
			v6 = true
		elseif item.itemType == module.ItemType.Bundle then
			if item.itemSubType == module.BundleTypeIdStrings.DynamicHead then
				v7 = true
			elseif item.itemSubType == module.BundleTypeIdStrings.BodyParts then
				local bundleInfo = module2.getBundleInfo(p2, k)
				local outfitInfoFromBundleIdNoState = module2.getOutfitInfoFromBundleIdNoState(bundleInfo, p3)

				if not item.receivedBundleInfo or outfitInfoFromBundleIdNoState == nil then
					return v6, v7, false
				end

				local v8

				if outfitInfoFromBundleIdNoState then
					v8 = outfitInfoFromBundleIdNoState.containsDynamicHead
				else
					v8 = false
				end

				if v8 then
					v7 = true
				else
					v6 = true
				end
			end
		end
	end

	return v6, v7, true
end)

return function(p2)
	return v5(
		p2.AvatarExperience.Common.BundleInfos,
		p2.AvatarExperience.AvatarEditor.OutfitInfos,
		p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
	)
end
