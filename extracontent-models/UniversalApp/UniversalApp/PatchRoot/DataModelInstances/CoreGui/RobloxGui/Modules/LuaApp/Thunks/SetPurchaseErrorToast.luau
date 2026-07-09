local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local getPurchaseErrorTypeFromErrorResponse = require(Modules.LuaApp.getPurchaseErrorTypeFromErrorResponse)
local PurchaseErrorLocalizationKeys = require(Modules.LuaApp.PurchaseErrorLocalizationKeys)

return function(p1) -- line: 7
	-- upvalues: getPurchaseErrorTypeFromErrorResponse (copy), PurchaseErrorLocalizationKeys (copy), SetCurrentToastMessage (copy), ToastType (copy)
	return function(p2) -- line: 8
		-- upvalues: getPurchaseErrorTypeFromErrorResponse (copy), p1 (copy), PurchaseErrorLocalizationKeys (copy), SetCurrentToastMessage (copy), ToastType (copy)
		local v8 = PurchaseErrorLocalizationKeys[getPurchaseErrorTypeFromErrorResponse(p1)]

		p2:dispatch(SetCurrentToastMessage({
			toastType = ToastType.PurchaseMessage,
			toastMessage = v8
		}))
	end
end
