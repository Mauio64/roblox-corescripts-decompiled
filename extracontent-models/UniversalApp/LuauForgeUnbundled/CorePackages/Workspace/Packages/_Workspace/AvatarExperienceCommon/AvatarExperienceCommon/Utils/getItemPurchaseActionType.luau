local ItemPurchaseActionTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Enums/ItemPurchaseActionTypeEnum")
local SalesLocationType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Enums/SalesLocationType")
local ItemRestrictions = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Enums/ItemRestrictions")

local fFlagAXDurablesForMIS = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags").FFlagAXDurablesForMIS

local function getExperienceCount(p2)
	return #(p2 and p2.experiences or {})
end

local function getAvailableInExperienceOnly(p2): boolean
	return p2.saleLocationType == SalesLocationType.ExperiencesDevApiOnly
end

local function getHasLimitedAmount(p2)
	local itemRestrictions = p2.itemRestrictions
	local v5 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v6 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v7 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	return v5 or v6 or v7
end

local function getUserHasReachedQuantityLimit(p2, p3, p4): boolean
	local itemRestrictions = p2.itemRestrictions
	local v5 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v6 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v7 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]

	if not (v5 or v6 or v7) and p2.isOwned then
		return true
	end

	if not (p3 and p3.quantityLimitPerUser) then
		return false
	end

	if p3 and p3.quantityLimitPerUser > 0 then
		return p3.quantityLimitPerUser <= p4
	end

	return false
end

local function getOriginalStockAvailable(p2)
	local itemRestrictions = p2.itemRestrictions
	local v5 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v6 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v7 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	local v8 = v5 or v6 or v7
	return v8 and p2.numberRobloxHasAvailable and p2.numberRobloxHasAvailable > 0 or not v8
end

local function getButtonTypeIsPurchaseFromResale(data, p2)
	if not (p2 and data.hasResellers) then
		return false
	end

	local v5

	if data.priceInRobux and data.lowestResalePrice then
		v5 = data.lowestResalePrice < data.priceInRobux
	else
		v5 = data.lowestResalePrice ~= nil
	end

	local v6 = data.saleLocationType == SalesLocationType.ExperiencesDevApiOnly
	local itemRestrictions = data.itemRestrictions
	local v7 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v8 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v9 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	local v10 = v7 or v8 or v9
	local v11 = not (v10 and data.numberRobloxHasAvailable and data.numberRobloxHasAvailable > 0)
		and v10
		and true
		or false
		or data.isOffSale == true
		or v6

	return v5 or v11
end

local function getButtonTypeIsFree(data): boolean
	if data.isOffSale then
		return false
	end

	return data.saleLocationType ~= SalesLocationType.ExperiencesDevApiOnly and data.priceInRobux == 0
end

local function getButtonTypeIsExperienceLink(data, p2)
	if data.isOffSale then
		return false
	end

	local v5 = data.saleLocationType == SalesLocationType.ExperiencesDevApiOnly
	local itemRestrictions = data.itemRestrictions
	local v6 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v7 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v8 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	local v9 = v6 or v7 or v8
	local v10 = v9 and data.numberRobloxHasAvailable and data.numberRobloxHasAvailable > 0 or not v9
	local v11 = #(p2 and p2.experiences or {}) > 0

	return v5 and v11 and v10
end

local function getButtonTypeIsSoldOut(data, p2): boolean
	local itemRestrictions = data.itemRestrictions
	local v5 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v6 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v7 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	local v8 = v5 or v6 or v7
	local v9 = v8 and data.numberRobloxHasAvailable and data.numberRobloxHasAvailable > 0 or not v8

	local hasResellers = p2 and data.hasResellers
	return not (v9 or hasResellers)
end

local function getButtonTypeIsCustomizeLink(data, p2, p3, p4)
	local v5 = if fFlagAXDurablesForMIS then data.isOwned and not data.expirationTime else data.isOwned
	local itemRestrictions = data.itemRestrictions
	local v6 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v7 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v8 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	local v9

	if v6 or v7 or v8 or not data.isOwned then
		if p2 and p2.quantityLimitPerUser and p2 and p2.quantityLimitPerUser > 0 then
			v9 = p2.quantityLimitPerUser <= p3
		else
			v9 = false
		end
	else
		v9 = true
	end

	local hasResellers = p4 and data.hasResellers
	local itemRestrictions2 = data.itemRestrictions
	local v10 = itemRestrictions2 and itemRestrictions2[ItemRestrictions.Limited]
	local v11 = itemRestrictions2 and itemRestrictions2[ItemRestrictions.LimitedUnique]
	local v12 = itemRestrictions2 and itemRestrictions2[ItemRestrictions.Collectible]
	local v13 = v10 or v11 or v12
	local v14 = not (v13 and data.numberRobloxHasAvailable and data.numberRobloxHasAvailable > 0)
		and v13
		and true
		or false
		or v9
		or data.isOffSale

	return v5 and v14 and not hasResellers
end

local function getButtonTypeIsPurchasableFromRoblox(p2): boolean
	if p2.isOffSale then
		return false
	end

	return p2.saleLocationType ~= SalesLocationType.ExperiencesDevApiOnly
end

local function getButtonTypeIsQuantityLimitExceeded(p2, p3, p4): boolean
	if p3 == nil or p3.quantityLimitPerUser == nil then
		return false
	end

	return p3.quantityLimitPerUser > 0 and p3.quantityLimitPerUser <= p4
end

local function getItemPurchaseActionType(data, p2, p3, p4)
	if not data then
		return ItemPurchaseActionTypeEnum.Disabled
	end

	local v5

	if p2 == nil or p2.quantityLimitPerUser == nil or not (p2.quantityLimitPerUser > 0) then
		v5 = false
	else
		v5 = p2.quantityLimitPerUser <= p3
	end

	if v5 then
		return ItemPurchaseActionTypeEnum.QuantityLimitExceeded
	end

	local v6 = if fFlagAXDurablesForMIS then data.isOwned and not data.expirationTime else data.isOwned
	local itemRestrictions = data.itemRestrictions
	local v7 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v8 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v9 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	local v10

	if v7 or v8 or v9 or not data.isOwned then
		if p2 and p2.quantityLimitPerUser and p2 and p2.quantityLimitPerUser > 0 then
			v10 = p2.quantityLimitPerUser <= p3
		else
			v10 = false
		end
	else
		v10 = true
	end

	local hasResellers = p4 and data.hasResellers
	local itemRestrictions2 = data.itemRestrictions
	local v11 = itemRestrictions2 and itemRestrictions2[ItemRestrictions.Limited]
	local v12 = itemRestrictions2 and itemRestrictions2[ItemRestrictions.LimitedUnique]
	local v13 = itemRestrictions2 and itemRestrictions2[ItemRestrictions.Collectible]
	local v14 = v11 or v12 or v13
	local v15 = not (v14 and data.numberRobloxHasAvailable and data.numberRobloxHasAvailable > 0)
		and v14
		and true
		or false
		or v10
		or data.isOffSale

	if v6 and v15 and not hasResellers then
		return ItemPurchaseActionTypeEnum.CustomizeLink
	end

	local itemRestrictions3 = data.itemRestrictions
	local v16 = itemRestrictions3 and itemRestrictions3[ItemRestrictions.Limited]
	local v17 = itemRestrictions3 and itemRestrictions3[ItemRestrictions.LimitedUnique]
	local v18 = itemRestrictions3 and itemRestrictions3[ItemRestrictions.Collectible]
	local v19 = v16 or v17 or v18
	local v20 = v19 and data.numberRobloxHasAvailable and data.numberRobloxHasAvailable > 0 or not v19

	local hasResellers2 = p4 and data.hasResellers

	if not (v20 or hasResellers2) then
		return ItemPurchaseActionTypeEnum.SoldOut
	end

	local v21

	if p4 and data.hasResellers then
		local v22

		if data.priceInRobux and data.lowestResalePrice then
			v22 = data.lowestResalePrice < data.priceInRobux
		else
			v22 = data.lowestResalePrice ~= nil
		end

		local v23 = data.saleLocationType == SalesLocationType.ExperiencesDevApiOnly
		local itemRestrictions4 = data.itemRestrictions
		local v24 = itemRestrictions4 and itemRestrictions4[ItemRestrictions.Limited]
		local v25 = itemRestrictions4 and itemRestrictions4[ItemRestrictions.LimitedUnique]
		local v26 = itemRestrictions4 and itemRestrictions4[ItemRestrictions.Collectible]
		local v27 = v24 or v25 or v26
		local v28 = not (v27 and data.numberRobloxHasAvailable and data.numberRobloxHasAvailable > 0)
			and v27
			and true
			or false
			or data.isOffSale == true
			or v23
		v21 = v22 or v28
	else
		v21 = false
	end

	if v21 then
		return ItemPurchaseActionTypeEnum.PurchaseFromResale
	end

	local v22

	if data.isOffSale then
		v22 = false
	else
		local v23 = data.saleLocationType == SalesLocationType.ExperiencesDevApiOnly
		local itemRestrictions4 = data.itemRestrictions
		local v24 = itemRestrictions4 and itemRestrictions4[ItemRestrictions.Limited]
		local v25 = itemRestrictions4 and itemRestrictions4[ItemRestrictions.LimitedUnique]
		local v26 = itemRestrictions4 and itemRestrictions4[ItemRestrictions.Collectible]
		local v27 = v24 or v25 or v26
		local v28 = v27 and data.numberRobloxHasAvailable and data.numberRobloxHasAvailable > 0 or not v27
		local v29 = #(p2 and p2.experiences or {}) > 0
		v22 = v23 and v29 and v28
	end

	if v22 then
		return ItemPurchaseActionTypeEnum.ExperienceLink
	end

	local v23

	if data.isOffSale then
		v23 = false
	else
		v23 = data.saleLocationType ~= SalesLocationType.ExperiencesDevApiOnly and data.priceInRobux == 0
	end

	if v23 then
		return ItemPurchaseActionTypeEnum.Free
	end

	local v24 = not data.isOffSale and data.saleLocationType ~= SalesLocationType.ExperiencesDevApiOnly

	if v24 then
		return ItemPurchaseActionTypeEnum.PurchaseFromRoblox
	end

	return ItemPurchaseActionTypeEnum.Disabled
end

return getItemPurchaseActionType
