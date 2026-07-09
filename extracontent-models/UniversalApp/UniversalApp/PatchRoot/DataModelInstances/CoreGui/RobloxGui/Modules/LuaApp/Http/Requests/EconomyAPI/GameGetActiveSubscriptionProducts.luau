local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)

return function(p1, p2) -- line: 4
	-- upvalues: Url (copy)
	return p1(string.format("%sv1/subscriptions/active-subscription-products?subscriptionProductType=1&subscriptionProviderId=%s", Url.APIS_URL, p2), "GET")
end
