local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local CompleteRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/CompleteRequest")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PromptState")
local RequestType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/RequestType")
local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")

local SelectedRobuxPackage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/SelectedRobuxPackage")

local Counter = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/Counter")
local sendCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/sendCounter")

local Analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Analytics")
local PublicBindables = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/PublicBindables")
local Thunk = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunk")

local fFlagEnableUnifiedPurchaseFlowForDevSubs = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagEnableUnifiedPurchaseFlowForDevSubs

local v5 = { Analytics, PublicBindables }

local function completeRequest()
	return Thunk.new("completeRequest", v5, function(object, p2)
		local v6 = p2[Analytics]
		local state = object:getState()
		local requestType = state.promptRequest.requestType
		local purchaseError = state.purchaseError
		local id = state.promptRequest.id
		local hasCompletedPurchase = state.hasCompletedPurchase

		local robuxProductId = SelectedRobuxPackage.getRobuxProductId(state)
		local productId = state.productInfo and state.productInfo.productId

		if state.promptState == PromptState.U13PaymentModal then
			v6.signalScaryModalCanceled(productId, "U13PaymentModal", robuxProductId)
		elseif state.promptState == PromptState.U13MonthlyThreshold1Modal then
			v6.signalScaryModalCanceled(productId, "U13MonthlyThreshold1Modal", robuxProductId)
		elseif state.promptState == PromptState.U13MonthlyThreshold2Modal then
			v6.signalScaryModalCanceled(productId, "U13MonthlyThreshold2Modal", robuxProductId)
		elseif state.promptState == PromptState.ParentalConsentWarningPaymentModal13To17 then
			v6.signalScaryModalCanceled(
				productId,
				"ParentalConsentWarningPaymentModal13To17",
				robuxProductId
			)
		end

		if state.promptState == PromptState.PurchaseComplete then
			object:dispatch(sendCounter(Counter.Success))
		elseif state.promptState == PromptState.Error then
			object:dispatch(sendCounter(Counter.Failed))
		else
			object:dispatch(sendCounter(Counter.Cancelled))
		end

		if requestType == RequestType.Product then
			MarketplaceService:SignalPromptProductPurchaseFinished(
				Players.LocalPlayer.UserId,
				id,
				hasCompletedPurchase
			)
		elseif requestType == RequestType.GamePass then
			MarketplaceService:SignalPromptGamePassPurchaseFinished(
				Players.LocalPlayer,
				id,
				hasCompletedPurchase
			)
		elseif requestType == RequestType.Bundle then
			MarketplaceService:SignalPromptBundlePurchaseFinished(
				Players.LocalPlayer,
				id,
				hasCompletedPurchase
			)
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
		elseif
			fFlagEnableUnifiedPurchaseFlowForDevSubs
			and requestType == RequestType.DeveloperSubscription
		then
			MarketplaceService:SignalPromptSubscriptionPurchaseFinished(
				state.promptRequest.subscriptionId,
				hasCompletedPurchase or purchaseError == PurchaseError.AlreadySubscribed
			)
		end

		local windowStateChangedBindable = p2[PublicBindables].getWindowStateChangedBindable()

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
