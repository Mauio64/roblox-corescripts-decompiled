local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums").AppPage

local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DataHydration")

local fFlagSduiSubscriptionCellPostPurchaseSync = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiSubscriptionCellPostPurchaseSync

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

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

return function(p2, p3, p4)
	local logger = p4.dependencies.logger
	local appPage2 = p4.appPage

	local actionParams = p2 and p2.actionParams

	if actionParams == nil then
		logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenSubscriptionPurchasePage,
				message = "Missing actionParams"
			},
			appPage2
		)

		return
	end

	local subscriptionId = actionParams.subscriptionId
	local universeId = actionParams.universeId

	if typeof(subscriptionId) ~= "string" or subscriptionId == "" then
		logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenSubscriptionPurchasePage,
				message = "Missing or invalid subscriptionId",
				propName = "subscriptionId"
			},
			appPage2
		)

		return
	end

	if typeof(universeId) ~= "string" or universeId == "" then
		logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenSubscriptionPurchasePage,
				message = "Missing or invalid universeId",
				propName = "universeId"
			},
			appPage2
		)

		return
	end

	local thumbnailString = actionParams.thumbnailString or ""
	local isSubscribed = actionParams.isSubscribed == true
	local v5 = {
		subscriptionPurchaseProductInfo = buildSubscriptionProductInfo(actionParams),
		thumbnailString = thumbnailString,
		isSubScribed = isSubscribed,
		isSubscribed = isSubscribed,
		creatorName = actionParams.creatorName,
		creatorVerified = actionParams.creatorVerified,
		onPurchaseSuccess = fFlagSduiSubscriptionCellPostPurchaseSync and function()
			DataHydration.Game.getGameSubscriptionStore(false).updateGameSubscriptionInfo(subscriptionId, {
				isSubscribed = true
			})
		end or nil
	}

	p4.dependencies.getNavigation().push(appPage.SubscriptionPurchase, {
		extraProps = v5
	})
end
