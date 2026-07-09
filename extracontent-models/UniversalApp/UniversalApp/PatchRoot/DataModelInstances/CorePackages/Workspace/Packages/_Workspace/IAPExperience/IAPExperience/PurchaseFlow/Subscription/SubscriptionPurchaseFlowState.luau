local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local addRawValueMethodToEnum = require(ParentParent.Utility.addRawValueMethodToEnum)
local enumerate = require(ParentParentParent.enumerate)
local t1 = {
	None = "None",
	PurchaseModal = "PurchaseModal",
	Error = "Error",
	PurchaseVPCModal = "PurchaseVPCModal"
}
local v6 = enumerate(script.Name, t1)

addRawValueMethodToEnum(v6, t1)

return v6
