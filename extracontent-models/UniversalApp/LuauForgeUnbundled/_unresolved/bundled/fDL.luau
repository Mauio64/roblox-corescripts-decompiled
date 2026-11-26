local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local module2 = require("@luauforge/bundled/fCe")
local module3 = require("@luauforge/bundled/dPN")
local module4 = require("@luauforge/bundled/dRW")
require("@luauforge/bundled/dKT")

require("@luauforge/bundled/dPs")
require("@luauforge/bundled/dKU")
local ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE = AvatarExperienceCommon.Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE

local function _separateSortedAssets(p2, p3, data, p4, p5)
	if p2[data.typeId] and p2[data.typeId][data.id] then
		p4[data.id] = { assetTypeId = data.typeId, order = data.order }
	end
end

local function fn(p2, p3, p4, p5, equippedAssets, assetInfos, bundleInfoFromState)
	local v8

	if not (p3 == module3.ItemType.Bundle or not (p4 and ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[p4])) then
		local v9
		v9, v8 = module4.getTableAndOrderAfterEquippingIntoSort(p5, {
			id = p2,
			typeId = p4
		})
	end

	return {
		overrideOrder = v8,
		bundleInfoMapping = {},
		equippedAssetsToSetOrder = {},
		itemIdToOrderMap = {}
	}
end

return function(p2, p3, p4, p5, p6)
	return fn(
		p3,
		p4,
		p5,
		p6,
		p2.AvatarExperience.AvatarEditor.Character.EquippedAssets,
		p2.AvatarExperience.Common.AssetInfos,
		module2.getBundleInfoFromState(p2, p3)
	)
end
