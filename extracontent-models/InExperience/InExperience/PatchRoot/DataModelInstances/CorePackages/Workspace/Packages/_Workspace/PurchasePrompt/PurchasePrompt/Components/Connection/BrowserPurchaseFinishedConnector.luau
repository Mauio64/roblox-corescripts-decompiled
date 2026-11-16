local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local GuiService = game:GetService("GuiService")

local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Roact = PurchasePromptDeps.Roact

local retryAfterUpsell = require(PurchasePrompt.Thunks.retryAfterUpsell)
local connectToStore = require(PurchasePrompt.connectToStore)

local ExternalEventConnection = require(script.Parent.ExternalEventConnection)

local function BrowserPurchaseFinishedConnector(p)
	local onBrowserWindowClosed = p.onBrowserWindowClosed

	return Roact.createElement(ExternalEventConnection, {
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
