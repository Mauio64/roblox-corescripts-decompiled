local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local MarketplaceService = game:GetService("MarketplaceService")
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local PromptState = require(RobloxSubscriptionPurchaseApp.Enums.PromptState)

require(RobloxSubscriptionPurchaseApp.Models.GetRobloxSubscriptionProductsModel)

local finalizeRobloxSubscriptionUpsellFlow = require(RobloxSubscriptionPurchaseApp.Actions.finalizeRobloxSubscriptionUpsellFlow)
local FFlagFixSignalFinishedOnError = require(RobloxSubscriptionPurchaseApp.Flags.FFlagFixSignalFinishedOnError)
local EngineFeature = game:GetEngineFeature("EnablePromptSignalRobloxSubscriptionPurchaseFinished")

local function completeRobloxSubscriptionUpsellFlow() -- line: 16
	-- upvalues: RobloxSubscriptionStore (copy), PromptState (copy), FFlagFixSignalFinishedOnError (copy), EngineFeature (copy), MarketplaceService (copy), finalizeRobloxSubscriptionUpsellFlow (copy)
	local v9 = RobloxSubscriptionStore.get()
	local v10 = v9.getDidTryPurchasing()
	local v11 = v9.getRobloxSubscriptionProductId()
	local skipWaitingForPurchaseResult = v9.getPurchaseFlowOptions().skipWaitingForPurchaseResult
	local v13 = v9.getPromptState()

	if v13 == PromptState.Error or v13 == PromptState.SubscriptionStatusPolling then
		if v13 == PromptState.Error and FFlagFixSignalFinishedOnError and EngineFeature then
			MarketplaceService:signalPromptRobloxSubscriptionPurchaseFinished(v11, v10)
		end

		finalizeRobloxSubscriptionUpsellFlow(false)

		return
	end

	v9.setPromptState(PromptState.SubscriptionPurchaseCompleted)

	if EngineFeature then
		MarketplaceService:signalPromptRobloxSubscriptionPurchaseFinished(v11, v10)
	end

	if skipWaitingForPurchaseResult or not v10 then
		finalizeRobloxSubscriptionUpsellFlow(false)

		return
	end

	v9.setPromptState(PromptState.SubscriptionStatusPolling)
end

return completeRobloxSubscriptionUpsellFlow
