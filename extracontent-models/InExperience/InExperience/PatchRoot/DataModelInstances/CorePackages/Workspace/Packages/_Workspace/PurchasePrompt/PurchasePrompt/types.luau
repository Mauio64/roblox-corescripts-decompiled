local parent = script:FindFirstAncestor("PurchasePrompt").Parent
require(parent.IAPExperience)
local PurchasePromptLite = require(parent.PurchasePromptLite)
require(parent.LuauPolyfill)

return { ProductTypeEnum = PurchasePromptLite.Enums.ProductKind }
