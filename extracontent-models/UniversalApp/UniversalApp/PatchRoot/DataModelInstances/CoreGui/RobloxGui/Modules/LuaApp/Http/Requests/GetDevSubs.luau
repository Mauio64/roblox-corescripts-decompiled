local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)
local v3 = require(Modules.LuaApp.Http.UrlBuilder).new({
	path = "developer-subscriptions/v1/subscriptions",
	query = "{userId}&{status}&{includeLookupData}&{cursor|}",
	base = Url.APIS_URL
})

local function getSubscriptions(p1, p2, p3, p4) -- line: 11
	-- upvalues: v3 (copy)
	return p1(v3({
		includeLookupData = "true",
		userId = p2,
		status = p3,
		cursor = p4
	}), "GET")
end

return getSubscriptions
