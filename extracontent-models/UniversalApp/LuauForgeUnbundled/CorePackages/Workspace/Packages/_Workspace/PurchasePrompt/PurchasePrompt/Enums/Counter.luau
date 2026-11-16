local enumerate = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").enumerate

local addRawValueMethodToEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/addRawValueMethodToEnum")

local v5 = {
	UpsellModalShown = "UpsellModalShown",
	UpsellModalShownAgain = "UpsellModalShownAgain",
	UpsellGenericModalShown = "UpsellGenericModalShown",
	UpsellGenericModalShownAgain = "UpsellGenericModalShownAgain",
	Cancelled = "Cancelled",
	UpsellFailedNotEnoughRobux = "UpsellFailedNotEnoughRobux",
	UpsellFailedNativePurchase = "UpsellFailedNativePurchase",
	Failed = "Failed",
	Success = "Success"
}

local v6 = enumerate("Counter", v5)

addRawValueMethodToEnum(v6, v5)

return v6
