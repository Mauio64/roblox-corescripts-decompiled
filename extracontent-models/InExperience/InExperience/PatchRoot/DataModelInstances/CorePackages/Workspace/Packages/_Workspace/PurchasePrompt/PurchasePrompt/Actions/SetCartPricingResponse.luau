local parent = script:FindFirstAncestor("PurchasePrompt").Parent

require(parent.IAPExperience)

local makeActionCreator = require(script.Parent.makeActionCreator)

return makeActionCreator(script.Name, "response")
