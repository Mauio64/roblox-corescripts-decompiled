local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(Modules.LuaApp.Promise)
local PurchaseSubscriptionWithRobux = require(Modules.LuaApp.Http.Requests.SubscriptionsApi.PurchaseSubscriptionWithRobux)

return function(p1, s1: string, n1: number) -- line: 7
	-- upvalues: PurchaseSubscriptionWithRobux (copy), Promise (copy)
	return PurchaseSubscriptionWithRobux(p1, s1, n1):andThen(function(p2) -- line: 8
		-- upvalues: Promise (copy)
		return Promise.resolve(p2.responseBody)
	end, function(p3) -- line: 10
		-- upvalues: Promise (copy)
		return Promise.reject(p3)
	end)
end
