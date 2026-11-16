local parent = script.Parent.Parent
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local CoreGui = game:GetService("CoreGui")

CoreGui:WaitForChild("RobloxGui")

local CompleteRequest = require(parent.Actions.CompleteRequest)
local PromptState = require(parent.Enums.PromptState)
local RequestType = require(parent.Enums.RequestType)
local PurchaseError = require(parent.Enums.PurchaseError)

local SelectedRobuxPackage = require(parent.Utils.SelectedRobuxPackage)

local Counter = require(parent.Enums.Counter)
local sendCounter = require(parent.Thunks.sendCounter)

local Analytics = require(parent.Services.Analytics)
local PublicBindables = require(parent.Services.PublicBindables)
local Thunk = require(parent.Thunk)

local SharedFlags = require(parent.Parent.SharedFlags)
local FFlagEnableUnifiedPurchaseFlowForDevSubs = SharedFlags.FFlagEnableUnifiedPurchaseFlowForDevSubs

local v = { Analytics, PublicBindables }

local function completeRequest()
	return Thunk.new(script.Name, v, function(object, p)
		local v2 = p[Analytics]
		local state = object:getState()
		local requestType = state.promptRequest.requestType
		local purchaseError = state.purchaseError
		local id = state.promptRequest.id
		local hasCompletedPurchase = state.hasCompletedPurchase

		local robuxProductId = SelectedRobuxPackage.getRobuxProductId(state)
		local productId = state.productInfo and state.productInfo.productId

		if state.promptState == PromptState.U13PaymentModal then
			v2.signalScaryModalCanceled(productId, "U13PaymentModal", robuxProductId)
		elseif state.promptState == PromptState.U13MonthlyThreshold1Modal then
			v2.signalScaryModalCanceled(productId, "U13MonthlyThreshold1Modal", robuxProductId)
		elseif state.promptState == PromptState.U13MonthlyThreshold2Modal then
			v2.signalScaryModalCanceled(productId, "U13MonthlyThreshold2Modal", robuxProductId)
		elseif state.promptState == PromptState.ParentalConsentWarningPaymentModal13To17 then
			v2.signalScaryModalCanceled(productId, "ParentalConsentWarningPaymentModal13To17", robuxProductId)
		end

		if state.promptState == PromptState.PurchaseComplete then
			object:dispatch(sendCounter(Counter.Success))
		elseif state.promptState == PromptState.Error then
			object:dispatch(sendCounter(Counter.Failed))
		else
			object:dispatch(sendCounter(Counter.Cancelled))
		end

		if requestType == RequestType.Product then
			MarketplaceService:SignalPromptProductPurchaseFinished(Players.LocalPlayer.UserId, id, hasCompletedPurchase)
		elseif requestType == RequestType.GamePass then
			MarketplaceService:SignalPromptGamePassPurchaseFinished(Players.LocalPlayer, id, hasCompletedPurchase)
		elseif requestType == RequestType.Bundle then
			MarketplaceService:SignalPromptBundlePurchaseFinished(Players.LocalPlayer, id, hasCompletedPurchase)
		elseif requestType == RequestType.Asset then
			MarketplaceService:SignalPromptPurchaseFinished(Players.LocalPlayer, id, hasCompletedPurchase)

			local assetTypeId = state.productInfo.assetTypeId

			if hasCompletedPurchase and assetTypeId then
				pcall(function()
					MarketplaceService:SignalAssetTypePurchased(Players.LocalPlayer, assetTypeId)
				end)
			end
		elseif requestType == RequestType.Subscription then
			MarketplaceService:SignalPromptSubscriptionPurchaseFinished(
				id,
				hasCompletedPurchase or purchaseError == PurchaseError.AlreadySubscribed
			)
		elseif FFlagEnableUnifiedPurchaseFlowForDevSubs and requestType == RequestType.DeveloperSubscription then
			MarketplaceService:SignalPromptSubscriptionPurchaseFinished(
				state.promptRequest.subscriptionId,
				hasCompletedPurchase or purchaseError == PurchaseError.AlreadySubscribed
			)
		end

		local windowStateChangedBindable = p[PublicBindables].getWindowStateChangedBindable()

		if windowStateChangedBindable then
			windowStateChangedBindable:Fire({
				isShown = false,
				hasCompletedPurchase = hasCompletedPurchase
			})
		end

		if state.purchaseCallbacks.onFlowComplete then
			state.purchaseCallbacks.onFlowComplete()
		end

		return object:dispatch(CompleteRequest())
	end)
end

return completeRequest
