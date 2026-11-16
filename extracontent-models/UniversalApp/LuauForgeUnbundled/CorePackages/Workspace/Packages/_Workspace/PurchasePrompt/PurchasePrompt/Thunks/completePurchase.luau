local Workspace = game:GetService("Workspace")

require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")

local SetPromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPromptState")
local PurchaseCompleteRecieved = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/PurchaseCompleteRecieved")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PromptState")
local Thunk = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunk")
local completeRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/completeRequest")
local fFlagSkipCompletionModalForMarketplace = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagSkipCompletionModalForMarketplace
local logUnifiedPurchaseTelemetryCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/logUnifiedPurchaseTelemetryCounter")
local UnifiedPurchaseTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Events/UnifiedPurchaseTelemetry")
local sendUnifiedPurchaseEventLog = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/sendUnifiedPurchaseEventLog")
local UnifiedPurchaseEventNameEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/UnifiedPurchaseEventNameEnum")
local getFeatureKeyForSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getFeatureKeyForSurface")
local FFlagRefetchBothOfferKeysAfterPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagRefetchBothOfferKeysAfterPurchase")
local InExperienceOffers = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/InExperienceOffers")

local function completePurchase(p2)
	return Thunk.new("completePurchase", {}, function(object, p3)
		local purchasingStartTime = object:getState().purchasingStartTime
		local v5 = Workspace.DistributedGameTime - purchasingStartTime

		object:dispatch(PurchaseCompleteRecieved())

		object:flush()

		local purchaseAnalyticsMetadata = object:getState().purchaseAnalyticsMetadata

		if purchaseAnalyticsMetadata then
			local offersStore = InExperienceOffers.getOffersStore(false)
			local offers = offersStore.getOffers(false)
			local featureKeys = InExperienceOffers.FeatureKeys
			local getOffersForKey = InExperienceOffers.Utils.getOffersForKey

			if FFlagRefetchBothOfferKeysAfterPurchase then
				local v6 = { featureKeys.RobloxShop, featureKeys.DeveloperShop }

				if InExperienceOffers.Utils.hasOfferForAnyKey(offers, v6) then
					offersStore.fetchOffers(v6)
				end
			elseif getFeatureKeyForSurface(purchaseAnalyticsMetadata.surface) == featureKeys.RobloxShop then
				if getOffersForKey(offers, featureKeys.RobloxShop) ~= nil then
					offersStore.fetchOffers({ featureKeys.RobloxShop })
				end
			elseif getOffersForKey(offers, featureKeys.DeveloperShop) ~= nil then
				offersStore.fetchOffers({ featureKeys.DeveloperShop })
			end
		end

		if object:getState().isUserEligibleForUnifiedPurchaseFlow then
			local state = object:getState()
			local postPurchaseActions = state.postPurchaseActions
			local postPurchaseActionsState = state.postPurchaseActionsState or {}

			if postPurchaseActions then
				for i, postPurchaseAction in ipairs(postPurchaseActions) do
					if
						postPurchaseAction
						and postPurchaseAction.actionKey
						and postPurchaseAction.isActionSelected ~= nil
					then
						postPurchaseActionsState[postPurchaseAction.actionKey] = postPurchaseAction.isActionSelected
					end
				end
			end

			if state.purchaseCallbacks and state.purchaseCallbacks.onPurchaseSuccess then
				state.purchaseCallbacks.onPurchaseSuccess(p2, postPurchaseActionsState)
			end

			if state.purchaseAnalyticsMetadata then
				local purchaseAnalyticsMetadata2 = state.purchaseAnalyticsMetadata

				logUnifiedPurchaseTelemetryCounter(
					UnifiedPurchaseTelemetry.UnifiedProductPurchaseModalPurchaseSuccessCounter,
					purchaseAnalyticsMetadata2.surface,
					purchaseAnalyticsMetadata2.productType
				)

				sendUnifiedPurchaseEventLog({
					event_name = UnifiedPurchaseEventNameEnum.ItemPurchaseSuccess,
					purchase_flow_uuid = purchaseAnalyticsMetadata2.purchaseFlowUUID,
					product_id = purchaseAnalyticsMetadata2.productId,
					product_type = purchaseAnalyticsMetadata2.productType,
					product_target_id = purchaseAnalyticsMetadata2.productTargetId,
					robux_price = purchaseAnalyticsMetadata2.price,
					surface = purchaseAnalyticsMetadata2.surface,
					user_roblox_balance = purchaseAnalyticsMetadata2.userRobuxBalance,
					salelocation_universeid = purchaseAnalyticsMetadata2.saleLocationUniverseId
				})
			end
		end

		if fFlagSkipCompletionModalForMarketplace then
			local purchaseOptions = object:getState().purchaseOptions

			if purchaseOptions and purchaseOptions.skipPurchaseSuccessModal then
				object:dispatch(SetPromptState(PromptState.PurchaseComplete))
				return object:dispatch(completeRequest())
			end
		end

		if v5 >= 1 then
			return object:dispatch(SetPromptState(PromptState.PurchaseComplete))
		end

		delay(1 - v5, function()
			return object:dispatch(SetPromptState(PromptState.PurchaseComplete))
		end)
	end)
end

return completePurchase
