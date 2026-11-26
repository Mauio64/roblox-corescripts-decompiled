local MarketplaceService = game:GetService("MarketplaceService")

local roact = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").Roact

local retryAfterUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/retryAfterUpsell")
local connectToStore = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/connectToStore")

local handleNativePurchaseFailureOrCancel = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/handleNativePurchaseFailureOrCancel")
local ExternalEventConnection = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/Connection/ExternalEventConnection")

local fFlagLuaAppEnableNativePurchaseFinishedV2Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagLuaAppEnableNativePurchaseFinishedV2Signals

local function NativePurchaseFinishedConnector(p2)
	local nativePurchaseFinished = p2.nativePurchaseFinished
	local nativePurchaseFinishedWithLocalPlayer = p2.nativePurchaseFinishedWithLocalPlayer

	if game:GetEngineFeature("NativePurchaseWithLocalPlayer") then
		local createFragment = roact.createFragment
		local v5 = {
			NativePurchase = roact.createElement(ExternalEventConnection, {
				event = MarketplaceService.NativePurchaseFinished,
				callback = nativePurchaseFinished
			}),
			NativePurchaseWithLocalPlayer = roact.createElement(ExternalEventConnection, {
				event = MarketplaceService.NativePurchaseFinishedWithLocalPlayer,
				callback = nativePurchaseFinishedWithLocalPlayer
			}),
			NativePurchaseV2 = 0,
			NativePurchaseWithLocalPlayerV2 = 0
		}

		local v6 = if fFlagLuaAppEnableNativePurchaseFinishedV2Signals then roact.createElement(ExternalEventConnection, {
			event = MarketplaceService.NativePurchaseFinishedV2,
			callback = nativePurchaseFinished
		}) else nil
		v5.NativePurchaseV2 = v6

		local v7 = if fFlagLuaAppEnableNativePurchaseFinishedV2Signals then roact.createElement(ExternalEventConnection, {
			event = MarketplaceService.NativePurchaseFinishedWithLocalPlayerV2,
			callback = nativePurchaseFinishedWithLocalPlayer
		}) else nil
		v5.NativePurchaseWithLocalPlayerV2 = v7
		return createFragment(v5)
	elseif fFlagLuaAppEnableNativePurchaseFinishedV2Signals then
		return roact.createFragment({
			NativePurchase = roact.createElement(ExternalEventConnection, {
				event = MarketplaceService.NativePurchaseFinished,
				callback = nativePurchaseFinished
			}),
			NativePurchaseV2 = roact.createElement(ExternalEventConnection, {
				event = MarketplaceService.NativePurchaseFinishedV2,
				callback = nativePurchaseFinished
			})
		})
	else
		return roact.createElement(ExternalEventConnection, {
			event = MarketplaceService.NativePurchaseFinished,
			callback = nativePurchaseFinished
		})
	end
end

local function mapDispatchToProps(callback)
	return {
		nativePurchaseFinished = function(p2, p3, p4, p5)
			if p4 then
				callback(retryAfterUpsell())
			else
				callback(handleNativePurchaseFailureOrCancel())
			end
		end,
		nativePurchaseFinishedWithLocalPlayer = function(p2, p3, p4)
			if p3 then
				callback(retryAfterUpsell())
			else
				callback(handleNativePurchaseFailureOrCancel())
			end
		end
	}
end

return (connectToStore(nil, mapDispatchToProps)(NativePurchaseFinishedConnector))
