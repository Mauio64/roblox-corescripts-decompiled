local ParentParent = script.Parent.Parent
local RequestType = require(ParentParent.Enums.RequestType)

function isMultiItemPurchase(p1) -- line: 4
	-- upvalues: RequestType (copy)
	return p1 == RequestType.Look
end

return isMultiItemPurchase
