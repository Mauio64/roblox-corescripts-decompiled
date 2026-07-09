local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local React = require(BulkPurchaseAppParent.React)
local useLocalization = require(BulkPurchaseAppParent.Localization).Hooks.useLocalization
local AlertPrompt = require(BulkPurchaseApp.Components.AlertPrompt)

local function BulkPurchaseSuccess(t1: {[any]: any}) -- line: 13
	-- upvalues: useLocalization (copy), React (copy), AlertPrompt (copy)
	local v8 = useLocalization({
		title = "CoreScripts.BulkPurchasePrompt.SuccessPrompt.Heading",
		bodyText = "CoreScripts.BulkPurchasePrompt.SuccessPrompt.Body",
		dismissCTA = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.DismissCTA"
	})

	return React.createElement(AlertPrompt, {
		title = v8.title,
		bodyText = v8.bodyText:gsub("{.*}", (tostring(t1.itemCount))),
		dismissCTA = v8.dismissCTA,
		onDismiss = t1.onDismiss
	})
end

return BulkPurchaseSuccess
