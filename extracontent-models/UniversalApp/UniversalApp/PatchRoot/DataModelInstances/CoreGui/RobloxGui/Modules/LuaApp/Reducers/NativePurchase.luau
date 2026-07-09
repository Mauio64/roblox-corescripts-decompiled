local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ClearNativePurchaseResult = require(Modules.LuaApp.Actions.ClearNativePurchaseResult)

require(Modules.LuaApp.Enum.NativePurchaseProductTypeEnum)

local SetNativePurchaseResult = require(Modules.LuaApp.Actions.SetNativePurchaseResult)

return function(t1: {[any]: any}?, p1) -- line: 15
	-- upvalues: SetNativePurchaseResult (copy), ClearNativePurchaseResult (copy)
	local v6 = if t1 == nil then {} else t1

	if p1.type == SetNativePurchaseResult.name then
		return {
			nativeProductId = p1.nativeProductId,
			purchaseStatus = p1.purchaseStatus,
			productType = p1.productType
		}
	end

	if p1.type == ClearNativePurchaseResult.name then
		return {}
	end

	return v6
end
