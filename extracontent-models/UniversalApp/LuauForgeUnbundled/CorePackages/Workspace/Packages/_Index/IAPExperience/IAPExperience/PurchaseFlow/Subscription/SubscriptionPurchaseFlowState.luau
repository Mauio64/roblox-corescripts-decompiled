local addRawValueMethodToEnum = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/addRawValueMethodToEnum")

local v5 = {
	None = "None",
	PurchaseModal = "PurchaseModal",
	Error = "Error",
	PurchaseVPCModal = "PurchaseVPCModal"
}
local v6 = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/enumerate")("SubscriptionPurchaseFlowState", v5)

addRawValueMethodToEnum(v6, v5)

return v6
