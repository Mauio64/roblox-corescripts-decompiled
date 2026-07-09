local Parent = script:FindFirstAncestor("PurchasePrompt").Parent

require(Parent.RobloxSubscriptionPurchaseApp)

return require(script.Parent.makeActionCreator)(script.Name, "robloxSubscriptionProducts")
