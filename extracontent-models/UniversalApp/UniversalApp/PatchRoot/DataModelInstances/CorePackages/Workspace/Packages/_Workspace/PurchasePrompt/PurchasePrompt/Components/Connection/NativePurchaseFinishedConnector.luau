local MarketplaceService = game:GetService("MarketplaceService")
local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Roact = require(PurchasePromptParent.PurchasePromptDeps).Roact
local ErrorOccurred = require(PurchasePrompt.Actions.ErrorOccurred)
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local retryAfterUpsell = require(PurchasePrompt.Thunks.retryAfterUpsell)
local connectToStore = require(PurchasePrompt.connectToStore)
local Counter = require(PurchasePrompt.Enums.Counter)
local sendCounter = require(PurchasePrompt.Thunks.sendCounter)
local handleNativePurchaseFailureOrCancel = require(PurchasePrompt.Thunks.handleNativePurchaseFailureOrCancel)
local ExternalEventConnection = require(script.Parent.ExternalEventConnection)
local FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal = require(PurchasePrompt.Parent.SharedFlags).FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal

local function NativePurchaseFinishedConnector(p1) -- line: 28
	-- upvalues: Roact (copy), ExternalEventConnection (copy), MarketplaceService (copy)
	local nativePurchaseFinished = p1.nativePurchaseFinished
	local nativePurchaseFinishedWithLocalPlayer = p1.nativePurchaseFinishedWithLocalPlayer

	if game:GetEngineFeature("NativePurchaseWithLocalPlayer") then
		return Roact.createFragment({
			NativePurchase = Roact.createElement(ExternalEventConnection, {
				event = MarketplaceService.NativePurchaseFinished,
				callback = nativePurchaseFinished
			}),
			NativePurchaseWithLocalPlayer = Roact.createElement(ExternalEventConnection, {
				event = MarketplaceService.NativePurchaseFinishedWithLocalPlayer,
				callback = nativePurchaseFinishedWithLocalPlayer
			})
		})
	end

	return Roact.createElement(ExternalEventConnection, {
		event = MarketplaceService.NativePurchaseFinished,
		callback = nativePurchaseFinished
	})
end
local function mapDispatchToProps(p2) -- line: 51
	-- upvalues: retryAfterUpsell (copy), FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal (copy), handleNativePurchaseFailureOrCancel (copy), ErrorOccurred (copy), PurchaseError (copy), sendCounter (copy), Counter (copy)
	return {
		nativePurchaseFinished = function(_, _, p5) -- line: 53
			-- upvalues: p2 (copy), retryAfterUpsell (copy), FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal (copy), handleNativePurchaseFailureOrCancel (copy), ErrorOccurred (copy), PurchaseError (copy), sendCounter (copy), Counter (copy)
			if p5 then
				p2(retryAfterUpsell())

				return
			end

			if FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal then
				p2(handleNativePurchaseFailureOrCancel())

				return
			end

			p2(ErrorOccurred(PurchaseError.InvalidFundsUnknown))
			p2(sendCounter(Counter.UpsellFailedNativePurchase))
		end,
		nativePurchaseFinishedWithLocalPlayer = function(_, p7) -- line: 65
			-- upvalues: p2 (copy), retryAfterUpsell (copy), FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal (copy), handleNativePurchaseFailureOrCancel (copy), ErrorOccurred (copy), PurchaseError (copy), sendCounter (copy), Counter (copy)
			if p7 then
				p2(retryAfterUpsell())

				return
			end

			if FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal then
				p2(handleNativePurchaseFailureOrCancel())

				return
			end

			p2(ErrorOccurred(PurchaseError.InvalidFundsUnknown))
			p2(sendCounter(Counter.UpsellFailedNativePurchase))
		end
	}
end

return (connectToStore(nil, mapDispatchToProps)(NativePurchaseFinishedConnector))
