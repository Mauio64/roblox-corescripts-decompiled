local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage
local DataHydration = require(Parent.DataHydration)
local FFlagSduiSubscriptionCellPostPurchaseSync = require(Parent.SharedFlags).FFlagSduiSubscriptionCellPostPurchaseSync
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local function buildSubscriptionProductInfo(p1) -- line: 20
	return {
		isForSale = true,
		name = p1.name or "",
		description = p1.description or "",
		iconImageAssetId = tonumber(p1.imageAssetId) or 0,
		subscriptionPeriod = p1.periodType or "",
		displayPrice = p1.priceDisplay or "",
		priceInRobux = tonumber(p1.priceInRobux),
		priceTier = tonumber(p1.priceTier) or 0,
		subscriptionProviderName = p1.creatorName or "",
		subscriptionProviderId = p1.universeId,
		subscriptionTargetKey = p1.subscriptionId
	}
end

return function(p2, _, p4) -- line: 36
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), buildSubscriptionProductInfo (copy), FFlagSduiSubscriptionCellPostPurchaseSync (copy), DataHydration (copy), AppPage (copy)
	local logger = p4.dependencies.logger
	local appPage = p4.appPage
	local v15 = p2 and p2.actionParams

	if v15 == nil then
		logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			name = SduiActionType.OpenSubscriptionPurchasePage
		}, appPage)

		return
	end

	local subscriptionId = v15.subscriptionId
	local universeId = v15.universeId

	if typeof(subscriptionId) ~= "string" or subscriptionId == "" then
		logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing or invalid subscriptionId",
			propName = "subscriptionId",
			name = SduiActionType.OpenSubscriptionPurchasePage
		}, appPage)

		return
	end

	if typeof(universeId) ~= "string" or universeId == "" then
		logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing or invalid universeId",
			propName = "universeId",
			name = SduiActionType.OpenSubscriptionPurchasePage
		}, appPage)

		return
	end

	local v18 = v15.thumbnailString or ""
	local v19 = v15.isSubscribed == true
	local t1 = {
		subscriptionPurchaseProductInfo = buildSubscriptionProductInfo(v15),
		thumbnailString = v18,
		isSubScribed = v19,
		isSubscribed = v19,
		creatorName = v15.creatorName,
		creatorVerified = v15.creatorVerified,
		onPurchaseSuccess = if not FFlagSduiSubscriptionCellPostPurchaseSync then nil else function() -- line: 86
			-- upvalues: DataHydration (copy), subscriptionId (copy)
			DataHydration.Game.getGameSubscriptionStore(false).updateGameSubscriptionInfo(subscriptionId, {
				isSubscribed = true
			})
		end
	}

	p4.dependencies.getNavigation().push(AppPage.SubscriptionPurchase, {
		extraProps = t1
	})
end
