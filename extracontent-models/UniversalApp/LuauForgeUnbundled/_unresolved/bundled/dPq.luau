local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local Dash = require(CorePackages.Packages.Dash)
local module = require("@luauforge/bundled/dKU")

local module2 = require("@luauforge/bundled/dPr")
local module3 = require("@luauforge/bundled/dPu")
local module4 = require("@luauforge/bundled/dPv")

local module5 = require("@luauforge/bundled/dPw")
local removeLook = module.Actions.RemoveLook
require("@luauforge/bundled/dPs")

local v5 = {}

local function getItemInfo(items)
	local itemInfo = {}

	if items then
		for k, item in items do
			itemInfo[tostring(item.id)] = item
		end
	end

	return itemInfo
end

return Rodux.createReducer(v5, {
	[module2.name] = function(p2, data)
		local v8 = {}
		local lookId = data.lookId
		local v9 = {
			lookType = data.lookType,
			totalValue = data.totalValue,
			totalPrice = data.totalPrice,
			totalPremiumPrice = data.totalPremiumPrice,
			lookAssetInfos = 0,
			lookBundleInfos = 0,
			curator = 0,
			description = 0,
			moderationStatus = 0,
			name = 0,
			displayProperties = 0,
			favoriteCount = 0,
			isFavorited = 0,
			lookDiscounts = 0
		}
		local lookAssetInfos = data.lookAssetInfos
		local lookAssetInfosById = {}

		if lookAssetInfos then
			for k, lookAssetInfo in lookAssetInfos do
				lookAssetInfosById[tostring(lookAssetInfo.id)] = lookAssetInfo
			end
		end

		v9.lookAssetInfos = lookAssetInfosById
		local lookBundleInfos = data.lookBundleInfos
		local lookBundleInfosById = {}

		if lookBundleInfos then
			for k, lookBundleInfo in lookBundleInfos do
				lookBundleInfosById[tostring(lookBundleInfo.id)] = lookBundleInfo
			end
		end

		v9.lookBundleInfos = lookBundleInfosById
		v9.curator = data.curator
		v9.description = data.description
		v9.moderationStatus = data.moderationStatus
		v9.name = data.name
		v9.displayProperties = data.displayProperties
		v9.favoriteCount = data.favoriteCount
		v9.isFavorited = data.isFavorited
		v9.lookDiscounts = data.lookDiscounts
		v8[lookId] = v9

		return Cryo.Dictionary.join(p2 or v5, v8)
	end,
	[module3.name] = function(p2, p3)
		local v7 = p2 or v5
		local v8 = v7[p3.lookId] or {}
		local v9 = { favoriteCount = v8.favoriteCount, isFavorited = p3.isFavorited }

		local joined = Cryo.Dictionary.join(v8, v9)
		return Cryo.Dictionary.join(v7, { [p3.lookId] = joined })
	end,
	[module4.name] = function(p2, p3)
		local v7 = p2 or v5
		local v8 = v7[p3.lookId] or {}
		local joined = Cryo.Dictionary.join(v8, p3.lookDetails)
		return Cryo.Dictionary.join(v7, { [p3.lookId] = joined })
	end,
	[module5.name] = function(p2, data)
		local v7 = p2 or v5
		local v8 = if p2 then p2[data.lookId] else nil

		if v8 == nil then
			return v7
		end

		assert(v8, "")

		local v9 = v8.totalPrice or 0
		local v10 = v8.totalPremiumPrice or 0
		local lookAssetInfos = v8.lookAssetInfos
		local lookBundleInfos = v8.lookBundleInfos

		if lookAssetInfos == nil then
			warn("Looks asset info does not exist")
			return v7
		end

		for k, purchasedAssetId in data.purchasedAssetIds do
			local v11 = tostring(purchasedAssetId)
			local lookAssetInfo = lookAssetInfos[v11]

			if lookAssetInfo == nil then
				warn("Looks reducer could not find asset with id", v11)
			else
				lookAssetInfos[v11].quantityOwned = lookAssetInfo.quantityOwned + 1
				v9 -= lookAssetInfo.priceInRobux or 0
				v10 -= lookAssetInfo.premiumPriceInRobux or 0
			end
		end

		if lookBundleInfos and data.purchasedBundleIds then
			for k, purchasedBundleId in data.purchasedBundleIds do
				local v11 = tostring(purchasedBundleId)
				local lookBundleInfo = lookBundleInfos[v11]

				if lookBundleInfo == nil then
					warn("Looks reducer could not find bundle with id", v11)
				else
					lookBundleInfos[v11].quantityOwned = lookBundleInfo.quantityOwned + 1
					v9 -= lookBundleInfo.priceInRobux or 0
				end
			end
		end

		if v9 < 0 then
			warn("Looks total price is below 0 after manual calculation")
			v9 = 0
		end

		if v10 < 0 then
			warn("Looks total premium price is below 0 after manual calculation")
			v10 = 0
		end

		local v11 = {
			[data.lookId] = {
				totalPrice = v9,
				totalPremiumPrice = v10,
				lookAssetInfos = lookAssetInfos,
				lookBundleInfos = lookBundleInfos
			}
		}

		local isOwnedAfterPurchase = data.isOwnedAfterPurchase

		if isOwnedAfterPurchase then
			v11[data.lookId].owned = isOwnedAfterPurchase
		end

		local v12 = v11[data.lookId]

		local joinDeep = Dash.joinDeep(v8, v12)

		local joinDeepsByLookId = { [data.lookId] = joinDeep }

		return Cryo.Dictionary.join(v7, joinDeepsByLookId)
	end,
	[removeLook.name] = function(p2, p3)
		local clone = table.clone(p2 or v5)
		clone[p3.lookId] = nil
		return clone
	end
})
