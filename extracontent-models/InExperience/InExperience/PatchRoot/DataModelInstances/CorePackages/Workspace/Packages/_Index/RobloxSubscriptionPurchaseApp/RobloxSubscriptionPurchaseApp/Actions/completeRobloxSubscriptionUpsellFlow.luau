local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local MarketplaceService = game:GetService("MarketplaceService")

local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local PromptState = require(RobloxSubscriptionPurchaseApp.Enums.PromptState)
require(RobloxSubscriptionPurchaseApp.Models.GetRobloxSubscriptionProductsModel)
local finalizeRobloxSubscriptionUpsellFlow = require(RobloxSubscriptionPurchaseApp.Actions.finalizeRobloxSubscriptionUpsellFlow)
local FFlagFixSignalFinishedOnError = require(RobloxSubscriptionPurchaseApp.Flags.FFlagFixSignalFinishedOnError)

local engineFeature = game:GetEngineFeature("EnablePromptSignalRobloxSubscriptionPurchaseFinished")

local function completeRobloxSubscriptionUpsellFlow()
	local v = RobloxSubscriptionStore.get()
	local didTryPurchasing = v.getDidTryPurchasing()
	local robloxSubscriptionProductId = v.getRobloxSubscriptionProductId()
	local skipWaitingForPurchaseResult = v.getPurchaseFlowOptions().skipWaitingForPurchaseResult
	local promptState = v.getPromptState()

	if promptState == PromptState.Error or promptState == PromptState.SubscriptionStatusPolling then
		if promptState == PromptState.Error and FFlagFixSignalFinishedOnError and engineFeature then
			MarketplaceService:signalPromptRobloxSubscriptionPurchaseFinished(
				robloxSubscriptionProductId,
				didTryPurchasing
			)
		end

		finalizeRobloxSubscriptionUpsellFlow(false)
	else
		v.setPromptState(PromptState.SubscriptionPurchaseCompleted)

		if engineFeature then
			MarketplaceService:signalPromptRobloxSubscriptionPurchaseFinished(
				robloxSubscriptionProductId,
				didTryPurchasing
			)
		end

		if skipWaitingForPurchaseResult or not didTryPurchasing then
			finalizeRobloxSubscriptionUpsellFlow(false)
		else
			v.setPromptState(PromptState.SubscriptionStatusPolling)
		end
	end
end

return completeRobloxSubscriptionUpsellFlow
