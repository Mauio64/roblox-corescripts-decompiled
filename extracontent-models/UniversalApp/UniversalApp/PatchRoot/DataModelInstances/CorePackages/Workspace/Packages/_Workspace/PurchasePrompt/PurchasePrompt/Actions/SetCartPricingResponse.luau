local Parent = script:FindFirstAncestor("PurchasePrompt").Parent

require(Parent.IAPExperience)

return require(script.Parent.makeActionCreator)(script.Name, "response")
