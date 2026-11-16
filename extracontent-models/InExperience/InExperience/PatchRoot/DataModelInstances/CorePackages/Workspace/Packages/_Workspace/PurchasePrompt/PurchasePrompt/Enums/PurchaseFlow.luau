local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local enumerate = PurchasePromptDeps.enumerate

local addRawValueMethodToEnum = require(PurchasePrompt.Utils.addRawValueMethodToEnum)

local v = {
	None = "None",
	Product = "Product",
	RobuxUpsell = "RobuxUpsell",
	RobuxUpsellV2 = "RobuxUpsellV2",
	LargeRobuxUpsell = "LargeRobuxUpsell"
}

local v2 = enumerate(script.Name, v)

addRawValueMethodToEnum(v2, v)

return v2
