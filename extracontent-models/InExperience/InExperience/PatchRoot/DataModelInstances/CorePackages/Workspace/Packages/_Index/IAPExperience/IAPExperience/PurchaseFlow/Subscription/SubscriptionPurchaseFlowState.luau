local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local addRawValueMethodToEnum = require(parent.Utility.addRawValueMethodToEnum)
local enumerate = require(parent2.enumerate)

local v = {
	None = "None",
	PurchaseModal = "PurchaseModal",
	Error = "Error",
	PurchaseVPCModal = "PurchaseVPCModal"
}

local v2 = enumerate(script.Name, v)

addRawValueMethodToEnum(v2, v)

return v2
