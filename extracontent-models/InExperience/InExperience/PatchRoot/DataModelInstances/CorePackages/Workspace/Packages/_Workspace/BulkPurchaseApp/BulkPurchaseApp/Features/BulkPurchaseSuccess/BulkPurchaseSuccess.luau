local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local parent = BulkPurchaseApp.Parent
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local AlertPrompt = require(BulkPurchaseApp.Components.AlertPrompt)

local function BulkPurchaseSuccess(p)
	local v = useLocalization({
		title = "CoreScripts.BulkPurchasePrompt.SuccessPrompt.Heading",
		bodyText = "CoreScripts.BulkPurchasePrompt.SuccessPrompt.Body",
		dismissCTA = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.DismissCTA"
	})

	return React.createElement(AlertPrompt, {
		title = v.title,
		bodyText = v.bodyText:gsub("{.*}", (tostring(p.itemCount))),
		dismissCTA = v.dismissCTA,
		onDismiss = p.onDismiss
	})
end

return BulkPurchaseSuccess
