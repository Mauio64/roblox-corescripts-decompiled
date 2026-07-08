local ParentParent = script.Parent.Parent
local Workspace = game:GetService("Workspace")

require(ParentParent.types)

local SetPromptState = require(ParentParent.Actions.SetPromptState)
local PurchaseCompleteRecieved = require(ParentParent.Actions.PurchaseCompleteRecieved)
local PromptState = require(ParentParent.Enums.PromptState)
local Thunk = require(ParentParent.Thunk)
local completeRequest = require(ParentParent.Thunks.completeRequest)
local FFlagEnableUnifiedProductPurchaseFlow = require(ParentParent.Parent.SharedFlags).FFlagEnableUnifiedProductPurchaseFlow
local FFlagSkipCompletionModalForMarketplace = require(ParentParent.Parent.SharedFlags).FFlagSkipCompletionModalForMarketplace
local logUnifiedPurchaseTelemetryCounter = require(ParentParent.Utils.logUnifiedPurchaseTelemetryCounter)
local UnifiedPurchaseTelemetry = require(ParentParent.Events.UnifiedPurchaseTelemetry)
local sendUnifiedPurchaseEventLog = require(ParentParent.Utils.sendUnifiedPurchaseEventLog)
local UnifiedPurchaseEventNameEnum = require(ParentParent.Enums.UnifiedPurchaseEventNameEnum)

local function completePurchase(p1) -- line: 30
	-- upvalues: Thunk (copy), Workspace (copy), PurchaseCompleteRecieved (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), logUnifiedPurchaseTelemetryCounter (copy), UnifiedPurchaseTelemetry (copy), sendUnifiedPurchaseEventLog (copy), UnifiedPurchaseEventNameEnum (copy), FFlagSkipCompletionModalForMarketplace (copy), SetPromptState (copy), PromptState (copy), completeRequest (copy)
	return Thunk.new(script.Name, {}, function(p2, _) -- line: 31
		-- upvalues: Workspace (copy), PurchaseCompleteRecieved (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), p1 (copy), logUnifiedPurchaseTelemetryCounter (copy), UnifiedPurchaseTelemetry (copy), sendUnifiedPurchaseEventLog (copy), UnifiedPurchaseEventNameEnum (copy), FFlagSkipCompletionModalForMarketplace (copy), SetPromptState (copy), PromptState (copy), completeRequest (copy)
		local purchasingStartTime = p2:getState().purchasingStartTime
		local v19 = Workspace.DistributedGameTime - purchasingStartTime

		p2:dispatch(PurchaseCompleteRecieved())

		if FFlagEnableUnifiedProductPurchaseFlow and p2:getState().isUserEligibleForUnifiedPurchaseFlow then
			local v20 = p2:getState()
			local postPurchaseActions = v20.postPurchaseActions
			local v22 = v20.postPurchaseActionsState or {}

			if postPurchaseActions then
				for _, v in ipairs(postPurchaseActions) do
					if v and v.actionKey and v.isActionSelected ~= nil then
						v22[v.actionKey] = v.isActionSelected
					end
				end
			end

			if v20.purchaseCallbacks and v20.purchaseCallbacks.onPurchaseSuccess then
				v20.purchaseCallbacks.onPurchaseSuccess(p1, v22)
			end

			if v20.purchaseAnalyticsMetadata then
				local purchaseAnalyticsMetadata = v20.purchaseAnalyticsMetadata

				logUnifiedPurchaseTelemetryCounter(UnifiedPurchaseTelemetry.UnifiedProductPurchaseModalPurchaseSuccessCounter, purchaseAnalyticsMetadata.surface, purchaseAnalyticsMetadata.productType)
				sendUnifiedPurchaseEventLog({
					event_name = UnifiedPurchaseEventNameEnum.ItemPurchaseSuccess,
					purchase_flow_uuid = purchaseAnalyticsMetadata.purchaseFlowUUID,
					product_id = purchaseAnalyticsMetadata.productId,
					product_type = purchaseAnalyticsMetadata.productType,
					product_target_id = purchaseAnalyticsMetadata.productTargetId,
					robux_price = purchaseAnalyticsMetadata.price,
					surface = purchaseAnalyticsMetadata.surface,
					user_roblox_balance = purchaseAnalyticsMetadata.userRobuxBalance,
					salelocation_universeid = purchaseAnalyticsMetadata.saleLocationUniverseId
				})
			end
		end

		if FFlagSkipCompletionModalForMarketplace then
			local purchaseOptions = p2:getState().purchaseOptions

			if purchaseOptions and purchaseOptions.skipPurchaseSuccessModal then
				p2:dispatch(SetPromptState(PromptState.PurchaseComplete))

				return p2:dispatch(completeRequest())
			end
		end

		if v19 >= 1 then
			return p2:dispatch(SetPromptState(PromptState.PurchaseComplete))
		end

		delay(1 - v19, function() -- line: 87
			-- upvalues: p2 (copy), SetPromptState (copy), PromptState (copy)
			return p2:dispatch(SetPromptState(PromptState.PurchaseComplete))
		end)
	end)
end

return completePurchase
