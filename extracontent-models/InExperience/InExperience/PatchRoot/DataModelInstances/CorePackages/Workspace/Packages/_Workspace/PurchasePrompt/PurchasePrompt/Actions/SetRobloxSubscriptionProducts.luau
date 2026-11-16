local parent = script:FindFirstAncestor("PurchasePrompt").Parent

require(parent.RobloxSubscriptionPurchaseApp)

local makeActionCreator = require(script.Parent.makeActionCreator)

return makeActionCreator(script.Name, "robloxSubscriptionProducts")
