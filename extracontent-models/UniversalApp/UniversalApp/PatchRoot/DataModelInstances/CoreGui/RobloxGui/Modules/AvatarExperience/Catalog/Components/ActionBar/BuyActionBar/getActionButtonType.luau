local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local BuyActionButtonTypeEnum = require(script.Parent.BuyActionButtonTypeEnum)
local getExperienceCount = require(script.Parent.getExperienceCount)
local FFlagAXShowFaeUpsell = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXShowFaeUpsell

local function getAvailableInExperienceOnly(t1: {[any]: any}) -- line: 29
	-- upvalues: CatalogConstants (copy)
	return t1.saleLocationType == CatalogConstants.SaleLocationType.ExperiencesDevApiOnly
end
local function getHasLimitedAmount(t2: {[any]: any}) -- line: 33
	-- upvalues: CatalogConstants (copy)
	local itemRestrictions = t2.itemRestrictions
	local v21 = itemRestrictions and itemRestrictions[CatalogConstants.ItemRestrictions.Limited]
	local v22 = itemRestrictions and itemRestrictions[CatalogConstants.ItemRestrictions.LimitedUnique]
	local v23 = itemRestrictions and itemRestrictions[CatalogConstants.ItemRestrictions.Collectible]

	return v21 or (v22 or v23)
end
local function getUserHasReachedQuantityLimit(t3: {[any]: any}, t4: {[any]: any}?, n1: number) -- line: 41
	-- upvalues: CatalogConstants (copy)
	local itemRestrictions = t3.itemRestrictions
	local v28 = itemRestrictions and itemRestrictions[CatalogConstants.ItemRestrictions.Limited]
	local v29 = itemRestrictions and itemRestrictions[CatalogConstants.ItemRestrictions.LimitedUnique]
	local v30 = itemRestrictions and itemRestrictions[CatalogConstants.ItemRestrictions.Collectible]

	if not v28 and (not v29 and not v30) and t3.isOwned then
		return true
	end

	if not t4 or not t4.quantityLimitPerUser then
		return false
	end

	return t4.quantityLimitPerUser > 0 and n1 >= t4.quantityLimitPerUser
end
local function getOriginalStockAvailable(t5: {[any]: any}) -- line: 56
	-- upvalues: CatalogConstants (copy)
	local itemRestrictions = t5.itemRestrictions
	local v33 = itemRestrictions and itemRestrictions[CatalogConstants.ItemRestrictions.Limited]
	local v34 = itemRestrictions and itemRestrictions[CatalogConstants.ItemRestrictions.LimitedUnique]
	local v35 = itemRestrictions and itemRestrictions[CatalogConstants.ItemRestrictions.Collectible]
	local v36 = v33 or (v34 or v35)

	return v36 and (t5.numberRobloxHasAvailable and t5.numberRobloxHasAvailable > 0) or not v36
end
local function getButtonTypeIsPurchaseFromResale(t6: {[any]: any}, b1: boolean) -- line: 64
	-- upvalues: CatalogConstants (copy)
	if not b1 or not t6.hasResellers then
		return false
	end

	local v39 = if not t6.priceInRobux or not t6.lowestResalePrice then t6.lowestResalePrice ~= nil else t6.lowestResalePrice < t6.priceInRobux
	local itemRestrictions = t6.itemRestrictions
	local v41 = itemRestrictions and itemRestrictions[CatalogConstants.ItemRestrictions.Limited]
	local v42 = itemRestrictions and itemRestrictions[CatalogConstants.ItemRestrictions.LimitedUnique]
	local v43 = itemRestrictions and itemRestrictions[CatalogConstants.ItemRestrictions.Collectible]
	local v44 = v41 or (v42 or v43)
	local v45 = not (v44 and (t6.numberRobloxHasAvailable and t6.numberRobloxHasAvailable > 0) or not v44) or t6.isOffSale == true

	return v39 or v45
end
local function getButtonTypeIsFree(t7: {[any]: any}) -- line: 75
	-- upvalues: CatalogConstants (copy)
	if t7.isOffSale then
		return false
	end

	return t7.saleLocationType ~= CatalogConstants.SaleLocationType.ExperiencesDevApiOnly and t7.priceInRobux == 0
end
local function getButtonTypeIsExperienceLink(t8: {[any]: any}, t9: {[any]: any}?) -- line: 83
	-- upvalues: CatalogConstants (copy), getExperienceCount (copy)
	if t8.isOffSale then
		return false
	end

	local v49 = t8.saleLocationType == CatalogConstants.SaleLocationType.ExperiencesDevApiOnly
	local itemRestrictions = t8.itemRestrictions
	local v51 = itemRestrictions and itemRestrictions[CatalogConstants.ItemRestrictions.Limited]
	local v52 = itemRestrictions and itemRestrictions[CatalogConstants.ItemRestrictions.LimitedUnique]
	local v53 = itemRestrictions and itemRestrictions[CatalogConstants.ItemRestrictions.Collectible]
	local v54 = v51 or (v52 or v53)
	local v55 = v54 and (t8.numberRobloxHasAvailable and t8.numberRobloxHasAvailable > 0) or not v54
	local v56 = getExperienceCount(t9) > 0

	return v49 and (v56 and v55)
end
local function getButtonTypeIsSoldOut(t10: {[any]: any}, b2: boolean) -- line: 94
	-- upvalues: CatalogConstants (copy)
	local itemRestrictions = t10.itemRestrictions
	local v60 = itemRestrictions and itemRestrictions[CatalogConstants.ItemRestrictions.Limited]
	local v61 = itemRestrictions and itemRestrictions[CatalogConstants.ItemRestrictions.LimitedUnique]
	local v62 = itemRestrictions and itemRestrictions[CatalogConstants.ItemRestrictions.Collectible]
	local v63 = v60 or (v61 or v62)
	local v64 = v63 and (t10.numberRobloxHasAvailable and t10.numberRobloxHasAvailable > 0) or not v63
	local v65 = b2 and t10.hasResellers

	return not v64 and not v65
end
local function getButtonTypeIsCustomizeLink(t11: {[any]: any}, t12: {[any]: any}?, n2: number, b3: boolean) -- line: 100
	-- upvalues: CatalogConstants (copy)
	local isOwned = t11.isOwned
	local v71 = t11.timedOptions and t11.isPurchasable
	local itemRestrictions = t11.itemRestrictions
	local v73 = itemRestrictions and itemRestrictions[CatalogConstants.ItemRestrictions.Limited]
	local v74 = itemRestrictions and itemRestrictions[CatalogConstants.ItemRestrictions.LimitedUnique]
	local v75 = itemRestrictions and itemRestrictions[CatalogConstants.ItemRestrictions.Collectible]
	local v76 = not (v73 or (v74 or v75)) and not not t11.isOwned or not not t12 and if t12.quantityLimitPerUser then t12.quantityLimitPerUser > 0 and n2 >= t12.quantityLimitPerUser else false
	local v77 = b3 and t11.hasResellers
	local itemRestrictions2 = t11.itemRestrictions
	local v79 = itemRestrictions2 and itemRestrictions2[CatalogConstants.ItemRestrictions.Limited]
	local v80 = itemRestrictions2 and itemRestrictions2[CatalogConstants.ItemRestrictions.LimitedUnique]
	local v81 = itemRestrictions2 and itemRestrictions2[CatalogConstants.ItemRestrictions.Collectible]
	local v82 = v79 or (v80 or v81)
	local v83 = not (v82 and (t11.numberRobloxHasAvailable and t11.numberRobloxHasAvailable > 0) or not v82) or (v76 or t11.isOffSale)

	return isOwned and (v83 and (not v77 and not v71))
end
local function getButtonTypeIsPurchasableFromRoblox(t13: {[any]: any}) -- line: 117
	-- upvalues: CatalogConstants (copy)
	if t13.isOffSale then
		return false
	end

	return t13.saleLocationType ~= CatalogConstants.SaleLocationType.ExperiencesDevApiOnly
end
local function getActionButtonType(t14: {[any]: any}?, t15: {[any]: any}?, n3: number, b4: boolean, b5: boolean, t16: {[any]: any}?) -- line: 124
	-- upvalues: BuyActionButtonTypeEnum (copy), CatalogConstants (copy), FFlagAXShowFaeUpsell (copy), getExperienceCount (copy)
	if b4 then
		return BuyActionButtonTypeEnum.Loading
	end

	if not t14 then
		return BuyActionButtonTypeEnum.Disabled
	end

	local isOwned = t14.isOwned
	local v92 = t14.timedOptions and t14.isPurchasable
	local itemRestrictions = t14.itemRestrictions
	local v94 = itemRestrictions and itemRestrictions[CatalogConstants.ItemRestrictions.Limited]
	local v95 = itemRestrictions and itemRestrictions[CatalogConstants.ItemRestrictions.LimitedUnique]
	local v96 = itemRestrictions and itemRestrictions[CatalogConstants.ItemRestrictions.Collectible]
	local v97 = not (v94 or (v95 or v96)) and not not t14.isOwned or not not t15 and if t15.quantityLimitPerUser then t15.quantityLimitPerUser > 0 and n3 >= t15.quantityLimitPerUser else false
	local v98 = b5 and t14.hasResellers
	local itemRestrictions3 = t14.itemRestrictions
	local v100 = itemRestrictions3 and itemRestrictions3[CatalogConstants.ItemRestrictions.Limited]
	local v101 = itemRestrictions3 and itemRestrictions3[CatalogConstants.ItemRestrictions.LimitedUnique]
	local v102 = itemRestrictions3 and itemRestrictions3[CatalogConstants.ItemRestrictions.Collectible]
	local v103 = v100 or (v101 or v102)
	local v104 = not (v103 and (t14.numberRobloxHasAvailable and t14.numberRobloxHasAvailable > 0) or not v103) or (v97 or t14.isOffSale)

	if isOwned and (v104 and (not v98 and not v92)) then
		return BuyActionButtonTypeEnum.CustomizeLink
	end

	if FFlagAXShowFaeUpsell and t16 and (t16.showFaeUpsell or t16.canClaimFaeItem) then
		return BuyActionButtonTypeEnum.UnlockableItem
	end

	local itemRestrictions4 = t14.itemRestrictions
	local v106 = itemRestrictions4 and itemRestrictions4[CatalogConstants.ItemRestrictions.Limited]
	local v107 = itemRestrictions4 and itemRestrictions4[CatalogConstants.ItemRestrictions.LimitedUnique]
	local v108 = itemRestrictions4 and itemRestrictions4[CatalogConstants.ItemRestrictions.Collectible]
	local v109 = v106 or (v107 or v108)
	local v110 = v109 and (t14.numberRobloxHasAvailable and t14.numberRobloxHasAvailable > 0) or not v109
	local v111 = b5 and t14.hasResellers

	if not v110 and not v111 then
		return BuyActionButtonTypeEnum.SoldOut
	end

	local v112

	if not b5 or not t14.hasResellers then
		v112 = false
	else
		local v113 = if not t14.priceInRobux or not t14.lowestResalePrice then t14.lowestResalePrice ~= nil else t14.lowestResalePrice < t14.priceInRobux
		local itemRestrictions5 = t14.itemRestrictions
		local v115 = itemRestrictions5 and itemRestrictions5[CatalogConstants.ItemRestrictions.Limited]
		local v116 = itemRestrictions5 and itemRestrictions5[CatalogConstants.ItemRestrictions.LimitedUnique]
		local v117 = itemRestrictions5 and itemRestrictions5[CatalogConstants.ItemRestrictions.Collectible]
		local v118 = v115 or (v116 or v117)
		local v119 = not (v118 and (t14.numberRobloxHasAvailable and t14.numberRobloxHasAvailable > 0) or not v118) or t14.isOffSale == true

		v112 = v113 or v119
	end

	if v112 then
		return BuyActionButtonTypeEnum.PurchaseFromResale
	end

	local v120

	if t14.isOffSale then
		v120 = false
	else
		local v121 = t14.saleLocationType == CatalogConstants.SaleLocationType.ExperiencesDevApiOnly
		local itemRestrictions6 = t14.itemRestrictions
		local v123 = itemRestrictions6 and itemRestrictions6[CatalogConstants.ItemRestrictions.Limited]
		local v124 = itemRestrictions6 and itemRestrictions6[CatalogConstants.ItemRestrictions.LimitedUnique]
		local v125 = itemRestrictions6 and itemRestrictions6[CatalogConstants.ItemRestrictions.Collectible]
		local v126 = v123 or (v124 or v125)
		local v127 = v126 and (t14.numberRobloxHasAvailable and t14.numberRobloxHasAvailable > 0) or not v126
		local v128 = getExperienceCount(t15) > 0

		v120 = v121 and (v128 and v127)
	end

	if v120 then
		return BuyActionButtonTypeEnum.ExperienceLink
	end

	if not t14.isOffSale and (t14.saleLocationType ~= CatalogConstants.SaleLocationType.ExperiencesDevApiOnly and t14.priceInRobux == 0) then
		return BuyActionButtonTypeEnum.Free
	end

	if not t14.isOffSale and t14.saleLocationType ~= CatalogConstants.SaleLocationType.ExperiencesDevApiOnly then
		return BuyActionButtonTypeEnum.PurchaseFromRoblox
	end

	return BuyActionButtonTypeEnum.Disabled
end

return getActionButtonType
