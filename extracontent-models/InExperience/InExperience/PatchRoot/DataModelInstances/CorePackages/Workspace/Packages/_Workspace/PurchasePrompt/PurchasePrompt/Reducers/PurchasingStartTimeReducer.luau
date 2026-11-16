local parent = script.Parent.Parent

local StartPurchase = require(parent.Actions.StartPurchase)

local function PurchasingStartTimeReducer(value, p)
	if p.type == StartPurchase.name then
		return p.purchasingStartTime
	end

	return value or -1
end

return PurchasingStartTimeReducer
