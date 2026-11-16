local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize

local module = require("@luauforge/bundled/fuD")
local module2 = require("@luauforge/bundled/dMx")
local module3 = require("@luauforge/bundled/dOD")
require("@luauforge/bundled/dHK")

require("@luauforge/bundled/dMc")
require("@luauforge/bundled/dHL")

local function separateSortedAssets(p2, list, p3, p4, p5, k)
	if p2[p3.typeId] and p2[p3.typeId][p3.id] then
		p4[p3.id] = {
			assetTypeId = p3.typeId,
			order = #list - k
		}
	else
		p5[p3.id] = #list - k
	end
end

local v5 = memoize(function(p2, p3, p4, items, p5, p6, p7, p8)
	local v6 = {}
	local v7 = nil
	local v8 = {}
	local v9 = {}

	if p3 == module2.ItemType.Bundle then
		if p6 and p6.items then
			assert(p6, "silence type checker")
			assert(p6.items, "silence type checker")

			for k, item in p6.items do
				local assetType = p8[item.id] and p8[item.id].assetType

				if not assetType then
					continue
				end

				local v10 = module2.LayeredAssetTypes[assetType] ~= nil

				if not p5 and not module2.LCIgnoredForSorting[assetType] and v10 then
					items, v7 = module3.getTableAndOrderAfterEquippingIntoSort(items, {
						id = item.id,
						typeId = assetType
					})
				end

				v6[tostring(item.id)] = {
					assetType = assetType,
					order = v7 or module2.LayeredClothingOrder[assetType]
				}
			end

			for k, item in pairs(items) do
				if v6[item.id] == nil then
					separateSortedAssets(p7, items, item, v8, v9, k)
				end
			end
		end
	else
		local v10 = module2.LayeredAssetTypes[p4] ~= nil

		if not p5 and not module2.LCIgnoredForSorting[p4] and v10 then
			local v11
			v11, v7 = module3.getTableAndOrderAfterEquippingIntoSort(items, {
				id = p2,
				typeId = p4
			})

			for k, v12 in v11 do
				if v12.id ~= p2 then
					separateSortedAssets(p7, v11, v12, v8, v9, k)
				end
			end
		end
	end

	return {
		overrideOrder = v7,
		bundleInfoMapping = v6,
		equippedAssetsToSetOrder = v8,
		itemIdToOrderMap = v9
	}
end)

return function(p2, p3, p4, p5, p6, p7)
	local equippedAssets = p2.AvatarExperience.AvatarEditor.Character.EquippedAssets
	local assetInfos = p2.AvatarExperience.Common.AssetInfos
	return v5(p3, p4, p5, p6, p7, module.getBundleInfoFromState(p2, p3), equippedAssets, assetInfos)
end
