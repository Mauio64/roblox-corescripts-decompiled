local module = require("@luauforge/bundled/dME")

local module2 = require("@luauforge/deferred/fvU")
local module3 = require("@luauforge/deferred/fvW")
local fFlagAXShowFaeUpsell = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXShowFaeUpsell

local function getAvailableInExperienceOnly(p2): boolean
	return p2.saleLocationType == module.SaleLocationType.ExperiencesDevApiOnly
end

local function getHasLimitedAmount(p2)
	local itemRestrictions = p2.itemRestrictions
	local v5 = itemRestrictions and itemRestrictions[module.ItemRestrictions.Limited]
	local v6 = itemRestrictions and itemRestrictions[module.ItemRestrictions.LimitedUnique]
	local v7 = itemRestrictions and itemRestrictions[module.ItemRestrictions.Collectible]
	return v5 or v6 or v7
end

local function getUserHasReachedQuantityLimit(p2, p3, p4): boolean
	local itemRestrictions = p2.itemRestrictions
	local v5 = itemRestrictions and itemRestrictions[module.ItemRestrictions.Limited]
	local v6 = itemRestrictions and itemRestrictions[module.ItemRestrictions.LimitedUnique]
	local v7 = itemRestrictions and itemRestrictions[module.ItemRestrictions.Collectible]

	if not (v5 or v6 or v7) and p2.isOwned then
		return true
	end

	if not (p3 and p3.quantityLimitPerUser) then
		return false
	end

	return p3.quantityLimitPerUser > 0 and p3.quantityLimitPerUser <= p4
end

local function getOriginalStockAvailable(p2)
	local itemRestrictions = p2.itemRestrictions
	local v5 = itemRestrictions and itemRestrictions[module.ItemRestrictions.Limited]
	local v6 = itemRestrictions and itemRestrictions[module.ItemRestrictions.LimitedUnique]
	local v7 = itemRestrictions and itemRestrictions[module.ItemRestrictions.Collectible]
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

	local itemRestrictions = data.itemRestrictions
	local v6 = itemRestrictions and itemRestrictions[module.ItemRestrictions.Limited]
	local v7 = itemRestrictions and itemRestrictions[module.ItemRestrictions.LimitedUnique]
	local v8 = itemRestrictions and itemRestrictions[module.ItemRestrictions.Collectible]
	local v9 = v6 or v7 or v8
	local v10 = not (v9 and data.numberRobloxHasAvailable and data.numberRobloxHasAvailable > 0)
		and v9
		and true
		or false
		or data.isOffSale == true
	return v5 or v10
end

local function getButtonTypeIsFree(data): boolean
	if data.isOffSale then
		return false
	end

	return data.saleLocationType ~= module.SaleLocationType.ExperiencesDevApiOnly and data.priceInRobux == 0
end

local function getButtonTypeIsExperienceLink(data, p2)
	if data.isOffSale then
		return false
	end

	local v5 = data.saleLocationType == module.SaleLocationType.ExperiencesDevApiOnly
	local itemRestrictions = data.itemRestrictions
	local v6 = itemRestrictions and itemRestrictions[module.ItemRestrictions.Limited]
	local v7 = itemRestrictions and itemRestrictions[module.ItemRestrictions.LimitedUnique]
	local v8 = itemRestrictions and itemRestrictions[module.ItemRestrictions.Collectible]
	local v9 = v6 or v7 or v8
	local v10 = v9 and data.numberRobloxHasAvailable and data.numberRobloxHasAvailable > 0 or not v9

	local v11 = module3(p2) > 0
	return v5 and v11 and v10
end

local function getButtonTypeIsSoldOut(data, p2): boolean
	local itemRestrictions = data.itemRestrictions
	local v5 = itemRestrictions and itemRestrictions[module.ItemRestrictions.Limited]
	local v6 = itemRestrictions and itemRestrictions[module.ItemRestrictions.LimitedUnique]
	local v7 = itemRestrictions and itemRestrictions[module.ItemRestrictions.Collectible]
	local v8 = v5 or v6 or v7
	local v9 = v8 and data.numberRobloxHasAvailable and data.numberRobloxHasAvailable > 0 or not v8

	local hasResellers = p2 and data.hasResellers
	return not (v9 or hasResellers)
end

local function getButtonTypeIsCustomizeLink(data, p2, p3, p4)
	local isOwned = data.isOwned
	local isPurchasable = data.timedOptions and data.isPurchasable
	local itemRestrictions = data.itemRestrictions
	local v5 = itemRestrictions and itemRestrictions[module.ItemRestrictions.Limited]
	local v6 = itemRestrictions and itemRestrictions[module.ItemRestrictions.LimitedUnique]
	local v7 = itemRestrictions and itemRestrictions[module.ItemRestrictions.Collectible]
	local v8

	if v5 or v6 or v7 or not data.isOwned then
		if p2 and p2.quantityLimitPerUser and p2.quantityLimitPerUser > 0 then
			v8 = p2.quantityLimitPerUser <= p3
		else
			v8 = false
		end
	else
		v8 = true
	end

	local hasResellers = p4 and data.hasResellers
	local itemRestrictions2 = data.itemRestrictions
	local v9 = itemRestrictions2 and itemRestrictions2[module.ItemRestrictions.Limited]
	local v10 = itemRestrictions2 and itemRestrictions2[module.ItemRestrictions.LimitedUnique]
	local v11 = itemRestrictions2 and itemRestrictions2[module.ItemRestrictions.Collectible]
	local v12 = v9 or v10 or v11
	local v13 = not (v12 and data.numberRobloxHasAvailable and data.numberRobloxHasAvailable > 0)
		and v12
		and true
		or false
		or v8
		or data.isOffSale

	return isOwned and v13 and not hasResellers and not isPurchasable
end

local function getButtonTypeIsPurchasableFromRoblox(p2): boolean
	if p2.isOffSale then
		return false
	end

	return p2.saleLocationType ~= module.SaleLocationType.ExperiencesDevApiOnly
end

local function getActionButtonType(data, p2, p3, p4, p5, p6)
	if p4 then
		return module2.Loading
	end

	if not data then
		return module2.Disabled
	end

	local isOwned = data.isOwned
	local isPurchasable = data.timedOptions and data.isPurchasable
	local itemRestrictions = data.itemRestrictions
	local v5 = itemRestrictions and itemRestrictions[module.ItemRestrictions.Limited]
	local v6 = itemRestrictions and itemRestrictions[module.ItemRestrictions.LimitedUnique]
	local v7 = itemRestrictions and itemRestrictions[module.ItemRestrictions.Collectible]
	local v8

	if v5 or v6 or v7 or not data.isOwned then
		if p2 and p2.quantityLimitPerUser and p2.quantityLimitPerUser > 0 then
			v8 = p2.quantityLimitPerUser <= p3
		else
			v8 = false
		end
	else
		v8 = true
	end

	local hasResellers = p5 and data.hasResellers
	local itemRestrictions2 = data.itemRestrictions
	local v9 = itemRestrictions2 and itemRestrictions2[module.ItemRestrictions.Limited]
	local v10 = itemRestrictions2 and itemRestrictions2[module.ItemRestrictions.LimitedUnique]
	local v11 = itemRestrictions2 and itemRestrictions2[module.ItemRestrictions.Collectible]
	local v12 = v9 or v10 or v11
	local v13 = not (v12 and data.numberRobloxHasAvailable and data.numberRobloxHasAvailable > 0)
		and v12
		and true
		or false
		or v8
		or data.isOffSale

	if isOwned and v13 and not hasResellers and not isPurchasable then
		return module2.CustomizeLink
	end

	if fFlagAXShowFaeUpsell and p6 and (p6.showFaeUpsell or p6.canClaimFaeItem) then
		return module2.UnlockableItem
	end

	local itemRestrictions3 = data.itemRestrictions
	local v14 = itemRestrictions3 and itemRestrictions3[module.ItemRestrictions.Limited]
	local v15 = itemRestrictions3 and itemRestrictions3[module.ItemRestrictions.LimitedUnique]
	local v16 = itemRestrictions3 and itemRestrictions3[module.ItemRestrictions.Collectible]
	local v17 = v14 or v15 or v16
	local v18 = v17 and data.numberRobloxHasAvailable and data.numberRobloxHasAvailable > 0 or not v17

	local hasResellers2 = p5 and data.hasResellers

	if not (v18 or hasResellers2) then
		return module2.SoldOut
	end

	local v19

	if p5 and data.hasResellers then
		local v20

		if data.priceInRobux and data.lowestResalePrice then
			v20 = data.lowestResalePrice < data.priceInRobux
		else
			v20 = data.lowestResalePrice ~= nil
		end

		local itemRestrictions4 = data.itemRestrictions
		local v21 = itemRestrictions4 and itemRestrictions4[module.ItemRestrictions.Limited]
		local v22 = itemRestrictions4 and itemRestrictions4[module.ItemRestrictions.LimitedUnique]
		local v23 = itemRestrictions4 and itemRestrictions4[module.ItemRestrictions.Collectible]
		local v24 = v21 or v22 or v23
		local v25 = not (v24 and data.numberRobloxHasAvailable and data.numberRobloxHasAvailable > 0)
			and v24
			and true
			or false
			or data.isOffSale == true
		v19 = v20 or v25
	else
		v19 = false
	end

	if v19 then
		return module2.PurchaseFromResale
	end

	local v20

	if data.isOffSale then
		v20 = false
	else
		local v21 = data.saleLocationType == module.SaleLocationType.ExperiencesDevApiOnly
		local itemRestrictions4 = data.itemRestrictions
		local v22 = itemRestrictions4 and itemRestrictions4[module.ItemRestrictions.Limited]
		local v23 = itemRestrictions4 and itemRestrictions4[module.ItemRestrictions.LimitedUnique]
		local v24 = itemRestrictions4 and itemRestrictions4[module.ItemRestrictions.Collectible]
		local v25 = v22 or v23 or v24
		local v26 = v25 and data.numberRobloxHasAvailable and data.numberRobloxHasAvailable > 0 or not v25

		local v27 = module3(p2) > 0
		v20 = v21 and v27 and v26
	end

	if v20 then
		return module2.ExperienceLink
	end

	local v21

	if data.isOffSale then
		v21 = false
	else
		v21 = data.saleLocationType ~= module.SaleLocationType.ExperiencesDevApiOnly
			and data.priceInRobux == 0
	end

	if v21 then
		return module2.Free
	end

	local v22

	if data.isOffSale then
		v22 = false
	else
		v22 = data.saleLocationType ~= module.SaleLocationType.ExperiencesDevApiOnly
	end

	if v22 then
		return module2.PurchaseFromRoblox
	end

	return module2.Disabled
end

return getActionButtonType
