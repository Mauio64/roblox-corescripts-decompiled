local addRawValueMethodToEnum = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/addRawValueMethodToEnum")

local v5 = {
	None = "None",
	Loading = "Loading",
	PurchasingItem = "PurchasingItem",
	PurchasingRobux = "PurchasingRobux",
	WaitingForPurchase = "WaitingForPurchase",
	WaitingForRobux = "WaitingForRobux"
}
local v6 = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/enumerate")("LoadingOverlayState", v5)

addRawValueMethodToEnum(v6, v5)

return v6
