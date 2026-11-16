local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceCommon")
local PriceStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Enums/PriceStatus")
local itemRestrictions = AvatarExperienceCommon.Enums.ItemRestrictions
local salesLocationType = AvatarExperienceCommon.Enums.SalesLocationType
local noPriceStatus = AvatarExperienceCommon.Enums.NoPriceStatus

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

local function getIsPurchaseFromResale(data)
	if not (data.collectibleItemDetails and data.collectibleItemDetails.hasResellers) then
		return false
	end

	local v5

	if
		data.priceInRobux
		and data.collectibleItemDetails
		and data.collectibleItemDetails.lowestResalePrice
		and data.catalogPriceStatus ~= "Free"
	then
		v5 = data.collectibleItemDetails.lowestResalePrice < data.priceInRobux
	else
		v5 = data.collectibleItemDetails and data.collectibleItemDetails.lowestResalePrice ~= nil
	end

	local itemRestrictions2 = data.itemRestrictions
	local v6 = itemRestrictions2 and itemRestrictions2[itemRestrictions.Limited]
	local v7 = itemRestrictions2 and itemRestrictions2[itemRestrictions.LimitedUnique]
	local v8 = itemRestrictions2 and itemRestrictions2[itemRestrictions.Collectible]
	local v9 = v6 or v7 or v8
	local v10 = not (v9 and data.collectibleItemDetails and data.collectibleItemDetails.unitsAvailableForConsumption and data.collectibleItemDetails.unitsAvailableForConsumption > 0)
		and v9
		and true
		or false
		or data.isOffSale == true
	return v5 or v10
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

	return v5 and (v10 or not v9)
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

local function getIsPurchasableFromRoblox(data): boolean
	if data.isOffSale or data.noPriceStatus == noPriceStatus.OffSale then
		return false
	end

	return data.saleLocationType ~= salesLocationType.ExperiencesDevApiOnly
end

local function getPriceStatusInShop(data)
	if not data then
		return PriceStatus.Unavailable
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

	if getIsPurchaseFromResale(data) then
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
		v19 = v20 and (v25 or not v24)
	end

	if v19 then
		return PriceStatus.InExperienceOnly
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

	return PriceStatus.Unavailable
end

return getPriceStatusInShop
