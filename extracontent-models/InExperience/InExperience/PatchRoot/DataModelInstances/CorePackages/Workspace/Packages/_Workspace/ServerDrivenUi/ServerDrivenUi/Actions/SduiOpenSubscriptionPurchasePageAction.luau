local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local DataHydration = require(parent.DataHydration)

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiSubscriptionCellPostPurchaseSync = SharedFlags.FFlagSduiSubscriptionCellPostPurchaseSync

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local function buildSubscriptionProductInfo(actionParams)
	return {
		name = actionParams.name or "",
		description = actionParams.description or "",
		iconImageAssetId = tonumber(actionParams.imageAssetId) or 0,
		subscriptionPeriod = actionParams.periodType or "",
		displayPrice = actionParams.priceDisplay or "",
		priceInRobux = tonumber(actionParams.priceInRobux),
		priceTier = tonumber(actionParams.priceTier) or 0,
		subscriptionProviderName = actionParams.creatorName or "",
		subscriptionProviderId = actionParams.universeId,
		isForSale = true,
		subscriptionTargetKey = actionParams.subscriptionId
	}
end

return function(p, _, p2)
	local logger = p2.dependencies.logger
	local appPage = p2.appPage

	local actionParams = p and p.actionParams

	if actionParams == nil then
		logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.OpenSubscriptionPurchasePage, message = "Missing actionParams" },
			appPage
		)

		return
	end

	local subscriptionId = actionParams.subscriptionId
	local universeId = actionParams.universeId

	if typeof(subscriptionId) ~= "string" or subscriptionId == "" then
		logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.OpenSubscriptionPurchasePage,
				message = "Missing or invalid subscriptionId",
				propName = "subscriptionId"
			},
			appPage
		)

		return
	end

	if typeof(universeId) ~= "string" or universeId == "" then
		logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.OpenSubscriptionPurchasePage,
				message = "Missing or invalid universeId",
				propName = "universeId"
			},
			appPage
		)

		return
	end

	local thumbnailString = actionParams.thumbnailString or ""
	local isSubscribed = actionParams.isSubscribed == true
	local extraProps = {
		subscriptionPurchaseProductInfo = buildSubscriptionProductInfo(actionParams),
		thumbnailString = thumbnailString,
		isSubScribed = isSubscribed,
		isSubscribed = isSubscribed,
		creatorName = actionParams.creatorName,
		creatorVerified = actionParams.creatorVerified,
		onPurchaseSuccess = FFlagSduiSubscriptionCellPostPurchaseSync and function()
			DataHydration.Game.getGameSubscriptionStore(false).updateGameSubscriptionInfo(subscriptionId, {
				isSubscribed = true
			})
		end or nil
	}

	p2.dependencies.getNavigation().push(AppPage.SubscriptionPurchase, { extraProps = extraProps })
end
