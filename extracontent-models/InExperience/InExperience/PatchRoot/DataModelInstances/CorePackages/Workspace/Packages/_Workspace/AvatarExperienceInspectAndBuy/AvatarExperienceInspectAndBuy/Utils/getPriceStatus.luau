local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
local AXCommon = require(parent.AXCommon)
local PriceStatus = require(AvatarExperienceInspectAndBuy.Enums.PriceStatus)
local ItemRestrictions = AXCommon.Enums.ItemRestrictions
local SalesLocationType = AXCommon.Enums.SalesLocationType
local NoPriceStatus = AXCommon.Enums.NoPriceStatus
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXPurchaseFromQuantityFirst = AvatarExperienceFlags.FFlagAXPurchaseFromQuantityFirst

require(AvatarExperienceInspectAndBuy.Types)

local function getAvailableInExperienceOnly(data): boolean -- 3 equivalent calls inferred from this helper
	return data.saleLocationType == SalesLocationType.ExperiencesDevApiOnly
end

local function getHasLimitedAmount(p) -- 9 equivalent calls inferred from this helper
	local itemRestrictions = p.itemRestrictions
	local v = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v2 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v3 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	return v or v2 or v3
end

local function getUserHasReachedQuantityLimit(data): boolean -- 1 equivalent call inferred from this helper
	if not getHasLimitedAmount(data) and data.isOwned then -- inferred equivalent call
		return true
	end

	if not (data.collectibleItemDetails and data.collectibleItemDetails.quantityLimitPerUser) then
		return false
	end

	return data.collectibleItemDetails.quantityLimitPerUser > 0
		and data.collectibleItemDetails.resellableCount >= data.collectibleItemDetails.quantityLimitPerUser
end

local function getOriginalStockAvailable(p) -- 3 equivalent calls inferred from this helper
	local hasLimitedAmount = getHasLimitedAmount(p) -- inferred equivalent call
	return hasLimitedAmount
		and p.collectibleItemDetails
		and p.collectibleItemDetails.unitsAvailableForConsumption
		and p.collectibleItemDetails.unitsAvailableForConsumption > 0
		or not hasLimitedAmount
end

local function gethasReachedQuantityLimitOfLimitedItem(data)
	if not (getHasLimitedAmount(data) and data.collectibleItemDetails) then -- inferred equivalent call
		return false
	end

	local isOwned = data.isOwned == true
	local v

	if data.collectibleItemDetails.quantityLimitPerUser and data.collectibleItemDetails.resellableCount then
		if data.collectibleItemDetails.quantityLimitPerUser > 0 then
			v = data.collectibleItemDetails.resellableCount >= data.collectibleItemDetails.quantityLimitPerUser
		else
			v = false
		end
	else
		v = false
	end

	local hasResellers = data.collectibleItemDetails.hasResellers or false
	local hasLimitedAmount = getHasLimitedAmount(data) -- inferred equivalent call
	local v2 = not (hasLimitedAmount and data.collectibleItemDetails and data.collectibleItemDetails.unitsAvailableForConsumption and data.collectibleItemDetails.unitsAvailableForConsumption > 0)
		and hasLimitedAmount
		and true
		or false
		or v
		or data.isOffSale == true

	return isOwned and v2 and not hasResellers
end

local function getIsFree(data): boolean -- 1 equivalent call inferred from this helper
	if data.isOffSale then
		return false
	end

	local availableInExperienceOnly = getAvailableInExperienceOnly(data) -- inferred equivalent call
	return data.noPriceStatus == NoPriceStatus.Free
		or not availableInExperienceOnly and data.priceInRobux == 0
		or data.catalogPriceStatus == "Free"
end

local function getIsExperienceOnly(data) -- 1 equivalent call inferred from this helper
	if data.isOffSale then
		return false
	end

	local v = data.saleLocationType == SalesLocationType.ExperiencesDevApiOnly
		or data.saleLocationType == SalesLocationType.MyExperiencesOnly
		or data.saleLocationType == SalesLocationType.ExperiencesById
	local originalStockAvailable = getOriginalStockAvailable(data) -- inferred equivalent call
	return v and originalStockAvailable
		or not FFlagAXPurchaseFromQuantityFirst and data.noPriceStatus == NoPriceStatus.InExperience
end

local function getIsPurchaseFromResale(data, flag: boolean?)
	if not (data.collectibleItemDetails and data.collectibleItemDetails.hasResellers) then
		return false
	end

	if FFlagAXPurchaseFromQuantityFirst and flag then
		local hasLimitedAmount = getHasLimitedAmount(data) -- inferred equivalent call
		return not (hasLimitedAmount and data.collectibleItemDetails and data.collectibleItemDetails.unitsAvailableForConsumption and data.collectibleItemDetails.unitsAvailableForConsumption > 0)
			and hasLimitedAmount
			and true
			or false
	else
		local v = data.saleLocationType == SalesLocationType.ExperiencesDevApiOnly
			or data.saleLocationType == SalesLocationType.MyExperiencesOnly
			or data.saleLocationType == SalesLocationType.ExperiencesById

		if flag and v then
			local hasLimitedAmount = getHasLimitedAmount(data) -- inferred equivalent call
			return not (hasLimitedAmount and data.collectibleItemDetails and data.collectibleItemDetails.unitsAvailableForConsumption and data.collectibleItemDetails.unitsAvailableForConsumption > 0)
				and hasLimitedAmount
				and true
				or false
		else
			if
				data.collectibleItemDetails
				and data.collectibleItemDetails.lowestResalePrice ~= nil
				and data.saleLocationType == SalesLocationType.ShopOnly
			then
				return true
			end

			local v2

			if
				data.priceInRobux
				and data.collectibleItemDetails
				and data.collectibleItemDetails.lowestResalePrice
				and data.catalogPriceStatus ~= "Free"
			then
				v2 = data.collectibleItemDetails.lowestResalePrice < data.priceInRobux
			else
				v2 = data.collectibleItemDetails and data.collectibleItemDetails.lowestResalePrice ~= nil
			end

			local hasLimitedAmount = getHasLimitedAmount(data) -- inferred equivalent call
			local v3 = not (hasLimitedAmount and data.collectibleItemDetails and data.collectibleItemDetails.unitsAvailableForConsumption and data.collectibleItemDetails.unitsAvailableForConsumption > 0)
				and hasLimitedAmount
				and true
				or false
				or data.isOffSale == true

			if not flag then
				return v2 or v3
			end

			if v2 or v3 then
				if getOriginalStockAvailable(data) and data.isOffSale == true then -- inferred equivalent call
					return true
				else
					local hasLimitedAmount2 = getHasLimitedAmount(data) -- inferred equivalent call
					return not (hasLimitedAmount2 and data.collectibleItemDetails and data.collectibleItemDetails.unitsAvailableForConsumption and data.collectibleItemDetails.unitsAvailableForConsumption > 0 or not hasLimitedAmount2)
				end
			end

			return v3
		end
	end
end

local function getIsSoldOut(data): boolean -- 1 equivalent call inferred from this helper
	local originalStockAvailable = getOriginalStockAvailable(data) -- inferred equivalent call
	local hasResellers = data.collectibleItemDetails and data.collectibleItemDetails.hasResellers
	return not (originalStockAvailable or hasResellers)
end

local function getIsOwned(data) -- 1 equivalent call inferred from this helper
	local isOwned = data.isOwned
	local userHasReachedQuantityLimit = getUserHasReachedQuantityLimit(data) -- inferred equivalent call
	local hasResellers = data.collectibleItemDetails and data.collectibleItemDetails.hasResellers
	local hasLimitedAmount = getHasLimitedAmount(data) -- inferred equivalent call
	local v = not (hasLimitedAmount and data.collectibleItemDetails and data.collectibleItemDetails.unitsAvailableForConsumption and data.collectibleItemDetails.unitsAvailableForConsumption > 0)
		and hasLimitedAmount
		and true
		or false
		or userHasReachedQuantityLimit
		or data.isOffSale
	return isOwned and v and not hasResellers
end

local function getIsPurchasableFromRoblox(data): boolean
	if data.isOffSale or data.noPriceStatus == NoPriceStatus.OffSale then
		return false
	end

	return not getAvailableInExperienceOnly(data) -- inferred equivalent call
end

local function getIsOffSale(data) -- 2 equivalent calls inferred from this helper
	return data.isOffSale or data.noPriceStatus == NoPriceStatus.OffSale
end

local function getIsShopOnly(data): boolean -- 1 equivalent call inferred from this helper
	return data.saleLocationType == SalesLocationType.ShopOnly
end

local function getPriceStatus(data, flag: boolean?)
	if not data then
		return PriceStatus.Unavailable
	end

	if gethasReachedQuantityLimitOfLimitedItem(data) then
		return PriceStatus.QuantityLimitReached
	end

	if getIsOwned(data) then -- inferred equivalent call
		return PriceStatus.Owned
	end

	if getIsSoldOut(data) then -- inferred equivalent call
		return PriceStatus.SoldOut
	end

	if getIsPurchaseFromResale(data, flag) then
		return PriceStatus.PurchaseFromResale
	end

	if getIsExperienceOnly(data) then -- inferred equivalent call
		return PriceStatus.InExperienceOnly
	end

	if getIsShopOnly(data) then -- inferred equivalent call
		return PriceStatus.Unavailable
	end

	if getIsFree(data) then -- inferred equivalent call
		return PriceStatus.Free
	end

	local v

	if getIsOffSale(data) then -- inferred equivalent call
		v = false
	else
		v = not getAvailableInExperienceOnly(data) -- inferred equivalent call
	end

	if v then
		return PriceStatus.PurchaseFromRoblox
	end

	if getIsOffSale(data) then -- inferred equivalent call
		return PriceStatus.OffSale
	end

	return PriceStatus.Unavailable
end

return getPriceStatus
