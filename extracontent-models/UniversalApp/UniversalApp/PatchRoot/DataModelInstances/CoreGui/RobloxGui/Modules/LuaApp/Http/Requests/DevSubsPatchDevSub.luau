local Modules = game:GetService("CoreGui").RobloxGui.Modules
local HttpService = game:GetService("HttpService")
local v3 = require(Modules.LuaApp.Http.UrlBuilder).fromString("apis:developer-subscriptions/v1/subscriptions/{subscriptionId}")

return function(p1, p2, p3) -- line: 7
	-- upvalues: v3 (copy), HttpService (copy)
	return p1(v3({
		subscriptionId = p2
	}), "PATCH", {
		postBody = HttpService:JSONEncode({
			isAutoRenewing = p3
		})
	})
end
