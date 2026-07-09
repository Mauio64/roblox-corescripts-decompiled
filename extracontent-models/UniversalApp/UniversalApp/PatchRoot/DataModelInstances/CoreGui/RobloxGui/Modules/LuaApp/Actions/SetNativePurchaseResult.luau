local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Action = require(Modules.Common.Action)

require(Modules.LuaApp.Enum.NativePurchaseProductTypeEnum)

return Action(script.Name, function(s1: string, p1, p2) -- line: 10
	return {
		nativeProductId = s1,
		purchaseStatus = p1,
		productType = p2
	}
end)
