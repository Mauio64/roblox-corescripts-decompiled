local StartPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/StartPurchase")

local function PurchasingStartTimeReducer(value, p2)
	if p2.type == StartPurchase.name then
		return p2.purchasingStartTime
	end

	return value or -1
end

return PurchasingStartTimeReducer
