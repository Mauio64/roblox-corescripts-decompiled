local ParentParent = script.Parent.Parent
local StartPurchase = require(ParentParent.Actions.StartPurchase)

local function PurchasingStartTimeReducer(p1, p2) -- line: 5
	-- upvalues: StartPurchase (copy)
	local v6 = p1 or -1

	if p2.type == StartPurchase.name then
		return p2.purchasingStartTime
	end

	return v6
end

return PurchasingStartTimeReducer
