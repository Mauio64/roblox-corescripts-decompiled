local ParentParent = script.Parent.Parent
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

game:GetService("CoreGui"):WaitForChild("RobloxGui")

local CompleteRequest = require(ParentParent.Actions.CompleteRequest)
local PromptState = require(ParentParent.Enums.PromptState)
local RequestType = require(ParentParent.Enums.RequestType)
local PurchaseError = require(ParentParent.Enums.PurchaseError)
local SelectedRobuxPackage = require(ParentParent.Utils.SelectedRobuxPackage)
local Counter = require(ParentParent.Enums.Counter)
local sendCounter = require(ParentParent.Thunks.sendCounter)
local Analytics = require(ParentParent.Services.Analytics)
local PublicBindables = require(ParentParent.Services.PublicBindables)
local Thunk = require(ParentParent.Thunk)
local FFlagEnableUnifiedProductPurchaseFlow = require(ParentParent.Parent.SharedFlags).FFlagEnableUnifiedProductPurchaseFlow
local FFlagEnableUnifiedPurchaseFlowForDevSubs = require(ParentParent.Parent.SharedFlags).FFlagEnableUnifiedPurchaseFlowForDevSubs
local t1 = {
	Analytics,
	PublicBindables
}

local function completeRequest() -- line: 31
	-- upvalues: Thunk (copy), t1 (copy), Analytics (copy), SelectedRobuxPackage (copy), PromptState (copy), sendCounter (copy), Counter (copy), RequestType (copy), Players (copy), MarketplaceService (copy), PurchaseError (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), PublicBindables (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), CompleteRequest (copy)
	return Thunk.new(script.Name, t1, function(p1, p2) -- line: 32
		-- upvalues: Analytics (copy), SelectedRobuxPackage (copy), PromptState (copy), sendCounter (copy), Counter (copy), RequestType (copy), Players (copy), MarketplaceService (copy), PurchaseError (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), PublicBindables (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), CompleteRequest (copy)
		local v20 = p2[Analytics]
		local v21 = p1:getState()
		local requestType = v21.promptRequest.requestType
		local purchaseError = v21.purchaseError
		local id = v21.promptRequest.id
		local hasCompletedPurchase = v21.hasCompletedPurchase
		local v26 = SelectedRobuxPackage.getRobuxProductId(v21)
		local v27 = v21.productInfo and v21.productInfo.productId

		if v21.promptState == PromptState.U13PaymentModal then
			v20.signalScaryModalCanceled(v27, "U13PaymentModal", v26)
		elseif v21.promptState == PromptState.U13MonthlyThreshold1Modal then
			v20.signalScaryModalCanceled(v27, "U13MonthlyThreshold1Modal", v26)
		elseif v21.promptState == PromptState.U13MonthlyThreshold2Modal then
			v20.signalScaryModalCanceled(v27, "U13MonthlyThreshold2Modal", v26)
		elseif v21.promptState == PromptState.ParentalConsentWarningPaymentModal13To17 then
			v20.signalScaryModalCanceled(v27, "ParentalConsentWarningPaymentModal13To17", v26)
		end

		if v21.promptState == PromptState.PurchaseComplete then
			p1:dispatch(sendCounter(Counter.Success))
		elseif v21.promptState == PromptState.Error then
			p1:dispatch(sendCounter(Counter.Failed))
		else
			p1:dispatch(sendCounter(Counter.Cancelled))
		end

		if requestType == RequestType.Product then
			local UserId = Players.LocalPlayer.UserId

			MarketplaceService:SignalPromptProductPurchaseFinished(UserId, id, hasCompletedPurchase)
		elseif requestType == RequestType.GamePass then
			MarketplaceService:SignalPromptGamePassPurchaseFinished(Players.LocalPlayer, id, hasCompletedPurchase)
		elseif requestType == RequestType.Bundle then
			MarketplaceService:SignalPromptBundlePurchaseFinished(Players.LocalPlayer, id, hasCompletedPurchase)
		elseif requestType == RequestType.Asset then
			MarketplaceService:SignalPromptPurchaseFinished(Players.LocalPlayer, id, hasCompletedPurchase)

			local assetTypeId = v21.productInfo.assetTypeId

			if hasCompletedPurchase and assetTypeId then
				pcall(function() -- line: 75
					-- upvalues: MarketplaceService (copy), Players (copy), assetTypeId (copy)
					MarketplaceService:SignalAssetTypePurchased(Players.LocalPlayer, assetTypeId)
				end)
			end
		elseif requestType == RequestType.Premium then
			MarketplaceService:SignalPromptPremiumPurchaseFinished(hasCompletedPurchase or purchaseError == PurchaseError.AlreadyPremium)
		elseif requestType == RequestType.Subscription then
			MarketplaceService:SignalPromptSubscriptionPurchaseFinished(id, hasCompletedPurchase or purchaseError == PurchaseError.AlreadySubscribed)
		elseif FFlagEnableUnifiedPurchaseFlowForDevSubs and requestType == RequestType.DeveloperSubscription then
			MarketplaceService:SignalPromptSubscriptionPurchaseFinished(v21.promptRequest.subscriptionId, hasCompletedPurchase or purchaseError == PurchaseError.AlreadySubscribed)
		end

		local v30 = p2[PublicBindables].getWindowStateChangedBindable()

		if v30 then
			v30:Fire({
				isShown = false,
				hasCompletedPurchase = hasCompletedPurchase
			})
		end

		if FFlagEnableUnifiedProductPurchaseFlow and v21.purchaseCallbacks.onFlowComplete then
			v21.purchaseCallbacks.onFlowComplete()
		end

		return p1:dispatch(CompleteRequest())
	end)
end

return completeRequest
