local MarketplaceService = game:GetService("MarketplaceService")

local RobloxSubscriptionStore = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/RobloxSubscriptionStore")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/PromptState")
require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Models/GetRobloxSubscriptionProductsModel")
local finalizeRobloxSubscriptionUpsellFlow = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Actions/finalizeRobloxSubscriptionUpsellFlow")
local FFlagFixSignalFinishedOnError = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagFixSignalFinishedOnError")

local engineFeature = game:GetEngineFeature("EnablePromptSignalRobloxSubscriptionPurchaseFinished")

local function completeRobloxSubscriptionUpsellFlow()
	local v5 = RobloxSubscriptionStore.get()
	local didTryPurchasing = v5.getDidTryPurchasing()
	local robloxSubscriptionProductId = v5.getRobloxSubscriptionProductId()
	local skipWaitingForPurchaseResult = v5.getPurchaseFlowOptions().skipWaitingForPurchaseResult
	local promptState = v5.getPromptState()

	if promptState == PromptState.Error or promptState == PromptState.SubscriptionStatusPolling then
		if promptState == PromptState.Error and FFlagFixSignalFinishedOnError and engineFeature then
			MarketplaceService:signalPromptRobloxSubscriptionPurchaseFinished(
				robloxSubscriptionProductId,
				didTryPurchasing
			)
		end

		finalizeRobloxSubscriptionUpsellFlow(false)
	else
		v5.setPromptState(PromptState.SubscriptionPurchaseCompleted)

		if engineFeature then
			MarketplaceService:signalPromptRobloxSubscriptionPurchaseFinished(
				robloxSubscriptionProductId,
				didTryPurchasing
			)
		end

		if skipWaitingForPurchaseResult or not didTryPurchasing then
			finalizeRobloxSubscriptionUpsellFlow(false)
		else
			v5.setPromptState(PromptState.SubscriptionStatusPolling)
		end
	end
end

return completeRobloxSubscriptionUpsellFlow
