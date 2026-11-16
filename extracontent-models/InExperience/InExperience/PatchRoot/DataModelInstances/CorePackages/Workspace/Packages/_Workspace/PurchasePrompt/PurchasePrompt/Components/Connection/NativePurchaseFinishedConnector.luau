local MarketplaceService = game:GetService("MarketplaceService")
local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Roact = PurchasePromptDeps.Roact

local retryAfterUpsell = require(PurchasePrompt.Thunks.retryAfterUpsell)
local connectToStore = require(PurchasePrompt.connectToStore)

local handleNativePurchaseFailureOrCancel = require(PurchasePrompt.Thunks.handleNativePurchaseFailureOrCancel)
local ExternalEventConnection = require(script.Parent.ExternalEventConnection)

local SharedFlags = require(PurchasePrompt.Parent.SharedFlags)
local FFlagLuaAppEnableNativePurchaseFinishedV2Signals = SharedFlags.FFlagLuaAppEnableNativePurchaseFinishedV2Signals

local function NativePurchaseFinishedConnector(p)
	local nativePurchaseFinished = p.nativePurchaseFinished
	local nativePurchaseFinishedWithLocalPlayer = p.nativePurchaseFinishedWithLocalPlayer

	if game:GetEngineFeature("NativePurchaseWithLocalPlayer") then
		local createFragment = Roact.createFragment
		local v = {
			NativePurchase = Roact.createElement(ExternalEventConnection, {
				event = MarketplaceService.NativePurchaseFinished,
				callback = nativePurchaseFinished
			}),
			NativePurchaseWithLocalPlayer = Roact.createElement(ExternalEventConnection, {
				event = MarketplaceService.NativePurchaseFinishedWithLocalPlayer,
				callback = nativePurchaseFinishedWithLocalPlayer
			}),
			NativePurchaseV2 = 0,
			NativePurchaseWithLocalPlayerV2 = 0
		}
		local nativePurchaseV

		if FFlagLuaAppEnableNativePurchaseFinishedV2Signals then
			nativePurchaseV = Roact.createElement(ExternalEventConnection, {
				event = MarketplaceService.NativePurchaseFinishedV2,
				callback = nativePurchaseFinished
			})
		end

		v.NativePurchaseV2 = nativePurchaseV
		local nativePurchaseWithLocalPlayerV

		if FFlagLuaAppEnableNativePurchaseFinishedV2Signals then
			nativePurchaseWithLocalPlayerV = Roact.createElement(ExternalEventConnection, {
				event = MarketplaceService.NativePurchaseFinishedWithLocalPlayerV2,
				callback = nativePurchaseFinishedWithLocalPlayer
			})
		end

		v.NativePurchaseWithLocalPlayerV2 = nativePurchaseWithLocalPlayerV
		return createFragment(v)
	elseif FFlagLuaAppEnableNativePurchaseFinishedV2Signals then
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
	else
		return Roact.createElement(ExternalEventConnection, {
			event = MarketplaceService.NativePurchaseFinished,
			callback = nativePurchaseFinished
		})
	end
end

local function mapDispatchToProps(callback)
	return {
		nativePurchaseFinished = function(_, _, p, _)
			if p then
				callback(retryAfterUpsell())
			else
				callback(handleNativePurchaseFailureOrCancel())
			end
		end,
		nativePurchaseFinishedWithLocalPlayer = function(_, p, _)
			if p then
				callback(retryAfterUpsell())
			else
				callback(handleNativePurchaseFailureOrCancel())
			end
		end
	}
end

return (connectToStore(nil, mapDispatchToProps)(NativePurchaseFinishedConnector))
