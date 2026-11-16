local enumerate = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").enumerate

local addRawValueMethodToEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/addRawValueMethodToEnum")

local v5 = {
	None = "None",
	Product = "Product",
	RobuxUpsell = "RobuxUpsell",
	RobuxUpsellV2 = "RobuxUpsellV2",
	LargeRobuxUpsell = "LargeRobuxUpsell"
}

local v6 = enumerate("PurchaseFlow", v5)

addRawValueMethodToEnum(v6, v5)

return v6
