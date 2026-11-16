local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local module2 = require("@luauforge/bundled/dMx")
require("@luauforge/bundled/dHK")
require("@luauforge/bundled/dMc")

local ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE = AvatarExperienceCommon.Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE
local LAYERED_MAKEUP_ORDER = AvatarExperienceCommon.Constants.LAYERED_MAKEUP_ORDER

local v5 = memoize(function(items, items2)
	local result = {}
	local orders = {}

	if items2 ~= nil then
		for k, item in items2 do
			if item.itemType == module2.ItemType.Asset then
				local itemSubType = item.itemSubType

				if ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[itemSubType] then
					orders[item.itemId] = item.order or LAYERED_MAKEUP_ORDER[itemSubType]

					table.insert(result, { id = item.itemId, typeId = itemSubType })
				end
			elseif item.bundleInfo then
				for k2, v6 in item.bundleInfo do
					local assetType = v6.assetType

					if not ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[assetType] then
						continue
					end

					orders[k2] = v6.order or LAYERED_MAKEUP_ORDER[assetType]

					table.insert(result, { id = k2, typeId = assetType })
				end
			end
		end
	end

	if items ~= nil then
		for k, item in items do
			for k2, v6 in item do
				if not LAYERED_MAKEUP_ORDER[k] then
					continue
				end

				orders[k2] = v6.order or LAYERED_MAKEUP_ORDER[k]

				table.insert(result, { id = k2, typeId = k })
			end
		end
	end

	table.sort(result, function(a, b): boolean
		return orders[a.id] > orders[b.id]
	end)

	return result
end)

return function(p2)
	return v5(
		p2.AvatarExperience.AvatarEditor.Character.EquippedAssets,
		p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
	)
end
