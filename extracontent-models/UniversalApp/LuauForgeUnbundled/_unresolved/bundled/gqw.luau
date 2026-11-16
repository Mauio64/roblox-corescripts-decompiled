local module = require("@luauforge/bundled/dMx")
require("@luauforge/bundled/dHK")
require("@luauforge/bundled/dHL")
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local v5 = memoize(function(items, p2)
	local v6 = nil
	local v7 = nil
	local bundleInfo = nil

	for k, item in items do
		if not item.selectedInTryOnManager then
			continue
		end

		local itemRecency = item.itemRecency

		if item.itemType == module.ItemType.Asset then
			if item.itemSubType == p2 and (v6 == nil or v6 < itemRecency) then
				v7 = item.itemId
				v6 = itemRecency
				bundleInfo = nil
			end
		elseif item.bundleInfo then
			for k2, v8 in item.bundleInfo do
				if not (v8.assetType == p2 and (v6 == nil or v6 < itemRecency)) then
					continue
				end

				bundleInfo = item.bundleInfo
				v7 = k2
				v6 = itemRecency
			end
		end
	end

	return v7, bundleInfo, v6
end)

return function(p2, p3)
	return v5(p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems, p3)
end
