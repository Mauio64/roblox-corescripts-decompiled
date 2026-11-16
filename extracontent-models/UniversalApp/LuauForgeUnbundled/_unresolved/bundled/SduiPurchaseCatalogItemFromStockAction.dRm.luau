local itemDetailsSduiHost = require("@luauforge/bundled/dQp").ItemDetailsSduiHost
local itemData = require("@luauforge/bundled/dQS").State.Selectors.ItemData
local avatarScreen = require("@luauforge/bundled/dQc").Enums.AvatarScreen

local sduiActionType = require("@luauforge/bundled/dQa").SduiActionType

local module = require("@luauforge/bundled/dQR")

local purchaseCatalogItemFromStock = sduiActionType.PurchaseCatalogItemFromStock

local function readPrice(value)
	if typeof(value) == "number" then
		return value
	end

	if typeof(value) == "string" then
		return (tonumber(value))
	end

	return nil
end

local function selectUserRobux(p2)
	local localUserId = p2.LocalUserId
	local userRobux = p2.UserRobux

	if localUserId == nil or userRobux == nil then
		return nil
	end

	return userRobux[localUserId]
end

local function selectHasPurchaseFromStockData(state, itemId, itemType): boolean
	local common = state.AvatarExperience.Common
	local v5 = itemData(common, itemId, itemType)

	if v5 == nil or not v5.receivedCatalogData then
		return false
	end

	local collectibleItemId = v5.collectibleItemId

	if collectibleItemId == nil then
		local product = v5.product
		return product ~= nil and product.id ~= nil
	else
		local v6 = common.Collectibles.CollectiblesItemInfo[collectibleItemId]
		local creator = v5.creator

		return v6 ~= nil and v6.collectibleProductId ~= nil and creator ~= nil and creator.type ~= nil
	end
end

local function PurchaseFromStock(data, p2, p3)
	return function(object)
		local state = object:getState()
		local localUserId = state.LocalUserId
		local userRobux = state.UserRobux
		local v5 = if not (localUserId == nil or userRobux == nil) then userRobux[localUserId] else nil

		if v5 == nil or v5 < data.price then
			p2.navigate(avatarScreen.InsufficientRobuxPrompt, {})
		elseif selectHasPurchaseFromStockData(state, data.itemId, data.itemType) then
			p2.navigate(avatarScreen.PurchaseCatalogItem, {
				itemId = data.itemId,
				itemType = data.itemType,
				priceInRobux = data.price,
				sellerId = data.sellerId,
				sellerName = data.sellerName,
				fromProfile = p2.getParam("fromProfile"),
				fromContentFeed = p2.getParam("fromContentFeed")
			})
		else
			module.reportFailedToExecute(
				purchaseCatalogItemFromStock,
				p3,
				`Rodux has not loaded what the purchase prompt needs to buy {data.itemType} {data.itemId}`
			)
		end
	end
end

local function SduiPurchaseCatalogItemFromStockAction(p2, p3, p4, p5)
	local actionParams = module.readActionParams(purchaseCatalogItemFromStock, p2, p4)

	if actionParams == nil then
		return
	end

	local catalogItem = module.readCatalogItem(purchaseCatalogItemFromStock, actionParams, p4)

	if catalogItem == nil then
		return
	end

	local price = actionParams.price

	if typeof(price) ~= "number" then
		price = if typeof(price) == "string" then tonumber(price) else nil
	end

	if price == nil then
		module.reportInvalidParams(purchaseCatalogItemFromStock, p4, "Missing actionParam: price", "price")
		return
	end

	local requiredId = module.readRequiredId(purchaseCatalogItemFromStock, actionParams, "sellerId", p4)

	if requiredId == nil then
		return
	end

	local sellerName = actionParams.sellerName

	local v5 = itemDetailsSduiHost.get(p4.configKey)
	local getScreenNavigation = if v5 then v5.getScreenNavigation else nil

	if getScreenNavigation == nil then
		module.reportFailedToExecute(
			purchaseCatalogItemFromStock,
			p4,
			"No Item Details page that offers this control is mounted for this configKey"
		)

		return
	end

	local dispatch = p4.dependencies.dispatch
	local v6 = {
		itemId = catalogItem.itemId,
		itemType = catalogItem.itemType,
		price = price,
		sellerId = requiredId,
		sellerName = 0
	}

	if typeof(sellerName) ~= "string" or sellerName == "" then
		sellerName = nil
	end

	v6.sellerName = sellerName
	local screenNavigation = getScreenNavigation()
	dispatch(function(object)
		local state = object:getState()
		local localUserId = state.LocalUserId
		local userRobux = state.UserRobux
		local v7 = if not (localUserId == nil or userRobux == nil) then userRobux[localUserId] else nil

		if v7 == nil or v7 < v6.price then
			screenNavigation.navigate(avatarScreen.InsufficientRobuxPrompt, {})
		elseif selectHasPurchaseFromStockData(state, v6.itemId, v6.itemType) then
			screenNavigation.navigate(avatarScreen.PurchaseCatalogItem, {
				itemId = v6.itemId,
				itemType = v6.itemType,
				priceInRobux = v6.price,
				sellerId = v6.sellerId,
				sellerName = v6.sellerName,
				fromProfile = screenNavigation.getParam("fromProfile"),
				fromContentFeed = screenNavigation.getParam("fromContentFeed")
			})
		else
			module.reportFailedToExecute(
				purchaseCatalogItemFromStock,
				p4,
				`Rodux has not loaded what the purchase prompt needs to buy {v6.itemType} {v6.itemId}`
			)
		end
	end)
end

return SduiPurchaseCatalogItemFromStockAction
