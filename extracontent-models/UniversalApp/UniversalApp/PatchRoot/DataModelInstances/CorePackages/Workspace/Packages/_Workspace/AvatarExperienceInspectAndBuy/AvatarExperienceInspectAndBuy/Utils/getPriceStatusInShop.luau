local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent
local AXCommon = require(AvatarExperienceInspectAndBuyParent.AXCommon)
local PriceStatus = require(AvatarExperienceInspectAndBuy.Enums.PriceStatus)
local ItemRestrictions = AXCommon.Enums.ItemRestrictions
local SalesLocationType = AXCommon.Enums.SalesLocationType
local NoPriceStatus = AXCommon.Enums.NoPriceStatus

require(AvatarExperienceInspectAndBuy.Types)

local function getAvailableInExperienceOnly(p1) -- line: 32
	-- upvalues: SalesLocationType (copy)
	return p1.saleLocationType == SalesLocationType.ExperiencesDevApiOnly
end
local function getHasLimitedAmount(p2) -- line: 36
	-- upvalues: ItemRestrictions (copy)
	local itemRestrictions = p2.itemRestrictions
	local v22 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v23 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v24 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]

	return v22 or (v23 or v24)
end
local function getUserHasReachedQuantityLimit(p3) -- line: 44
	-- upvalues: ItemRestrictions (copy)
	local itemRestrictions = p3.itemRestrictions
	local v27 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v28 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v29 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]

	if not v27 and (not v28 and not v29) and p3.isOwned then
		return true
	end

	if not p3.collectibleItemDetails or not p3.collectibleItemDetails.quantityLimitPerUser then
		return false
	end

	return p3.collectibleItemDetails.quantityLimitPerUser > 0 and p3.collectibleItemDetails.resellableCount >= p3.collectibleItemDetails.quantityLimitPerUser
end
local function getOriginalStockAvailable(p4) -- line: 56
	-- upvalues: ItemRestrictions (copy)
	local itemRestrictions = p4.itemRestrictions
	local v32 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v33 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v34 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	local v35 = v32 or (v33 or v34)

	return v35 and (p4.collectibleItemDetails and (p4.collectibleItemDetails.unitsAvailableForConsumption and p4.collectibleItemDetails.unitsAvailableForConsumption > 0)) or not v35
end
local function getIsOwned(p5) -- line: 65
	-- upvalues: ItemRestrictions (copy)
	local isOwned = p5.isOwned
	local itemRestrictions = p5.itemRestrictions
	local v39 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v40 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v41 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	local v42 = not (v39 or (v40 or v41)) and not not p5.isOwned or not not p5.collectibleItemDetails and if p5.collectibleItemDetails.quantityLimitPerUser then p5.collectibleItemDetails.quantityLimitPerUser > 0 and p5.collectibleItemDetails.resellableCount >= p5.collectibleItemDetails.quantityLimitPerUser else false
	local v43 = p5.collectibleItemDetails and p5.collectibleItemDetails.hasResellers
	local itemRestrictions2 = p5.itemRestrictions
	local v45 = itemRestrictions2 and itemRestrictions2[ItemRestrictions.Limited]
	local v46 = itemRestrictions2 and itemRestrictions2[ItemRestrictions.LimitedUnique]
	local v47 = itemRestrictions2 and itemRestrictions2[ItemRestrictions.Collectible]
	local v48 = v45 or (v46 or v47)
	local v49 = not (v48 and (p5.collectibleItemDetails and (p5.collectibleItemDetails.unitsAvailableForConsumption and p5.collectibleItemDetails.unitsAvailableForConsumption > 0)) or not v48) or (v42 or p5.isOffSale)

	return isOwned and (v49 and not v43)
end
local function getIsSoldOut(p6) -- line: 75
	-- upvalues: ItemRestrictions (copy)
	local itemRestrictions = p6.itemRestrictions
	local v52 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v53 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v54 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	local v55 = v52 or (v53 or v54)
	local v56 = v55 and (p6.collectibleItemDetails and (p6.collectibleItemDetails.unitsAvailableForConsumption and p6.collectibleItemDetails.unitsAvailableForConsumption > 0)) or not v55
	local v57 = p6.collectibleItemDetails and p6.collectibleItemDetails.hasResellers

	return not v56 and not v57
end
local function getIsPurchaseFromResale(p7) -- line: 81
	-- upvalues: ItemRestrictions (copy)
	if not p7.collectibleItemDetails or not p7.collectibleItemDetails.hasResellers then
		return false
	end

	local v59 = if not p7.priceInRobux or (not p7.collectibleItemDetails or (not p7.collectibleItemDetails.lowestResalePrice or p7.catalogPriceStatus == "Free")) then p7.collectibleItemDetails and p7.collectibleItemDetails.lowestResalePrice ~= nil else p7.collectibleItemDetails.lowestResalePrice < p7.priceInRobux
	local itemRestrictions = p7.itemRestrictions
	local v61 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v62 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v63 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	local v64 = v61 or (v62 or v63)
	local v65 = not (v64 and (p7.collectibleItemDetails and (p7.collectibleItemDetails.unitsAvailableForConsumption and p7.collectibleItemDetails.unitsAvailableForConsumption > 0)) or not v64) or p7.isOffSale == true

	return v59 or v65
end
local function getIsExperienceOnly(p8) -- line: 96
	-- upvalues: SalesLocationType (copy), ItemRestrictions (copy)
	if p8.isOffSale then
		return false
	end

	local v67 = p8.saleLocationType == SalesLocationType.ExperiencesDevApiOnly or (p8.saleLocationType == SalesLocationType.MyExperiencesOnly or p8.saleLocationType == SalesLocationType.ExperiencesById)
	local itemRestrictions = p8.itemRestrictions
	local v69 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v70 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v71 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	local v72 = v69 or (v70 or v71)
	local v73 = v72 and (p8.collectibleItemDetails and (p8.collectibleItemDetails.unitsAvailableForConsumption and p8.collectibleItemDetails.unitsAvailableForConsumption > 0)) or not v72

	return v67 and v73
end
local function getIsFree(p9) -- line: 107
	-- upvalues: SalesLocationType (copy), NoPriceStatus (copy)
	if p9.isOffSale then
		return false
	end

	local v75 = p9.saleLocationType == SalesLocationType.ExperiencesDevApiOnly
	local v76 = true

	if p9.noPriceStatus ~= NoPriceStatus.Free then
		v76 = not v75 and p9.priceInRobux == 0 or p9.catalogPriceStatus == "Free"
	end

	return v76
end
local function getIsPurchasableFromRoblox(p10) -- line: 117
	-- upvalues: NoPriceStatus (copy), SalesLocationType (copy)
	if p10.isOffSale or p10.noPriceStatus == NoPriceStatus.OffSale then
		return false
	end

	return p10.saleLocationType ~= SalesLocationType.ExperiencesDevApiOnly
end
local function getPriceStatusInShop(p11) -- line: 124
	-- upvalues: PriceStatus (copy), ItemRestrictions (copy), getIsPurchaseFromResale (copy), SalesLocationType (copy), NoPriceStatus (copy)
	if not p11 then
		return PriceStatus.Unavailable
	end

	local isOwned = p11.isOwned
	local itemRestrictions = p11.itemRestrictions
	local v81 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v82 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v83 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	local v84 = not (v81 or (v82 or v83)) and not not p11.isOwned or not not p11.collectibleItemDetails and if p11.collectibleItemDetails.quantityLimitPerUser then p11.collectibleItemDetails.quantityLimitPerUser > 0 and p11.collectibleItemDetails.resellableCount >= p11.collectibleItemDetails.quantityLimitPerUser else false
	local v85 = p11.collectibleItemDetails and p11.collectibleItemDetails.hasResellers
	local itemRestrictions3 = p11.itemRestrictions
	local v87 = itemRestrictions3 and itemRestrictions3[ItemRestrictions.Limited]
	local v88 = itemRestrictions3 and itemRestrictions3[ItemRestrictions.LimitedUnique]
	local v89 = itemRestrictions3 and itemRestrictions3[ItemRestrictions.Collectible]
	local v90 = v87 or (v88 or v89)
	local v91 = not (v90 and (p11.collectibleItemDetails and (p11.collectibleItemDetails.unitsAvailableForConsumption and p11.collectibleItemDetails.unitsAvailableForConsumption > 0)) or not v90) or (v84 or p11.isOffSale)

	if isOwned and (v91 and not v85) then
		return PriceStatus.Owned
	end

	local itemRestrictions4 = p11.itemRestrictions
	local v93 = itemRestrictions4 and itemRestrictions4[ItemRestrictions.Limited]
	local v94 = itemRestrictions4 and itemRestrictions4[ItemRestrictions.LimitedUnique]
	local v95 = itemRestrictions4 and itemRestrictions4[ItemRestrictions.Collectible]
	local v96 = v93 or (v94 or v95)
	local v97 = v96 and (p11.collectibleItemDetails and (p11.collectibleItemDetails.unitsAvailableForConsumption and p11.collectibleItemDetails.unitsAvailableForConsumption > 0)) or not v96
	local v98 = p11.collectibleItemDetails and p11.collectibleItemDetails.hasResellers

	if not v97 and not v98 then
		return PriceStatus.SoldOut
	end

	if getIsPurchaseFromResale(p11) then
		return PriceStatus.PurchaseFromResale
	end

	local v99

	if p11.isOffSale then
		v99 = false
	else
		local v100 = p11.saleLocationType == SalesLocationType.ExperiencesDevApiOnly or (p11.saleLocationType == SalesLocationType.MyExperiencesOnly or p11.saleLocationType == SalesLocationType.ExperiencesById)
		local itemRestrictions5 = p11.itemRestrictions
		local v102 = itemRestrictions5 and itemRestrictions5[ItemRestrictions.Limited]
		local v103 = itemRestrictions5 and itemRestrictions5[ItemRestrictions.LimitedUnique]
		local v104 = itemRestrictions5 and itemRestrictions5[ItemRestrictions.Collectible]
		local v105 = v102 or (v103 or v104)
		local v106 = v105 and (p11.collectibleItemDetails and (p11.collectibleItemDetails.unitsAvailableForConsumption and p11.collectibleItemDetails.unitsAvailableForConsumption > 0)) or not v105

		v99 = v100 and v106
	end

	if v99 then
		return PriceStatus.InExperienceOnly
	end

	local v107

	if p11.isOffSale then
		v107 = false
	else
		local v108 = p11.saleLocationType == SalesLocationType.ExperiencesDevApiOnly

		v107 = p11.noPriceStatus == NoPriceStatus.Free or (not v108 and p11.priceInRobux == 0 or p11.catalogPriceStatus == "Free")
	end

	if v107 then
		return PriceStatus.Free
	end

	if not p11.isOffSale and (p11.noPriceStatus ~= NoPriceStatus.OffSale and p11.saleLocationType ~= SalesLocationType.ExperiencesDevApiOnly) then
		return PriceStatus.PurchaseFromRoblox
	end

	return PriceStatus.Unavailable
end

return getPriceStatusInShop
