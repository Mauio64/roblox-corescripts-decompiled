local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ApiFetchIAPProducts = require(Modules.LuaApp.Thunks.ApiFetchIAPProducts)

return function(p1, _) -- line: 5
	-- upvalues: ApiFetchIAPProducts (copy)
	local Subscriptions = p1.IAPProducts.Subscriptions

	return {
		screenSize = p1.ScreenSize,
		subscriptionProduct = Subscriptions and Subscriptions[1] or nil,
		iapProductsFetchingStatus = ApiFetchIAPProducts.GetFetchingStatus(p1)
	}
end
