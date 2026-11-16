local parent = script.Parent.Parent
local parent2 = parent.Parent

local addRawValueMethodToEnum = require(parent.Utility.addRawValueMethodToEnum)
local enumerate = require(parent2.enumerate)

local v = {
	None = "None",
	Loading = "Loading",
	PurchasingItem = "PurchasingItem",
	PurchasingRobux = "PurchasingRobux",
	WaitingForPurchase = "WaitingForPurchase",
	WaitingForRobux = "WaitingForRobux"
}

local v2 = enumerate(script.Name, v)

addRawValueMethodToEnum(v2, v)

return v2
