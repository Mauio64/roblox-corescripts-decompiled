local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local GuiService = game:GetService("GuiService")
local Roact = require(PurchasePromptParent.PurchasePromptDeps).Roact
local retryAfterUpsell = require(PurchasePrompt.Thunks.retryAfterUpsell)
local connectToStore = require(PurchasePrompt.connectToStore)
local ExternalEventConnection = require(script.Parent.ExternalEventConnection)

local function BrowserPurchaseFinishedConnector(p1) -- line: 17
	-- upvalues: Roact (copy), ExternalEventConnection (copy), GuiService (copy)
	local onBrowserWindowClosed = p1.onBrowserWindowClosed

	return Roact.createElement(ExternalEventConnection, {
		event = GuiService.BrowserWindowClosed,
		callback = onBrowserWindowClosed
	})
end
local function mapDispatchToProps(p2) -- line: 31
	-- upvalues: retryAfterUpsell (copy)
	return {
		onBrowserWindowClosed = function() -- line: 33
			-- upvalues: p2 (copy), retryAfterUpsell (copy)
			p2(retryAfterUpsell())
		end
	}
end

return (connectToStore(nil, mapDispatchToProps)(BrowserPurchaseFinishedConnector))
