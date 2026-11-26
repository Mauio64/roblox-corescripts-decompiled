local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceCommon")
local PriceStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Enums/PriceStatus")
local itemRestrictions = AvatarExperienceCommon.Enums.ItemRestrictions
local salesLocationType = AvatarExperienceCommon.Enums.SalesLocationType
local noPriceStatus = AvatarExperienceCommon.Enums.NoPriceStatus
local fFlagAXPurchaseFromQuantityFirst = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceFlags").FFlagAXPurchaseFromQuantityFirst

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Types")

local function getAvailableInExperienceOnly(p2): boolean
	return p2.saleLocationType == salesLocationType.ExperiencesDevApiOnly
end

local function getHasLimitedAmount(p2)
	local itemRestrictions2 = p2.itemRestrictions
	local v5 = itemRestrictions2 and itemRestrictions2[itemRestrictions.Limited]
	local v6 = itemRestrictions2 and itemRestrictions2[itemRestrictions.LimitedUnique]
	local v7 = itemRestrictions2 and itemRestrictions2[itemRestrictions.Collectible]
	return v5 or v6 or v7
end

local function getUserHasReachedQuantityLimit(data): boolean
	local itemRestrictions2 = data.itemRestrictions
	local v5 = itemRestrictions2 and itemRestrictions2[itemRestrictions.Limited]
	local v6 = itemRestrictions2 and itemRestrictions2[itemRestrictions.LimitedUnique]
	local v7 = itemRestrictions2 and itemRestrictions2[itemRestrictions.Collectible]

	if not (v5 or v6 or v7) and data.isOwned then
		return true
	end

	if not (data.collectibleItemDetails and data.collectibleItemDetails.quantityLimitPerUser) then
		return false
	end

	return data.collectibleItemDetails.quantityLimitPerUser > 0
		and data.collectibleItemDetails.resellableCount >= data.collectibleItemDetails.quantityLimitPerUser
end

local function getOriginalStockAvailable(p2)
	local itemRestrictions2 = p2.itemRestrictions
	local v5 = itemRestrictions2 and itemRestrictions2[itemRestrictions.Limited]
	local v6 = itemRestrictions2 and itemRestrictions2[itemRestrictions.LimitedUnique]
	local v7 = itemRestrictions2 and itemRestrictions2[itemRestrictions.Collectible]
	local v8 = v5 or v6 or v7
	return v8
		and p2.collectibleItemDetails
		and p2.collectibleItemDetails.unitsAvailableForConsumption
		and p2.collectibleItemDetails.unitsAvailableForConsumption > 0
		or not v8
end

local function gethasReachedQuantityLimitOfLimitedItem(data)
	local itemRestrictions2 = data.itemRestrictions
	local v5 = itemRestrictions2 and itemRestrictions2[itemRestrictions.Limited]
	local v6 = itemRestrictions2 and itemRestrictions2[itemRestrictions.LimitedUnique]
	local v7 = itemRestrictions2 and itemRestrictions2[itemRestrictions.Collectible]

	if not ((v5 or v6 or v7) and data.collectibleItemDetails) then
		return false
	end

	local isOwned = data.isOwned == true
	local v8

	if data.collectibleItemDetails.quantityLimitPerUser and data.collectibleItemDetails.resellableCount then
		if data.collectibleItemDetails.quantityLimitPerUser > 0 then
			v8 = data.collectibleItemDetails.resellableCount >= data.collectibleItemDetails.quantityLimitPerUser
		else
			v8 = false
		end
	else
		v8 = false
	end

	local hasResellers = data.collectibleItemDetails.hasResellers or false
	local itemRestrictions3 = data.itemRestrictions
	local v9 = itemRestrictions3 and itemRestrictions3[itemRestrictions.Limited]
	local v10 = itemRestrictions3 and itemRestrictions3[itemRestrictions.LimitedUnique]
	local v11 = itemRestrictions3 and itemRestrictions3[itemRestrictions.Collectible]
	local v12 = v9 or v10 or v11
	local v13 = not (v12 and data.collectibleItemDetails and data.collectibleItemDetails.unitsAvailableForConsumption and data.collectibleItemDetails.unitsAvailableForConsumption > 0)
		and v12
		and true
		or false
		or v8
		or data.isOffSale == true

	return isOwned and v13 and not hasResellers
end

local function getIsFree(data): boolean
	if data.isOffSale then
		return false
	end

	local v5 = data.saleLocationType == salesLocationType.ExperiencesDevApiOnly

	return data.noPriceStatus == noPriceStatus.Free
		or not v5 and data.priceInRobux == 0
		or data.catalogPriceStatus == "Free"
end

local function getIsExperienceOnly(data)
	if data.isOffSale then
		return false
	end

	local v5 = data.saleLocationType == salesLocationType.ExperiencesDevApiOnly
		or data.saleLocationType == salesLocationType.MyExperiencesOnly
		or data.saleLocationType == salesLocationType.ExperiencesById
	local itemRestrictions2 = data.itemRestrictions
	local v6 = itemRestrictions2 and itemRestrictions2[itemRestrictions.Limited]
	local v7 = itemRestrictions2 and itemRestrictions2[itemRestrictions.LimitedUnique]
	local v8 = itemRestrictions2 and itemRestrictions2[itemRestrictions.Collectible]
	local v9 = v6 or v7 or v8
	local v10 = v9
		and data.collectibleItemDetails
		and data.collectibleItemDetails.unitsAvailableForConsumption
		and data.collectibleItemDetails.unitsAvailableForConsumption > 0
		or not v9

	return v5 and v10
		or not fFlagAXPurchaseFromQuantityFirst and data.noPriceStatus == noPriceStatus.InExperience
end

local function getIsPurchaseFromResale(data, p2)
	if not (data.collectibleItemDetails and data.collectibleItemDetails.hasResellers) then
		return false
	end

	if fFlagAXPurchaseFromQuantityFirst and p2 then
		local itemRestrictions2 = data.itemRestrictions
		local v5 = itemRestrictions2 and itemRestrictions2[itemRestrictions.Limited]
		local v6 = itemRestrictions2 and itemRestrictions2[itemRestrictions.LimitedUnique]
		local v7 = itemRestrictions2 and itemRestrictions2[itemRestrictions.Collectible]
		local v8 = v5 or v6 or v7
		return not (v8 and data.collectibleItemDetails and data.collectibleItemDetails.unitsAvailableForConsumption and data.collectibleItemDetails.unitsAvailableForConsumption > 0)
			and v8
			and true
			or false
	else
		local v5 = data.saleLocationType == salesLocationType.ExperiencesDevApiOnly
			or data.saleLocationType == salesLocationType.MyExperiencesOnly
			or data.saleLocationType == salesLocationType.ExperiencesById

		if p2 and v5 then
			local itemRestrictions2 = data.itemRestrictions
			local v6 = itemRestrictions2 and itemRestrictions2[itemRestrictions.Limited]
			local v7 = itemRestrictions2 and itemRestrictions2[itemRestrictions.LimitedUnique]
			local v8 = itemRestrictions2 and itemRestrictions2[itemRestrictions.Collectible]
			local v9 = v6 or v7 or v8
			return not (v9 and data.collectibleItemDetails and data.collectibleItemDetails.unitsAvailableForConsumption and data.collectibleItemDetails.unitsAvailableForConsumption > 0)
				and v9
				and true
				or false
		else
			if
				data.collectibleItemDetails
				and data.collectibleItemDetails.lowestResalePrice ~= nil
				and data.saleLocationType == salesLocationType.ShopOnly
			then
				return true
			end

			local v6

			if
				data.priceInRobux
				and data.collectibleItemDetails
				and data.collectibleItemDetails.lowestResalePrice
				and data.catalogPriceStatus ~= "Free"
			then
				v6 = data.collectibleItemDetails.lowestResalePrice < data.priceInRobux
			else
				v6 = data.collectibleItemDetails and data.collectibleItemDetails.lowestResalePrice ~= nil
			end

			local itemRestrictions2 = data.itemRestrictions
			local v7 = itemRestrictions2 and itemRestrictions2[itemRestrictions.Limited]
			local v8 = itemRestrictions2 and itemRestrictions2[itemRestrictions.LimitedUnique]
			local v9 = itemRestrictions2 and itemRestrictions2[itemRestrictions.Collectible]
			local v10 = v7 or v8 or v9
			local v11 = not (v10 and data.collectibleItemDetails and data.collectibleItemDetails.unitsAvailableForConsumption and data.collectibleItemDetails.unitsAvailableForConsumption > 0)
				and v10
				and true
				or false
				or data.isOffSale == true

			if not p2 then
				return v6 or v11
			end

			if not (v6 or v11) then
				return v11
			end

			local itemRestrictions3 = data.itemRestrictions
			local v12 = itemRestrictions3 and itemRestrictions3[itemRestrictions.Limited]
			local v13 = itemRestrictions3 and itemRestrictions3[itemRestrictions.LimitedUnique]
			local v14 = itemRestrictions3 and itemRestrictions3[itemRestrictions.Collectible]
			local v15 = v12 or v13 or v14

			if
				(v15 and data.collectibleItemDetails and data.collectibleItemDetails.unitsAvailableForConsumption and data.collectibleItemDetails.unitsAvailableForConsumption > 0 or not v15)
				and data.isOffSale == true
			then
				v11 = true
			else
				local itemRestrictions4 = data.itemRestrictions
				local v16 = itemRestrictions4 and itemRestrictions4[itemRestrictions.Limited]
				local v17 = itemRestrictions4 and itemRestrictions4[itemRestrictions.LimitedUnique]
				local v18 = itemRestrictions4 and itemRestrictions4[itemRestrictions.Collectible]
				local v19 = v16 or v17 or v18
				v11 = not (v19 and data.collectibleItemDetails and data.collectibleItemDetails.unitsAvailableForConsumption and data.collectibleItemDetails.unitsAvailableForConsumption > 0 or not v19)
			end

			return v11
		end
	end
end

local function getIsSoldOut(p2): boolean
	local itemRestrictions2 = p2.itemRestrictions
	local v5 = itemRestrictions2 and itemRestrictions2[itemRestrictions.Limited]
	local v6 = itemRestrictions2 and itemRestrictions2[itemRestrictions.LimitedUnique]
	local v7 = itemRestrictions2 and itemRestrictions2[itemRestrictions.Collectible]
	local v8 = v5 or v6 or v7
	local v9 = v8
		and p2.collectibleItemDetails
		and p2.collectibleItemDetails.unitsAvailableForConsumption
		and p2.collectibleItemDetails.unitsAvailableForConsumption > 0
		or not v8

	local hasResellers = p2.collectibleItemDetails and p2.collectibleItemDetails.hasResellers
	return not (v9 or hasResellers)
end

local function getIsOwned(data)
	local isOwned = data.isOwned
	local itemRestrictions2 = data.itemRestrictions
	local v5 = itemRestrictions2 and itemRestrictions2[itemRestrictions.Limited]
	local v6 = itemRestrictions2 and itemRestrictions2[itemRestrictions.LimitedUnique]
	local v7 = itemRestrictions2 and itemRestrictions2[itemRestrictions.Collectible]
	local v8

	if v5 or v6 or v7 or not data.isOwned then
		if
			data.collectibleItemDetails
			and data.collectibleItemDetails.quantityLimitPerUser
			and data.collectibleItemDetails.quantityLimitPerUser > 0
		then
			v8 = data.collectibleItemDetails.resellableCount >= data.collectibleItemDetails.quantityLimitPerUser
		else
			v8 = false
		end
	else
		v8 = true
	end

	local hasResellers = data.collectibleItemDetails and data.collectibleItemDetails.hasResellers
	local itemRestrictions3 = data.itemRestrictions
	local v9 = itemRestrictions3 and itemRestrictions3[itemRestrictions.Limited]
	local v10 = itemRestrictions3 and itemRestrictions3[itemRestrictions.LimitedUnique]
	local v11 = itemRestrictions3 and itemRestrictions3[itemRestrictions.Collectible]
	local v12 = v9 or v10 or v11
	local v13 = not (v12 and data.collectibleItemDetails and data.collectibleItemDetails.unitsAvailableForConsumption and data.collectibleItemDetails.unitsAvailableForConsumption > 0)
		and v12
		and true
		or false
		or v8
		or data.isOffSale
	return isOwned and v13 and not hasResellers
end

local function getIsPurchasableFromRoblox(data): boolean
	if data.isOffSale or data.noPriceStatus == noPriceStatus.OffSale then
		return false
	end

	return data.saleLocationType ~= salesLocationType.ExperiencesDevApiOnly
end

local function getIsOffSale(p2)
	return p2.isOffSale or p2.noPriceStatus == noPriceStatus.OffSale
end

local function getIsShopOnly(p2): boolean
	return p2.saleLocationType == salesLocationType.ShopOnly
end

local function getPriceStatus(data, p2)
	if not data then
		return PriceStatus.Unavailable
	end

	if gethasReachedQuantityLimitOfLimitedItem(data) then
		return PriceStatus.QuantityLimitReached
	end

	local isOwned = data.isOwned
	local itemRestrictions2 = data.itemRestrictions
	local v5 = itemRestrictions2 and itemRestrictions2[itemRestrictions.Limited]
	local v6 = itemRestrictions2 and itemRestrictions2[itemRestrictions.LimitedUnique]
	local v7 = itemRestrictions2 and itemRestrictions2[itemRestrictions.Collectible]
	local v8

	if v5 or v6 or v7 or not data.isOwned then
		if
			data.collectibleItemDetails
			and data.collectibleItemDetails.quantityLimitPerUser
			and data.collectibleItemDetails.quantityLimitPerUser > 0
		then
			v8 = data.collectibleItemDetails.resellableCount >= data.collectibleItemDetails.quantityLimitPerUser
		else
			v8 = false
		end
	else
		v8 = true
	end

	local hasResellers = data.collectibleItemDetails and data.collectibleItemDetails.hasResellers
	local itemRestrictions3 = data.itemRestrictions
	local v9 = itemRestrictions3 and itemRestrictions3[itemRestrictions.Limited]
	local v10 = itemRestrictions3 and itemRestrictions3[itemRestrictions.LimitedUnique]
	local v11 = itemRestrictions3 and itemRestrictions3[itemRestrictions.Collectible]
	local v12 = v9 or v10 or v11
	local v13 = not (v12 and data.collectibleItemDetails and data.collectibleItemDetails.unitsAvailableForConsumption and data.collectibleItemDetails.unitsAvailableForConsumption > 0)
		and v12
		and true
		or false
		or v8
		or data.isOffSale

	if isOwned and v13 and not hasResellers then
		return PriceStatus.Owned
	end

	local itemRestrictions4 = data.itemRestrictions
	local v14 = itemRestrictions4 and itemRestrictions4[itemRestrictions.Limited]
	local v15 = itemRestrictions4 and itemRestrictions4[itemRestrictions.LimitedUnique]
	local v16 = itemRestrictions4 and itemRestrictions4[itemRestrictions.Collectible]
	local v17 = v14 or v15 or v16
	local v18 = v17
		and data.collectibleItemDetails
		and data.collectibleItemDetails.unitsAvailableForConsumption
		and data.collectibleItemDetails.unitsAvailableForConsumption > 0
		or not v17

	local hasResellers2 = data.collectibleItemDetails and data.collectibleItemDetails.hasResellers

	if not (v18 or hasResellers2) then
		return PriceStatus.SoldOut
	end

	if getIsPurchaseFromResale(data, p2) then
		return PriceStatus.PurchaseFromResale
	end

	local v19

	if data.isOffSale then
		v19 = false
	else
		local v20 = data.saleLocationType == salesLocationType.ExperiencesDevApiOnly
			or data.saleLocationType == salesLocationType.MyExperiencesOnly
			or data.saleLocationType == salesLocationType.ExperiencesById
		local itemRestrictions5 = data.itemRestrictions
		local v21 = itemRestrictions5 and itemRestrictions5[itemRestrictions.Limited]
		local v22 = itemRestrictions5 and itemRestrictions5[itemRestrictions.LimitedUnique]
		local v23 = itemRestrictions5 and itemRestrictions5[itemRestrictions.Collectible]
		local v24 = v21 or v22 or v23
		local v25 = v24
			and data.collectibleItemDetails
			and data.collectibleItemDetails.unitsAvailableForConsumption
			and data.collectibleItemDetails.unitsAvailableForConsumption > 0
			or not v24

		v19 = v20 and v25
			or not fFlagAXPurchaseFromQuantityFirst and data.noPriceStatus == noPriceStatus.InExperience
	end

	if v19 then
		return PriceStatus.InExperienceOnly
	end

	if data.saleLocationType == salesLocationType.ShopOnly then
		return PriceStatus.Unavailable
	end

	local v20

	if data.isOffSale then
		v20 = false
	else
		local v21 = data.saleLocationType == salesLocationType.ExperiencesDevApiOnly

		v20 = data.noPriceStatus == noPriceStatus.Free
			or not v21 and data.priceInRobux == 0
			or data.catalogPriceStatus == "Free"
	end

	if v20 then
		return PriceStatus.Free
	end

	local v21

	if data.isOffSale or data.noPriceStatus == noPriceStatus.OffSale then
		v21 = false
	else
		v21 = data.saleLocationType ~= salesLocationType.ExperiencesDevApiOnly
	end

	if v21 then
		return PriceStatus.PurchaseFromRoblox
	end

	if data.isOffSale or data.noPriceStatus == noPriceStatus.OffSale then
		return PriceStatus.OffSale
	end

	return PriceStatus.Unavailable
end

return getPriceStatus
