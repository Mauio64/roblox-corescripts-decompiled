local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local module2 = require("@luauforge/bundled/dPN")
local module3 = require("@luauforge/bundled/dRU")
require("@luauforge/bundled/dPs")

local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey

local LAYERED_MAKEUP_ORDER = AvatarExperienceCommon.Constants.LAYERED_MAKEUP_ORDER

local MAX_MAKEUP_LAYERS = AvatarExperienceCommon.Constants.MAX_MAKEUP_LAYERS

return {
	getEquippedAssetsBasedOnSortTable = function(list, p2, p3, items)
		if not p2 then
			return {}
		end

		local result = {}

		for k, item in list do
			if p2[item.typeId] and p2[item.typeId][item.id] then
				local defaultMetadata = module3.getDefaultMetadata(item.typeId)
				defaultMetadata.order = #list - k
				local typeId = item.typeId
				result[typeId] = Cryo.Dictionary.join(result[item.typeId] or {}, {
					[item.id] = defaultMetadata
				})
			end

			if not items then
				continue
			end

			for k2, item2 in items do
				if k2 ~= item.id or p3[getTryOnItemReducerKey(k2, module2.ItemType.Asset)] then
					continue
				end

				local defaultMetadata = module3.getDefaultMetadata(item2)
				defaultMetadata.order = #list - k
				local typeId = item.typeId
				result[typeId] = Cryo.Dictionary.join(result[item.typeId] or {}, {
					[item.id] = defaultMetadata
				})
			end
		end

		return result
	end,
	getTryOnItemsOrderBasedOnSortTable = function(list, p2)
		if not p2 then
			return {}
		end

		local result = {}

		for k, item in list do
			if p2[getTryOnItemReducerKey(item.id, module2.ItemType.Asset)] then
				result[item.id] = #list - k
			end
		end

		return result
	end,
	getTableAndOrderAfterEquippingIntoSort = function(list, p2)
		if not LAYERED_MAKEUP_ORDER[p2.typeId] then
			return list, 0
		end

		table.insert(list, 1, p2)
		local v6 = MAX_MAKEUP_LAYERS < #list and { table.unpack(list, 1, MAX_MAKEUP_LAYERS) } or list

		return v6, #v6
	end,
	getSortedEquippedLayeredMakeup = function(items)
		if not items then
			return nil
		end

		local orders = {}
		local result = {}

		for k, item in items do
			if module2.LayeredClothingOrder[k] then
				continue
			end

			for k2, v5 in item do
				if not v5.isLayered then
					continue
				end

				orders[k2] = v5.order or LAYERED_MAKEUP_ORDER[k]
				table.insert(result, { id = k2, typeId = k })
			end
		end

		table.sort(result, function(a, b): boolean
			return orders[a.id] > orders[b.id]
		end)

		return result
	end
}
