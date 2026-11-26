local GuiService = game:GetService("GuiService")

local roact = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").Roact

local retryAfterUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/retryAfterUpsell")
local connectToStore = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/connectToStore")

local ExternalEventConnection = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Components/Connection/ExternalEventConnection")

local function BrowserPurchaseFinishedConnector(p2)
	local onBrowserWindowClosed = p2.onBrowserWindowClosed

	return roact.createElement(ExternalEventConnection, {
		event = GuiService.BrowserWindowClosed,
		callback = onBrowserWindowClosed
	})
end

local function mapDispatchToProps(callback)
	return {
		onBrowserWindowClosed = function()
			callback(retryAfterUpsell())
		end
	}
end

return (connectToStore(nil, mapDispatchToProps)(BrowserPurchaseFinishedConnector))
