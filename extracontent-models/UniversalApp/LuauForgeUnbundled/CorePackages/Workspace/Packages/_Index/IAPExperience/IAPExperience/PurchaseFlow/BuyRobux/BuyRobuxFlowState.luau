local addRawValueMethodToEnum = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/addRawValueMethodToEnum")

local v5 = {
	None = "None",
	Loading = "Loading",
	BuyRobux = "BuyRobux",
	PurchaseWarning = "PurchaseWarning",
	RobuxPurchasePending = "RobuxPurchasePending",
	RobuxGrantPending = "RobuxGrantPending",
	Error = "Error",
	Succeed = "Succeed",
	PurchaseVPC = "PurchaseVPC"
}
local v6 = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/enumerate")("BuyRobuxFlowState", v5)

addRawValueMethodToEnum(v6, v5)

return v6
