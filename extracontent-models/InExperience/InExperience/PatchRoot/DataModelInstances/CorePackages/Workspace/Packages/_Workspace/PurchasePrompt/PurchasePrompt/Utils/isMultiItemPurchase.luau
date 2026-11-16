local parent = script.Parent.Parent
local RequestType = require(parent.Enums.RequestType)

function isMultiItemPurchase(p): boolean
	return p == RequestType.Look
end

return isMultiItemPurchase
