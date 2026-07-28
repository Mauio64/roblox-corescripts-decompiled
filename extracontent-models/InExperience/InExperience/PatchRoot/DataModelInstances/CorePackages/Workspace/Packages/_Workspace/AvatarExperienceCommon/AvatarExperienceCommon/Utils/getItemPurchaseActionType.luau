local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceCommonParent = AvatarExperienceCommon.Parent
local ItemPurchaseActionTypeEnum = require(AvatarExperienceCommon.Enums.ItemPurchaseActionTypeEnum)
local SalesLocationType = require(AvatarExperienceCommon.Enums.SalesLocationType)
local ItemRestrictions = require(AvatarExperienceCommon.Enums.ItemRestrictions)
local AvatarExperienceFlags = require(AvatarExperienceCommonParent.AvatarExperienceFlags)
local FFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS
local FFlagAXAddLimitedLabelForCheckout = AvatarExperienceFlags.FFlagAXAddLimitedLabelForCheckout

local function getExperienceCount(t1: {[any]: any}?) -- line: 31
	return #if not t1 then {} else t1.experiences or {}
end
local function getAvailableInExperienceOnly(t2: {[any]: any}) -- line: 36
	-- upvalues: SalesLocationType (copy)
	return t2.saleLocationType == SalesLocationType.ExperiencesDevApiOnly
end
local function getHasLimitedAmount(t3: {[any]: any}) -- line: 40
	-- upvalues: ItemRestrictions (copy)
	local itemRestrictions = t3.itemRestrictions
	local v26 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v27 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v28 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]

	return v26 or (v27 or v28)
end
local function getUserHasReachedQuantityLimit(t4: {[any]: any}, t5: {[any]: any}?, n1: number) -- line: 48
	-- upvalues: ItemRestrictions (copy)
	local itemRestrictions = t4.itemRestrictions
	local v33 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v34 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v35 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]

	if not v33 and (not v34 and not v35) and t4.isOwned then
		return true
	end

	if not t5 or not t5.quantityLimitPerUser then
		return false
	end

	local v36

	if t5 then
		v36 = false

		if t5.quantityLimitPerUser > 0 then
			return n1 >= t5.quantityLimitPerUser
		end
	else
		v36 = false
	end

	return v36
end
local function getOriginalStockAvailable(t6: {[any]: any}) -- line: 66
	-- upvalues: ItemRestrictions (copy)
	local itemRestrictions = t6.itemRestrictions
	local v39 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v40 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v41 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	local v42 = v39 or (v40 or v41)

	return v42 and (t6.numberRobloxHasAvailable and t6.numberRobloxHasAvailable > 0) or not v42
end
local function getButtonTypeIsPurchaseFromResale(t7: {[any]: any}, b1: boolean) -- line: 74
	-- upvalues: SalesLocationType (copy), ItemRestrictions (copy)
	if not b1 or not t7.hasResellers then
		return false
	end

	local v45 = if not t7.priceInRobux or not t7.lowestResalePrice then t7.lowestResalePrice ~= nil else t7.lowestResalePrice < t7.priceInRobux
	local v46 = t7.saleLocationType == SalesLocationType.ExperiencesDevApiOnly
	local itemRestrictions = t7.itemRestrictions
	local v48 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v49 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v50 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	local v51 = v48 or (v49 or v50)
	local v52 = not (v51 and (t7.numberRobloxHasAvailable and t7.numberRobloxHasAvailable > 0) or not v51) or (t7.isOffSale == true or v46)

	return v45 or v52
end
local function getButtonTypeIsFree(t8: {[any]: any}) -- line: 88
	-- upvalues: SalesLocationType (copy)
	if t8.isOffSale then
		return false
	end

	return t8.saleLocationType ~= SalesLocationType.ExperiencesDevApiOnly and t8.priceInRobux == 0
end
local function getButtonTypeIsExperienceLink(t9: {[any]: any}, t10: {[any]: any}?) -- line: 96
	-- upvalues: SalesLocationType (copy), ItemRestrictions (copy)
	if t9.isOffSale then
		return false
	end

	local v56 = t9.saleLocationType == SalesLocationType.ExperiencesDevApiOnly
	local itemRestrictions = t9.itemRestrictions
	local v58 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v59 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v60 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	local v61 = v58 or (v59 or v60)
	local v62 = v61 and (t9.numberRobloxHasAvailable and t9.numberRobloxHasAvailable > 0) or not v61
	local v63 = #(if not t10 then {} else t10.experiences or {}) > 0

	return v56 and (v63 and v62)
end
local function getButtonTypeIsSoldOut(t11: {[any]: any}, b2: boolean) -- line: 106
	-- upvalues: ItemRestrictions (copy)
	local itemRestrictions = t11.itemRestrictions
	local v67 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v68 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v69 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	local v70 = v67 or (v68 or v69)
	local v71 = v70 and (t11.numberRobloxHasAvailable and t11.numberRobloxHasAvailable > 0) or not v70
	local v72 = b2 and t11.hasResellers

	return not v71 and not v72
end
local function getButtonTypeIsCustomizeLink(t12: {[any]: any}, t13: {[any]: any}?, n2: number, b3: boolean) -- line: 112
	-- upvalues: FFlagAXDurablesForMIS (copy), ItemRestrictions (copy)
	local v77 = if not FFlagAXDurablesForMIS then t12.isOwned else t12.isOwned and not t12.expirationTime
	local itemRestrictions = t12.itemRestrictions
	local v79 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v80 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v81 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	local v82 = not (v79 or (v80 or v81)) and not not t12.isOwned or not not t13 and if t13.quantityLimitPerUser then not not t13 and (t13.quantityLimitPerUser > 0 and n2 >= t13.quantityLimitPerUser) else false
	local v83 = b3 and t12.hasResellers
	local itemRestrictions2 = t12.itemRestrictions
	local v85 = itemRestrictions2 and itemRestrictions2[ItemRestrictions.Limited]
	local v86 = itemRestrictions2 and itemRestrictions2[ItemRestrictions.LimitedUnique]
	local v87 = itemRestrictions2 and itemRestrictions2[ItemRestrictions.Collectible]
	local v88 = v85 or (v86 or v87)
	local v89 = not (v88 and (t12.numberRobloxHasAvailable and t12.numberRobloxHasAvailable > 0) or not v88) or (v82 or t12.isOffSale)

	return v77 and (v89 and not v83)
end
local function getButtonTypeIsPurchasableFromRoblox(t14: {[any]: any}) -- line: 128
	-- upvalues: SalesLocationType (copy)
	if t14.isOffSale then
		return false
	end

	return t14.saleLocationType ~= SalesLocationType.ExperiencesDevApiOnly
end
local function getButtonTypeIsQuantityLimitExceeded(_: {[any]: any}, t16: {[any]: any}?, n3: number) -- line: 135
	if t16 == nil or t16.quantityLimitPerUser == nil then
		return false
	end

	return t16.quantityLimitPerUser > 0 and n3 >= t16.quantityLimitPerUser
end
local function getItemPurchaseActionType(t17: {[any]: any}?, t18: {[any]: any}?, n4: number, b4: boolean) -- line: 146
	-- upvalues: ItemPurchaseActionTypeEnum (copy), FFlagAXAddLimitedLabelForCheckout (copy), FFlagAXDurablesForMIS (copy), ItemRestrictions (copy), SalesLocationType (copy)
	if not t17 then
		return ItemPurchaseActionTypeEnum.Disabled
	end

	if FFlagAXAddLimitedLabelForCheckout and (t18 ~= nil and (t18.quantityLimitPerUser ~= nil and (t18.quantityLimitPerUser > 0 and n4 >= t18.quantityLimitPerUser))) then
		return ItemPurchaseActionTypeEnum.QuantityLimitExceeded
	end

	local v98 = if not FFlagAXDurablesForMIS then t17.isOwned else t17.isOwned and not t17.expirationTime
	local itemRestrictions = t17.itemRestrictions
	local v100 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v101 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v102 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	local v103 = not (v100 or (v101 or v102)) and not not t17.isOwned or not not t18 and if t18.quantityLimitPerUser then not not t18 and (t18.quantityLimitPerUser > 0 and n4 >= t18.quantityLimitPerUser) else false
	local v104 = b4 and t17.hasResellers
	local itemRestrictions3 = t17.itemRestrictions
	local v106 = itemRestrictions3 and itemRestrictions3[ItemRestrictions.Limited]
	local v107 = itemRestrictions3 and itemRestrictions3[ItemRestrictions.LimitedUnique]
	local v108 = itemRestrictions3 and itemRestrictions3[ItemRestrictions.Collectible]
	local v109 = v106 or (v107 or v108)
	local v110 = not (v109 and (t17.numberRobloxHasAvailable and t17.numberRobloxHasAvailable > 0) or not v109) or (v103 or t17.isOffSale)

	if v98 and (v110 and not v104) then
		return ItemPurchaseActionTypeEnum.CustomizeLink
	end

	local itemRestrictions4 = t17.itemRestrictions
	local v112 = itemRestrictions4 and itemRestrictions4[ItemRestrictions.Limited]
	local v113 = itemRestrictions4 and itemRestrictions4[ItemRestrictions.LimitedUnique]
	local v114 = itemRestrictions4 and itemRestrictions4[ItemRestrictions.Collectible]
	local v115 = v112 or (v113 or v114)
	local v116 = v115 and (t17.numberRobloxHasAvailable and t17.numberRobloxHasAvailable > 0) or not v115
	local v117 = b4 and t17.hasResellers

	if not v116 and not v117 then
		return ItemPurchaseActionTypeEnum.SoldOut
	end

	local v118

	if not b4 or not t17.hasResellers then
		v118 = false
	else
		local v119 = if not t17.priceInRobux or not t17.lowestResalePrice then t17.lowestResalePrice ~= nil else t17.lowestResalePrice < t17.priceInRobux
		local v120 = t17.saleLocationType == SalesLocationType.ExperiencesDevApiOnly
		local itemRestrictions5 = t17.itemRestrictions
		local v122 = itemRestrictions5 and itemRestrictions5[ItemRestrictions.Limited]
		local v123 = itemRestrictions5 and itemRestrictions5[ItemRestrictions.LimitedUnique]
		local v124 = itemRestrictions5 and itemRestrictions5[ItemRestrictions.Collectible]
		local v125 = v122 or (v123 or v124)
		local v126 = not (v125 and (t17.numberRobloxHasAvailable and t17.numberRobloxHasAvailable > 0) or not v125) or (t17.isOffSale == true or v120)

		v118 = v119 or v126
	end

	if v118 then
		return ItemPurchaseActionTypeEnum.PurchaseFromResale
	end

	local v127

	if t17.isOffSale then
		v127 = false
	else
		local v128 = t17.saleLocationType == SalesLocationType.ExperiencesDevApiOnly
		local itemRestrictions6 = t17.itemRestrictions
		local v130 = itemRestrictions6 and itemRestrictions6[ItemRestrictions.Limited]
		local v131 = itemRestrictions6 and itemRestrictions6[ItemRestrictions.LimitedUnique]
		local v132 = itemRestrictions6 and itemRestrictions6[ItemRestrictions.Collectible]
		local v133 = v130 or (v131 or v132)
		local v134 = v133 and (t17.numberRobloxHasAvailable and t17.numberRobloxHasAvailable > 0) or not v133
		local v135 = #(if not t18 then {} else t18.experiences or {}) > 0

		v127 = v128 and (v135 and v134)
	end

	if v127 then
		return ItemPurchaseActionTypeEnum.ExperienceLink
	end

	if not t17.isOffSale and (t17.saleLocationType ~= SalesLocationType.ExperiencesDevApiOnly and t17.priceInRobux == 0) then
		return ItemPurchaseActionTypeEnum.Free
	end

	if not t17.isOffSale and t17.saleLocationType ~= SalesLocationType.ExperiencesDevApiOnly then
		return ItemPurchaseActionTypeEnum.PurchaseFromRoblox
	end

	return ItemPurchaseActionTypeEnum.Disabled
end

return getItemPurchaseActionType
