local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")

local parent = AvatarExperienceCommon.Parent

local ItemPurchaseActionTypeEnum = require(AvatarExperienceCommon.Enums.ItemPurchaseActionTypeEnum)
local SalesLocationType = require(AvatarExperienceCommon.Enums.SalesLocationType)
local ItemRestrictions = require(AvatarExperienceCommon.Enums.ItemRestrictions)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS

local function getExperienceCount(p) -- 1 equivalent call inferred from this helper
	return #(p and p.experiences or {})
end

local function getAvailableInExperienceOnly(data): boolean -- 3 equivalent calls inferred from this helper
	return data.saleLocationType == SalesLocationType.ExperiencesDevApiOnly
end

local function getHasLimitedAmount(p) -- 4 equivalent calls inferred from this helper
	local itemRestrictions = p.itemRestrictions
	local v = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v2 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v3 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	return v or v2 or v3
end

local function getUserHasReachedQuantityLimit(p, p2, p3: number): boolean
	if not getHasLimitedAmount(p) and p.isOwned then -- inferred equivalent call
		return true
	end

	if not (p2 and p2.quantityLimitPerUser) then
		return false
	end

	if p2 and p2.quantityLimitPerUser > 0 then
		return p2.quantityLimitPerUser <= p3
	end

	return false
end

local function getOriginalStockAvailable(p) -- 2 equivalent calls inferred from this helper
	local hasLimitedAmount = getHasLimitedAmount(p) -- inferred equivalent call
	return hasLimitedAmount and p.numberRobloxHasAvailable and p.numberRobloxHasAvailable > 0 or not hasLimitedAmount
end

local function getButtonTypeIsPurchaseFromResale(data, flag: boolean) -- 1 equivalent call inferred from this helper
	if not (flag and data.hasResellers) then
		return false
	end

	local v

	if data.priceInRobux and data.lowestResalePrice then
		v = data.lowestResalePrice < data.priceInRobux
	else
		v = data.lowestResalePrice ~= nil
	end

	local v2 = data.saleLocationType == SalesLocationType.ExperiencesDevApiOnly
	local hasLimitedAmount = getHasLimitedAmount(data) -- inferred equivalent call
	local v3 = not (hasLimitedAmount and data.numberRobloxHasAvailable and data.numberRobloxHasAvailable > 0)
		and hasLimitedAmount
		and true
		or false
		or data.isOffSale == true
		or v2

	return v or v3
end

local function getButtonTypeIsFree(data): boolean -- 1 equivalent call inferred from this helper
	return not data.isOffSale and not getAvailableInExperienceOnly(data) and data.priceInRobux == 0 -- inferred equivalent call
end

local function getButtonTypeIsExperienceLink(data, p) -- 1 equivalent call inferred from this helper
	if data.isOffSale then
		return false
	end

	local v = data.saleLocationType == SalesLocationType.ExperiencesDevApiOnly
	local originalStockAvailable = getOriginalStockAvailable(data) -- inferred equivalent call
	local v2 = getExperienceCount(p) > 0 -- inferred equivalent call
	return v and v2 and originalStockAvailable
end

local function getButtonTypeIsSoldOut(data, flag: boolean): boolean -- 1 equivalent call inferred from this helper
	local originalStockAvailable = getOriginalStockAvailable(data) -- inferred equivalent call
	local hasResellers = flag and data.hasResellers
	return not (originalStockAvailable or hasResellers)
end

local function getButtonTypeIsCustomizeLink(data, p, p2: number, flag: boolean) -- 1 equivalent call inferred from this helper
	local v

	if FFlagAXDurablesForMIS then
		v = data.isOwned and not data.expirationTime
	else
		v = data.isOwned
	end

	local itemRestrictions = data.itemRestrictions
	local v2 = itemRestrictions and itemRestrictions[ItemRestrictions.Limited]
	local v3 = itemRestrictions and itemRestrictions[ItemRestrictions.LimitedUnique]
	local v4 = itemRestrictions and itemRestrictions[ItemRestrictions.Collectible]
	local v5

	if v2 or v3 or v4 or not data.isOwned then
		if p and p.quantityLimitPerUser and p and p.quantityLimitPerUser > 0 then
			v5 = p.quantityLimitPerUser <= p2
		else
			v5 = false
		end
	else
		v5 = true
	end

	local hasResellers = flag and data.hasResellers
	local hasLimitedAmount = getHasLimitedAmount(data) -- inferred equivalent call
	local v6 = not (hasLimitedAmount and data.numberRobloxHasAvailable and data.numberRobloxHasAvailable > 0)
		and hasLimitedAmount
		and true
		or false
		or v5
		or data.isOffSale

	return v and v6 and not hasResellers
end

local function getButtonTypeIsPurchasableFromRoblox(p): boolean
	return not p.isOffSale and not getAvailableInExperienceOnly(p) -- inferred equivalent call
end

local function getButtonTypeIsQuantityLimitExceeded(_, p, p2: number): boolean -- 1 equivalent call inferred from this helper
	if p == nil or p.quantityLimitPerUser == nil then
		return false
	end

	return p.quantityLimitPerUser > 0 and p.quantityLimitPerUser <= p2
end

local function getItemPurchaseActionType(data, p, p2: number, flag: boolean)
	if not data then
		return ItemPurchaseActionTypeEnum.Disabled
	end

	if getButtonTypeIsQuantityLimitExceeded(nil, p, p2) then -- inferred equivalent call
		return ItemPurchaseActionTypeEnum.QuantityLimitExceeded
	end

	if getButtonTypeIsCustomizeLink(data, p, p2, flag) then -- inferred equivalent call
		return ItemPurchaseActionTypeEnum.CustomizeLink
	end

	if getButtonTypeIsSoldOut(data, flag) then -- inferred equivalent call
		return ItemPurchaseActionTypeEnum.SoldOut
	end

	if getButtonTypeIsPurchaseFromResale(data, flag) then -- inferred equivalent call
		return ItemPurchaseActionTypeEnum.PurchaseFromResale
	end

	if getButtonTypeIsExperienceLink(data, p) then -- inferred equivalent call
		return ItemPurchaseActionTypeEnum.ExperienceLink
	end

	if getButtonTypeIsFree(data) then -- inferred equivalent call
		return ItemPurchaseActionTypeEnum.Free
	end

	local v

	if data.isOffSale then
		v = false
	else
		v = not getAvailableInExperienceOnly(data) -- inferred equivalent call
	end

	if v then
		return ItemPurchaseActionTypeEnum.PurchaseFromRoblox
	end

	return ItemPurchaseActionTypeEnum.Disabled
end

return getItemPurchaseActionType
