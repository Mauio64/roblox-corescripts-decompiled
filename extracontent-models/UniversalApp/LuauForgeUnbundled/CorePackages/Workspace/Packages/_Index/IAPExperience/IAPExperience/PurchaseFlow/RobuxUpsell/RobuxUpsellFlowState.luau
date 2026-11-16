local addRawValueMethodToEnum = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/addRawValueMethodToEnum")

local v5 = {
	None = "None",
	Loading = "Loading",
	PurchaseModal = "PurchaseModal",
	GenericPurchaseModal = "GenericPurchaseModal",
	LargeRobuxPurchaseModal = "LargeRobuxPurchaseModal",
	PurchaseWarning = "PurchaseWarning",
	TwoStepRequired = "TwoStepRequired",
	RobuxPurchasePending = "RobuxPurchasePending",
	RobuxGrantPending = "RobuxGrantPending",
	ItemPurchasePending = "ItemPurchasePending",
	Success = "Success",
	LeaveRobloxWarning = "LeaveRobloxWarning",
	Error = "Error",
	PurchaseVPCModal = "PurchaseVPCModal"
}
local v6 = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/enumerate")("RobuxUpsellFlowState", v5)

addRawValueMethodToEnum(v6, v5)

return v6
