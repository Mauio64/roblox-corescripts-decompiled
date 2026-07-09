local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local addRawValueMethodToEnum = require(ParentParent.Utility.addRawValueMethodToEnum)
local enumerate = require(ParentParentParent.enumerate)
local t1 = {
	None = "None",
	Loading = "Loading",
	PurchasingItem = "PurchasingItem",
	PurchasingRobux = "PurchasingRobux",
	WaitingForPurchase = "WaitingForPurchase",
	WaitingForRobux = "WaitingForRobux"
}
local v6 = enumerate(script.Name, t1)

addRawValueMethodToEnum(v6, t1)

return v6
