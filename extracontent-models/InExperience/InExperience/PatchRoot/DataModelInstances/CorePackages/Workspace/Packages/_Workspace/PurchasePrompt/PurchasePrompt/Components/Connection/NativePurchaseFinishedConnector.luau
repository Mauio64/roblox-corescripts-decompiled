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
local FFlagLuaAppEnableNativePurchaseFinishedV2Signals = require(PurchasePrompt.Parent.SharedFlags).FFlagLuaAppEnableNativePurchaseFinishedV2Signals

local function NativePurchaseFinishedConnector(p1) -- line: 30
	-- upvalues: Roact (copy), ExternalEventConnection (copy), MarketplaceService (copy), FFlagLuaAppEnableNativePurchaseFinishedV2Signals (copy)
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
			}),
			NativePurchaseV2 = if not FFlagLuaAppEnableNativePurchaseFinishedV2Signals then nil else Roact.createElement(ExternalEventConnection, {
				event = MarketplaceService.NativePurchaseFinishedV2,
				callback = nativePurchaseFinished
			}),
			NativePurchaseWithLocalPlayerV2 = if not FFlagLuaAppEnableNativePurchaseFinishedV2Signals then nil else Roact.createElement(ExternalEventConnection, {
				event = MarketplaceService.NativePurchaseFinishedWithLocalPlayerV2,
				callback = nativePurchaseFinishedWithLocalPlayer
			})
		})
	end

	if FFlagLuaAppEnableNativePurchaseFinishedV2Signals then
		return Roact.createFragment({
			NativePurchase = Roact.createElement(ExternalEventConnection, {
				event = MarketplaceService.NativePurchaseFinished,
				callback = nativePurchaseFinished
			}),
			NativePurchaseV2 = Roact.createElement(ExternalEventConnection, {
				event = MarketplaceService.NativePurchaseFinishedV2,
				callback = nativePurchaseFinished
			})
		})
	end

	return Roact.createElement(ExternalEventConnection, {
		event = MarketplaceService.NativePurchaseFinished,
		callback = nativePurchaseFinished
	})
end
local function mapDispatchToProps(p2) -- line: 78
	-- upvalues: retryAfterUpsell (copy), FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal (copy), handleNativePurchaseFailureOrCancel (copy), ErrorOccurred (copy), PurchaseError (copy), sendCounter (copy), Counter (copy)
	return {
		nativePurchaseFinished = function(_, _, p5, _) -- line: 80
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
		nativePurchaseFinishedWithLocalPlayer = function(_, p8, _) -- line: 92
			-- upvalues: p2 (copy), retryAfterUpsell (copy), FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal (copy), handleNativePurchaseFailureOrCancel (copy), ErrorOccurred (copy), PurchaseError (copy), sendCounter (copy), Counter (copy)
			if p8 then
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
