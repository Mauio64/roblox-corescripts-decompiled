local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").mutedError

local module3 = require("@luauforge/bundled/dPN")
local module4 = require("@luauforge/bundled/dRU")
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
require("@luauforge/bundled/dKU")
require("@luauforge/bundled/dPs")

local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE = AvatarExperienceCommon.Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE
local fFlagFixLayeredSorting = AvatarExperienceFlags.FFlagFixLayeredSorting
local defineFastFlag = game:DefineFastFlag("AXCloneLCSortOrderingTable", false)

return {
	["createAssetIdToOrderMapping"] = memoize(function(list)
		local result = {}

		for k, item in list do
			result[item.id] = {
				order = #list - k,
				assetTypeId = item.typeId
			}
		end

		return result
	end),
	formatForSetOrder = memoize(function(list, p2)
		if not p2 then
			return nil
		end

		local result = {}

		for k, item in list do
			if p2[item.typeId] and p2[item.typeId][item.id] or item.equipped then
				result[item.id] = {
					order = #list - k,
					assetTypeId = item.typeId
				}
			end
		end

		return result
	end),
	formatForSetOrderWithTryOns = memoize(function(list, p2, items, p3)
		if not p2 then
			return nil
		end

		local result = {}
		local result2 = {}

		for k, item in list do
			local tryOnItemReducerKey = getTryOnItemReducerKey(item.id, module3.ItemType.Asset)

			if p2[item.typeId] and p2[item.typeId][item.id] or item.equipped then
				result[item.id] = {
					order = #list - k,
					assetTypeId = item.typeId
				}
			elseif items and items[tryOnItemReducerKey] then
				result2[item.id] = #list - k
			else
				assert(items ~= nil, "tryOnItems should not be nil")

				for k2, item2 in items do
					if item2.bundleInfo and item2.bundleInfo[item.id] then
						result2[item.id] = #list - k
						break
					end
				end
			end
		end

		return result, result2
	end),
	formatForEquipOutfit = memoize(function(list, p2)
		if not p2 then
			return nil
		end

		local result = {}

		for k, item in list do
			if not (p2[item.typeId] and p2[item.typeId][item.id] or item.equipped) then
				continue
			end

			local defaultMetadata = module4.getDefaultMetadata(item.typeId)
			defaultMetadata.order = #list - k

			local typeId = item.typeId
			local defaultMetadatasById = { [item.id] = defaultMetadata }
			result[typeId] = defaultMetadatasById
		end

		return result
	end),
	getTableAndOrderAfterEquippingIntoSort = memoize(function(list, p2)
		if not module3.LayeredClothingOrder[p2.typeId] then
			return list, 0
		end

		local v5 = if defineFastFlag then table.clone(list) else list
		local v6 = 0
		local v7 = 0

		for k, item in list do
			if module3.LayeredClothingOrder[item.typeId] == nil then
				mutedError(`getTableAndOrderAfterEquippingIntoSort could not find in layeredClothingOrder typeId: {item.typeId} assetId: {item.id}`)
			end

			if item.typeId == p2.typeId then
				if fFlagFixLayeredSorting and item.id == p2.id then
					table.remove(v5, k)
					return v5, (math.max(0, k - 1))
				end

				v6 = k
			elseif
				v6 == 0
				and module3.LayeredClothingOrder[item.typeId] > module3.LayeredClothingOrder[p2.typeId]
			then
				v7 = k
			end
		end

		local v8 = 1

		if v6 > 0 then
			v8 = v6
		elseif v7 > 0 then
			v8 = v7 + 1
		end

		table.insert(v5, v8, p2)

		if defineFastFlag then
			return v5, #v5 - v8
		end

		return v5, #list - v8
	end),
	getSortedEquippedLCIfNoDefault = memoize(function(items)
		if not items then
			return nil
		end

		local orders = {}
		local result = {}
		local flag = true

		for k, item in items do
			if ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[k] then
				continue
			end

			for k2, v5 in item do
				if v5.order and v5.order ~= module3.LayeredClothingOrder[k] then
					flag = false
				end

				if not v5.isLayered then
					continue
				end

				orders[k2] = v5.order or module3.LayeredClothingOrder[k]
				table.insert(result, { id = k2, typeId = k })
			end
		end

		if flag then
			return nil
		end

		table.sort(result, function(a, b): boolean
			return orders[a.id] > orders[b.id]
		end)

		return result
	end)
}
