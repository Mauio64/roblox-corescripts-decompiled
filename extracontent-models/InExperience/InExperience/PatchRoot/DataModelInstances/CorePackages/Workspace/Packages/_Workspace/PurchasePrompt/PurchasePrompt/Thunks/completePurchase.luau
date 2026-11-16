local parent = script.Parent.Parent
local Workspace = game:GetService("Workspace")

require(parent.types)

local SetPromptState = require(parent.Actions.SetPromptState)
local PurchaseCompleteRecieved = require(parent.Actions.PurchaseCompleteRecieved)
local PromptState = require(parent.Enums.PromptState)
local Thunk = require(parent.Thunk)
local completeRequest = require(parent.Thunks.completeRequest)
local SharedFlags = require(parent.Parent.SharedFlags)
local FFlagSkipCompletionModalForMarketplace = SharedFlags.FFlagSkipCompletionModalForMarketplace
local logUnifiedPurchaseTelemetryCounter = require(parent.Utils.logUnifiedPurchaseTelemetryCounter)
local UnifiedPurchaseTelemetry = require(parent.Events.UnifiedPurchaseTelemetry)
local sendUnifiedPurchaseEventLog = require(parent.Utils.sendUnifiedPurchaseEventLog)
local UnifiedPurchaseEventNameEnum = require(parent.Enums.UnifiedPurchaseEventNameEnum)
local getFeatureKeyForSurface = require(parent.Utils.getFeatureKeyForSurface)
local FFlagRefetchBothOfferKeysAfterPurchase = require(parent.Flags.FFlagRefetchBothOfferKeysAfterPurchase)
local InExperienceOffers = require(parent.Parent.InExperienceOffers)

local function completePurchase(p)
	return Thunk.new(script.Name, {}, function(object, _)
		local purchasingStartTime = object:getState().purchasingStartTime
		local v = Workspace.DistributedGameTime - purchasingStartTime

		object:dispatch(PurchaseCompleteRecieved())

		object:flush()

		local purchaseAnalyticsMetadata = object:getState().purchaseAnalyticsMetadata

		if purchaseAnalyticsMetadata then
			local offersStore = InExperienceOffers.getOffersStore(false)
			local offers = offersStore.getOffers(false)
			local featureKeys = InExperienceOffers.FeatureKeys
			local getOffersForKey = InExperienceOffers.Utils.getOffersForKey

			if FFlagRefetchBothOfferKeysAfterPurchase then
				local v2 = { featureKeys.RobloxShop, featureKeys.DeveloperShop }

				if InExperienceOffers.Utils.hasOfferForAnyKey(offers, v2) then
					offersStore.fetchOffers(v2)
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
				for _, postPurchaseAction in ipairs(postPurchaseActions) do
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
				state.purchaseCallbacks.onPurchaseSuccess(p, postPurchaseActionsState)
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

		if FFlagSkipCompletionModalForMarketplace then
			local purchaseOptions = object:getState().purchaseOptions

			if purchaseOptions and purchaseOptions.skipPurchaseSuccessModal then
				object:dispatch(SetPromptState(PromptState.PurchaseComplete))
				return object:dispatch(completeRequest())
			end
		end

		if v >= 1 then
			return object:dispatch(SetPromptState(PromptState.PurchaseComplete))
		end

		delay(1 - v, function()
			return object:dispatch(SetPromptState(PromptState.PurchaseComplete))
		end)
	end)
end

return completePurchase
