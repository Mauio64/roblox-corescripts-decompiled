local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent
local AXCommon = require(AvatarExperienceInspectAndBuyParent.AXCommon)
local PriceStatus = require(AvatarExperienceInspectAndBuy.Enums.PriceStatus)
local ItemRestrictions = AXCommon.Enums.ItemRestrictions
local SalesLocationType = AXCommon.Enums.SalesLocationType
local NoPriceStatus = AXCommon.Enums.NoPriceStatus
local FFlagAXPurchaseFromQuantityFirst = require(AvatarExperienceInspectAndBuyParent.AvatarExperienceFlags).FFlagAXPurchaseFromQuantityFirst
local FFlagAXLimitedsOffsaleFixIaB = require(AvatarExperienceInspectAndBuyParent.AvatarExperienceFlags).FFlagAXLimitedsOffsaleFixIaB

require(AvatarExperienceInspectAndBuy.Types)

local function getAvailableInExperienceOnly(p1) -- line: 22
	-- upvalues: SalesLocationType (copy)
	return p1.saleLocationType == SalesLocationType.ExperiencesDevApiOnly
end
local function getHasLimitedAmount(p2) -- line: 29
	-- upvalues: ItemRestrictions (copy)
	local itemRestrictions = p2.itemRestrictions
	local v27 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v28 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v29 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]

	return v27 or (v28 or v29)
end
local function getUserHasReachedQuantityLimit(p3) -- line: 41
	-- upvalues: ItemRestrictions (copy)
	local itemRestrictions = p3.itemRestrictions
	local v32 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v33 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v34 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]

	if not v32 and (not v33 and not v34) and p3.isOwned then
		return true
	end

	if not p3.collectibleItemDetails or not p3.collectibleItemDetails.quantityLimitPerUser then
		return false
	end

	return p3.collectibleItemDetails.quantityLimitPerUser > 0 and p3.collectibleItemDetails.resellableCount >= p3.collectibleItemDetails.quantityLimitPerUser
end
local function getOriginalStockAvailable(p4) -- line: 57
	-- upvalues: ItemRestrictions (copy)
	local itemRestrictions = p4.itemRestrictions
	local v37 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v38 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v39 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	local v40 = v37 or (v38 or v39)

	return v40 and (p4.collectibleItemDetails and (p4.collectibleItemDetails.unitsAvailableForConsumption and p4.collectibleItemDetails.unitsAvailableForConsumption > 0)) or not v40
end
local function gethasReachedQuantityLimitOfLimitedItem(p5) -- line: 73
	-- upvalues: ItemRestrictions (copy)
	local itemRestrictions = p5.itemRestrictions
	local v43 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v44 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v45 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]

	if not v43 and (not v44 and not v45) then
		return false
	end

	if not p5.collectibleItemDetails then
		return false
	end

	local v46 = p5.isOwned == true
	local v47 = false

	if p5.collectibleItemDetails.quantityLimitPerUser and p5.collectibleItemDetails.resellableCount then
		v47 = p5.collectibleItemDetails.quantityLimitPerUser > 0 and p5.collectibleItemDetails.resellableCount >= p5.collectibleItemDetails.quantityLimitPerUser
	end

	local v48 = p5.collectibleItemDetails.hasResellers or false
	local itemRestrictions2 = p5.itemRestrictions
	local v50 = itemRestrictions2 and itemRestrictions2[ItemRestrictions.Limited]
	local v51 = itemRestrictions2 and itemRestrictions2[ItemRestrictions.LimitedUnique]
	local v52 = itemRestrictions2 and itemRestrictions2[ItemRestrictions.Collectible]
	local v53 = v50 or (v51 or v52)
	local v54 = not (v53 and (p5.collectibleItemDetails and (p5.collectibleItemDetails.unitsAvailableForConsumption and p5.collectibleItemDetails.unitsAvailableForConsumption > 0)) or not v53) or (v47 or p5.isOffSale == true)

	return v46 and (v54 and not v48)
end
local function getIsFree(p6) -- line: 104
	-- upvalues: SalesLocationType (copy), NoPriceStatus (copy)
	if p6.isOffSale then
		return false
	end

	local v56 = p6.saleLocationType == SalesLocationType.ExperiencesDevApiOnly
	local v57 = true

	if p6.noPriceStatus ~= NoPriceStatus.Free then
		v57 = not v56 and p6.priceInRobux == 0 or p6.catalogPriceStatus == "Free"
	end

	return v57
end
local function getIsExperienceOnly(p7) -- line: 117
	-- upvalues: SalesLocationType (copy), ItemRestrictions (copy), FFlagAXPurchaseFromQuantityFirst (copy), NoPriceStatus (copy)
	if p7.isOffSale then
		return false
	end

	local v59 = p7.saleLocationType == SalesLocationType.ExperiencesDevApiOnly or (p7.saleLocationType == SalesLocationType.MyExperiencesOnly or p7.saleLocationType == SalesLocationType.ExperiencesById)
	local itemRestrictions = p7.itemRestrictions
	local v61 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v62 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v63 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	local v64 = v61 or (v62 or v63)
	local v65 = v64 and (p7.collectibleItemDetails and (p7.collectibleItemDetails.unitsAvailableForConsumption and p7.collectibleItemDetails.unitsAvailableForConsumption > 0)) or not v64

	return v59 and v65 or not FFlagAXPurchaseFromQuantityFirst and p7.noPriceStatus == NoPriceStatus.InExperience
end
local function getIsPurchaseFromResale(p8, b1: boolean?) -- line: 145
	-- upvalues: FFlagAXPurchaseFromQuantityFirst (copy), ItemRestrictions (copy), SalesLocationType (copy), FFlagAXLimitedsOffsaleFixIaB (copy)
	if not p8.collectibleItemDetails or not p8.collectibleItemDetails.hasResellers then
		return false
	end

	if FFlagAXPurchaseFromQuantityFirst and b1 then
		local itemRestrictions = p8.itemRestrictions
		local v69 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
		local v70 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
		local v71 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
		local v72 = v69 or (v70 or v71)

		return not (v72 and (p8.collectibleItemDetails and (p8.collectibleItemDetails.unitsAvailableForConsumption and p8.collectibleItemDetails.unitsAvailableForConsumption > 0)) or not v72)
	end

	local v73 = p8.saleLocationType == SalesLocationType.ExperiencesDevApiOnly or (p8.saleLocationType == SalesLocationType.MyExperiencesOnly or p8.saleLocationType == SalesLocationType.ExperiencesById)

	if b1 and v73 then
		local itemRestrictions = p8.itemRestrictions
		local v75 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
		local v76 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
		local v77 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
		local v78 = v75 or (v76 or v77)

		return not (v78 and (p8.collectibleItemDetails and (p8.collectibleItemDetails.unitsAvailableForConsumption and p8.collectibleItemDetails.unitsAvailableForConsumption > 0)) or not v78)
	end

	if p8.collectibleItemDetails and p8.collectibleItemDetails.lowestResalePrice ~= nil and p8.saleLocationType == SalesLocationType.ShopOnly then
		return true
	end

	local v79 = if not p8.priceInRobux or (not p8.collectibleItemDetails or (not p8.collectibleItemDetails.lowestResalePrice or p8.catalogPriceStatus == "Free")) then p8.collectibleItemDetails and p8.collectibleItemDetails.lowestResalePrice ~= nil else p8.collectibleItemDetails.lowestResalePrice < p8.priceInRobux
	local itemRestrictions = p8.itemRestrictions
	local v81 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v82 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v83 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	local v84 = v81 or (v82 or v83)
	local v85 = not (v84 and (p8.collectibleItemDetails and (p8.collectibleItemDetails.unitsAvailableForConsumption and p8.collectibleItemDetails.unitsAvailableForConsumption > 0)) or not v84) or p8.isOffSale == true

	if not FFlagAXLimitedsOffsaleFixIaB or not b1 then
		return v79 or v85
	end

	if not v79 then
		if not v85 then
			return v85
		end
	end

	local itemRestrictions3 = p8.itemRestrictions
	local v87 = itemRestrictions3 and itemRestrictions3[ItemRestrictions.Limited]
	local v88 = itemRestrictions3 and itemRestrictions3[ItemRestrictions.LimitedUnique]
	local v89 = itemRestrictions3 and itemRestrictions3[ItemRestrictions.Collectible]
	local v90 = v87 or (v88 or v89)

	if v90 and (p8.collectibleItemDetails and (p8.collectibleItemDetails.unitsAvailableForConsumption and p8.collectibleItemDetails.unitsAvailableForConsumption > 0)) or not v90 then
		v85 = true

		if p8.isOffSale == true then
			return v85
		end
	end

	local itemRestrictions4 = p8.itemRestrictions
	local v92 = itemRestrictions4 and itemRestrictions4[ItemRestrictions.Limited]
	local v93 = itemRestrictions4 and itemRestrictions4[ItemRestrictions.LimitedUnique]
	local v94 = itemRestrictions4 and itemRestrictions4[ItemRestrictions.Collectible]
	local v95 = v92 or (v93 or v94)

	v85 = not (v95 and (p8.collectibleItemDetails and (p8.collectibleItemDetails.unitsAvailableForConsumption and p8.collectibleItemDetails.unitsAvailableForConsumption > 0)) or not v95)

	return v85
end
local function getIsSoldOut(p9) -- line: 205
	-- upvalues: ItemRestrictions (copy)
	local itemRestrictions = p9.itemRestrictions
	local v98 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v99 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v100 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	local v101 = v98 or (v99 or v100)
	local v102 = v101 and (p9.collectibleItemDetails and (p9.collectibleItemDetails.unitsAvailableForConsumption and p9.collectibleItemDetails.unitsAvailableForConsumption > 0)) or not v101
	local v103 = p9.collectibleItemDetails and p9.collectibleItemDetails.hasResellers

	return not v102 and not v103
end
local function getIsOwned(p10) -- line: 215
	-- upvalues: ItemRestrictions (copy)
	local isOwned = p10.isOwned
	local itemRestrictions = p10.itemRestrictions
	local v107 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v108 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v109 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	local v110 = not (v107 or (v108 or v109)) and not not p10.isOwned or not not p10.collectibleItemDetails and if p10.collectibleItemDetails.quantityLimitPerUser then p10.collectibleItemDetails.quantityLimitPerUser > 0 and p10.collectibleItemDetails.resellableCount >= p10.collectibleItemDetails.quantityLimitPerUser else false
	local v111 = p10.collectibleItemDetails and p10.collectibleItemDetails.hasResellers
	local itemRestrictions5 = p10.itemRestrictions
	local v113 = itemRestrictions5 and itemRestrictions5[ItemRestrictions.Limited]
	local v114 = itemRestrictions5 and itemRestrictions5[ItemRestrictions.LimitedUnique]
	local v115 = itemRestrictions5 and itemRestrictions5[ItemRestrictions.Collectible]
	local v116 = v113 or (v114 or v115)
	local v117 = not (v116 and (p10.collectibleItemDetails and (p10.collectibleItemDetails.unitsAvailableForConsumption and p10.collectibleItemDetails.unitsAvailableForConsumption > 0)) or not v116) or (v110 or p10.isOffSale)

	return isOwned and (v117 and not v111)
end
local function getIsPurchasableFromRoblox(p11) -- line: 229
	-- upvalues: NoPriceStatus (copy), SalesLocationType (copy)
	if p11.isOffSale or p11.noPriceStatus == NoPriceStatus.OffSale then
		return false
	end

	return p11.saleLocationType ~= SalesLocationType.ExperiencesDevApiOnly
end
local function getIsOffSale(p12) -- line: 239
	-- upvalues: NoPriceStatus (copy)
	return p12.isOffSale or p12.noPriceStatus == NoPriceStatus.OffSale
end
local function getIsShopOnly(p13) -- line: 247
	-- upvalues: SalesLocationType (copy)
	return p13.saleLocationType == SalesLocationType.ShopOnly
end
local function getPriceStatus(p14, b2: boolean?) -- line: 255
	-- upvalues: PriceStatus (copy), gethasReachedQuantityLimitOfLimitedItem (copy), ItemRestrictions (copy), getIsPurchaseFromResale (copy), SalesLocationType (copy), FFlagAXPurchaseFromQuantityFirst (copy), NoPriceStatus (copy)
	if not p14 then
		return PriceStatus.Unavailable
	end

	if gethasReachedQuantityLimitOfLimitedItem(p14) then
		return PriceStatus.QuantityLimitReached
	end

	local isOwned = p14.isOwned
	local itemRestrictions = p14.itemRestrictions
	local v125 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v126 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v127 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	local v128 = not (v125 or (v126 or v127)) and not not p14.isOwned or not not p14.collectibleItemDetails and if p14.collectibleItemDetails.quantityLimitPerUser then p14.collectibleItemDetails.quantityLimitPerUser > 0 and p14.collectibleItemDetails.resellableCount >= p14.collectibleItemDetails.quantityLimitPerUser else false
	local v129 = p14.collectibleItemDetails and p14.collectibleItemDetails.hasResellers
	local itemRestrictions6 = p14.itemRestrictions
	local v131 = itemRestrictions6 and itemRestrictions6[ItemRestrictions.Limited]
	local v132 = itemRestrictions6 and itemRestrictions6[ItemRestrictions.LimitedUnique]
	local v133 = itemRestrictions6 and itemRestrictions6[ItemRestrictions.Collectible]
	local v134 = v131 or (v132 or v133)
	local v135 = not (v134 and (p14.collectibleItemDetails and (p14.collectibleItemDetails.unitsAvailableForConsumption and p14.collectibleItemDetails.unitsAvailableForConsumption > 0)) or not v134) or (v128 or p14.isOffSale)

	if isOwned and (v135 and not v129) then
		return PriceStatus.Owned
	end

	local itemRestrictions7 = p14.itemRestrictions
	local v137 = itemRestrictions7 and itemRestrictions7[ItemRestrictions.Limited]
	local v138 = itemRestrictions7 and itemRestrictions7[ItemRestrictions.LimitedUnique]
	local v139 = itemRestrictions7 and itemRestrictions7[ItemRestrictions.Collectible]
	local v140 = v137 or (v138 or v139)
	local v141 = v140 and (p14.collectibleItemDetails and (p14.collectibleItemDetails.unitsAvailableForConsumption and p14.collectibleItemDetails.unitsAvailableForConsumption > 0)) or not v140
	local v142 = p14.collectibleItemDetails and p14.collectibleItemDetails.hasResellers

	if not v141 and not v142 then
		return PriceStatus.SoldOut
	end

	if getIsPurchaseFromResale(p14, b2) then
		return PriceStatus.PurchaseFromResale
	end

	local v143

	if p14.isOffSale then
		v143 = false
	else
		local v144 = p14.saleLocationType == SalesLocationType.ExperiencesDevApiOnly or (p14.saleLocationType == SalesLocationType.MyExperiencesOnly or p14.saleLocationType == SalesLocationType.ExperiencesById)
		local itemRestrictions8 = p14.itemRestrictions
		local v146 = itemRestrictions8 and itemRestrictions8[ItemRestrictions.Limited]
		local v147 = itemRestrictions8 and itemRestrictions8[ItemRestrictions.LimitedUnique]
		local v148 = itemRestrictions8 and itemRestrictions8[ItemRestrictions.Collectible]
		local v149 = v146 or (v147 or v148)
		local v150 = v149 and (p14.collectibleItemDetails and (p14.collectibleItemDetails.unitsAvailableForConsumption and p14.collectibleItemDetails.unitsAvailableForConsumption > 0)) or not v149

		v143 = v144 and v150 or not FFlagAXPurchaseFromQuantityFirst and p14.noPriceStatus == NoPriceStatus.InExperience
	end

	if v143 then
		return PriceStatus.InExperienceOnly
	end

	if p14.saleLocationType == SalesLocationType.ShopOnly then
		return PriceStatus.Unavailable
	end

	local v151

	if p14.isOffSale then
		v151 = false
	else
		local v152 = p14.saleLocationType == SalesLocationType.ExperiencesDevApiOnly

		v151 = p14.noPriceStatus == NoPriceStatus.Free or (not v152 and p14.priceInRobux == 0 or p14.catalogPriceStatus == "Free")
	end

	if v151 then
		return PriceStatus.Free
	end

	if not p14.isOffSale and (p14.noPriceStatus ~= NoPriceStatus.OffSale and p14.saleLocationType ~= SalesLocationType.ExperiencesDevApiOnly) then
		return PriceStatus.PurchaseFromRoblox
	end

	if p14.isOffSale or p14.noPriceStatus == NoPriceStatus.OffSale then
		return PriceStatus.OffSale
	end

	return PriceStatus.Unavailable
end

return getPriceStatus
