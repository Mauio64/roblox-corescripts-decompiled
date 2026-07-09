local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local Modules = CoreGui.RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)
local ArgCheck = require(Modules.LuaApp.ArgCheck)
local t = require(CorePackages.Packages.t)
local v8 = t.tuple(t.callback, t.string)

return function(p1, s1: string, n1: number) -- line: 12
	-- upvalues: ArgCheck (copy), v8 (copy), Url (copy), HttpService (copy)
	ArgCheck.assert(v8(p1, s1, n1))

	return p1(string.format("%sv1/subscriptions/purchase-with-robux/%s", Url.APIS_URL, s1), "POST", {
		postBody = HttpService:JSONEncode({
			priceInRobux = n1
		})
	})
end
