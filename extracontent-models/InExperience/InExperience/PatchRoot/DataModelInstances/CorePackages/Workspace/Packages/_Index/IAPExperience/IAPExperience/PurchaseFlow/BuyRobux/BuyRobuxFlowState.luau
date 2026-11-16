local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local addRawValueMethodToEnum = require(parent.Utility.addRawValueMethodToEnum)
local enumerate = require(parent2.enumerate)

local v = {
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

local v2 = enumerate(script.Name, v)

addRawValueMethodToEnum(v2, v)

return v2
