local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceCommonParent = AvatarExperienceCommon.Parent
local ItemPurchaseActionTypeEnum = require(AvatarExperienceCommon.Enums.ItemPurchaseActionTypeEnum)
local SalesLocationType = require(AvatarExperienceCommon.Enums.SalesLocationType)
local ItemRestrictions = require(AvatarExperienceCommon.Enums.ItemRestrictions)
local FFlagAXDurablesForMIS = require(AvatarExperienceCommonParent.AvatarExperienceFlags).FFlagAXDurablesForMIS

local function getExperienceCount(t1: {[any]: any}?) -- line: 30
	return #if not t1 then {} else t1.experiences or {}
end
local function getAvailableInExperienceOnly(t2: {[any]: any}) -- line: 35
	-- upvalues: SalesLocationType (copy)
	return t2.saleLocationType == SalesLocationType.ExperiencesDevApiOnly
end
local function getHasLimitedAmount(t3: {[any]: any}) -- line: 39
	-- upvalues: ItemRestrictions (copy)
	local itemRestrictions = t3.itemRestrictions
	local v23 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v24 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v25 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]

	return v23 or (v24 or v25)
end
local function getUserHasReachedQuantityLimit(t4: {[any]: any}, t5: {[any]: any}?, n1: number) -- line: 47
	-- upvalues: ItemRestrictions (copy)
	local itemRestrictions = t4.itemRestrictions
	local v30 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v31 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v32 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]

	if not v30 and (not v31 and not v32) and t4.isOwned then
		return true
	end

	if not t5 or not t5.quantityLimitPerUser then
		return false
	end

	local v33

	if t5 then
		v33 = false

		if t5.quantityLimitPerUser > 0 then
			return n1 >= t5.quantityLimitPerUser
		end
	else
		v33 = false
	end

	return v33
end
local function getOriginalStockAvailable(t6: {[any]: any}) -- line: 65
	-- upvalues: ItemRestrictions (copy)
	local itemRestrictions = t6.itemRestrictions
	local v36 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v37 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v38 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	local v39 = v36 or (v37 or v38)

	return v39 and (t6.numberRobloxHasAvailable and t6.numberRobloxHasAvailable > 0) or not v39
end
local function getButtonTypeIsPurchaseFromResale(t7: {[any]: any}, b1: boolean) -- line: 73
	-- upvalues: SalesLocationType (copy), ItemRestrictions (copy)
	if not b1 or not t7.hasResellers then
		return false
	end

	local v42 = if not t7.priceInRobux or not t7.lowestResalePrice then t7.lowestResalePrice ~= nil else t7.lowestResalePrice < t7.priceInRobux
	local v43 = t7.saleLocationType == SalesLocationType.ExperiencesDevApiOnly
	local itemRestrictions = t7.itemRestrictions
	local v45 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v46 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v47 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	local v48 = v45 or (v46 or v47)
	local v49 = not (v48 and (t7.numberRobloxHasAvailable and t7.numberRobloxHasAvailable > 0) or not v48) or (t7.isOffSale == true or v43)

	return v42 or v49
end
local function getButtonTypeIsFree(t8: {[any]: any}) -- line: 87
	-- upvalues: SalesLocationType (copy)
	if t8.isOffSale then
		return false
	end

	return t8.saleLocationType ~= SalesLocationType.ExperiencesDevApiOnly and t8.priceInRobux == 0
end
local function getButtonTypeIsExperienceLink(t9: {[any]: any}, t10: {[any]: any}?) -- line: 95
	-- upvalues: SalesLocationType (copy), ItemRestrictions (copy)
	if t9.isOffSale then
		return false
	end

	local v53 = t9.saleLocationType == SalesLocationType.ExperiencesDevApiOnly
	local itemRestrictions = t9.itemRestrictions
	local v55 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v56 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v57 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	local v58 = v55 or (v56 or v57)
	local v59 = v58 and (t9.numberRobloxHasAvailable and t9.numberRobloxHasAvailable > 0) or not v58
	local v60 = #(if not t10 then {} else t10.experiences or {}) > 0

	return v53 and (v60 and v59)
end
local function getButtonTypeIsSoldOut(t11: {[any]: any}, b2: boolean) -- line: 105
	-- upvalues: ItemRestrictions (copy)
	local itemRestrictions = t11.itemRestrictions
	local v64 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v65 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v66 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	local v67 = v64 or (v65 or v66)
	local v68 = v67 and (t11.numberRobloxHasAvailable and t11.numberRobloxHasAvailable > 0) or not v67
	local v69 = b2 and t11.hasResellers

	return not v68 and not v69
end
local function getButtonTypeIsCustomizeLink(t12: {[any]: any}, t13: {[any]: any}?, n2: number, b3: boolean) -- line: 111
	-- upvalues: FFlagAXDurablesForMIS (copy), ItemRestrictions (copy)
	local v74 = if not FFlagAXDurablesForMIS then t12.isOwned else t12.isOwned and not t12.expirationTime
	local itemRestrictions = t12.itemRestrictions
	local v76 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v77 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v78 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	local v79 = not (v76 or (v77 or v78)) and not not t12.isOwned or not not t13 and if t13.quantityLimitPerUser then not not t13 and (t13.quantityLimitPerUser > 0 and n2 >= t13.quantityLimitPerUser) else false
	local v80 = b3 and t12.hasResellers
	local itemRestrictions2 = t12.itemRestrictions
	local v82 = itemRestrictions2 and itemRestrictions2[ItemRestrictions.Limited]
	local v83 = itemRestrictions2 and itemRestrictions2[ItemRestrictions.LimitedUnique]
	local v84 = itemRestrictions2 and itemRestrictions2[ItemRestrictions.Collectible]
	local v85 = v82 or (v83 or v84)
	local v86 = not (v85 and (t12.numberRobloxHasAvailable and t12.numberRobloxHasAvailable > 0) or not v85) or (v79 or t12.isOffSale)

	return v74 and (v86 and not v80)
end
local function getButtonTypeIsPurchasableFromRoblox(t14: {[any]: any}) -- line: 127
	-- upvalues: SalesLocationType (copy)
	if t14.isOffSale then
		return false
	end

	return t14.saleLocationType ~= SalesLocationType.ExperiencesDevApiOnly
end
local function getItemPurchaseActionType(t15: {[any]: any}?, t16: {[any]: any}?, n3: number, b4: boolean) -- line: 134
	-- upvalues: ItemPurchaseActionTypeEnum (copy), FFlagAXDurablesForMIS (copy), ItemRestrictions (copy), SalesLocationType (copy)
	if not t15 then
		return ItemPurchaseActionTypeEnum.Disabled
	end

	local v92 = if not FFlagAXDurablesForMIS then t15.isOwned else t15.isOwned and not t15.expirationTime
	local itemRestrictions = t15.itemRestrictions
	local v94 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v95 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v96 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	local v97 = not (v94 or (v95 or v96)) and not not t15.isOwned or not not t16 and if t16.quantityLimitPerUser then not not t16 and (t16.quantityLimitPerUser > 0 and n3 >= t16.quantityLimitPerUser) else false
	local v98 = b4 and t15.hasResellers
	local itemRestrictions3 = t15.itemRestrictions
	local v100 = itemRestrictions3 and itemRestrictions3[ItemRestrictions.Limited]
	local v101 = itemRestrictions3 and itemRestrictions3[ItemRestrictions.LimitedUnique]
	local v102 = itemRestrictions3 and itemRestrictions3[ItemRestrictions.Collectible]
	local v103 = v100 or (v101 or v102)
	local v104 = not (v103 and (t15.numberRobloxHasAvailable and t15.numberRobloxHasAvailable > 0) or not v103) or (v97 or t15.isOffSale)

	if v92 and (v104 and not v98) then
		return ItemPurchaseActionTypeEnum.CustomizeLink
	end

	local itemRestrictions4 = t15.itemRestrictions
	local v106 = itemRestrictions4 and itemRestrictions4[ItemRestrictions.Limited]
	local v107 = itemRestrictions4 and itemRestrictions4[ItemRestrictions.LimitedUnique]
	local v108 = itemRestrictions4 and itemRestrictions4[ItemRestrictions.Collectible]
	local v109 = v106 or (v107 or v108)
	local v110 = v109 and (t15.numberRobloxHasAvailable and t15.numberRobloxHasAvailable > 0) or not v109
	local v111 = b4 and t15.hasResellers

	if not v110 and not v111 then
		return ItemPurchaseActionTypeEnum.SoldOut
	end

	local v112

	if not b4 or not t15.hasResellers then
		v112 = false
	else
		local v113 = if not t15.priceInRobux or not t15.lowestResalePrice then t15.lowestResalePrice ~= nil else t15.lowestResalePrice < t15.priceInRobux
		local v114 = t15.saleLocationType == SalesLocationType.ExperiencesDevApiOnly
		local itemRestrictions5 = t15.itemRestrictions
		local v116 = itemRestrictions5 and itemRestrictions5[ItemRestrictions.Limited]
		local v117 = itemRestrictions5 and itemRestrictions5[ItemRestrictions.LimitedUnique]
		local v118 = itemRestrictions5 and itemRestrictions5[ItemRestrictions.Collectible]
		local v119 = v116 or (v117 or v118)
		local v120 = not (v119 and (t15.numberRobloxHasAvailable and t15.numberRobloxHasAvailable > 0) or not v119) or (t15.isOffSale == true or v114)

		v112 = v113 or v120
	end

	if v112 then
		return ItemPurchaseActionTypeEnum.PurchaseFromResale
	end

	local v121

	if t15.isOffSale then
		v121 = false
	else
		local v122 = t15.saleLocationType == SalesLocationType.ExperiencesDevApiOnly
		local itemRestrictions6 = t15.itemRestrictions
		local v124 = itemRestrictions6 and itemRestrictions6[ItemRestrictions.Limited]
		local v125 = itemRestrictions6 and itemRestrictions6[ItemRestrictions.LimitedUnique]
		local v126 = itemRestrictions6 and itemRestrictions6[ItemRestrictions.Collectible]
		local v127 = v124 or (v125 or v126)
		local v128 = v127 and (t15.numberRobloxHasAvailable and t15.numberRobloxHasAvailable > 0) or not v127
		local v129 = #(if not t16 then {} else t16.experiences or {}) > 0

		v121 = v122 and (v129 and v128)
	end

	if v121 then
		return ItemPurchaseActionTypeEnum.ExperienceLink
	end

	if not t15.isOffSale and (t15.saleLocationType ~= SalesLocationType.ExperiencesDevApiOnly and t15.priceInRobux == 0) then
		return ItemPurchaseActionTypeEnum.Free
	end

	if not t15.isOffSale and t15.saleLocationType ~= SalesLocationType.ExperiencesDevApiOnly then
		return ItemPurchaseActionTypeEnum.PurchaseFromRoblox
	end

	return ItemPurchaseActionTypeEnum.Disabled
end

return getItemPurchaseActionType
