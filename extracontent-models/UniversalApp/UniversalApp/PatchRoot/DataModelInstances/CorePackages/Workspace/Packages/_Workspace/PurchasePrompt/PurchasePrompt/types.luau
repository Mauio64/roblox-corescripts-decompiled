local Parent = script:FindFirstAncestor("PurchasePrompt").Parent

require(Parent.IAPExperience)

local PurchasePromptLite = require(Parent.PurchasePromptLite)

require(Parent.LuauPolyfill)

return {
	ProductTypeEnum = PurchasePromptLite.Enums.ProductKind
}
