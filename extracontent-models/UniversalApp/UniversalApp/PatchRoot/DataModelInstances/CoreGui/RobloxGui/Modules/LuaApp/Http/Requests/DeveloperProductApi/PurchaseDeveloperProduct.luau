local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local Modules = CoreGui.RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)
local ArgCheck = require(Modules.LuaApp.ArgCheck)
local t = require(CorePackages.Packages.t)
local EconomyTypes = require(Modules.LuaApp.Types.EconomyTypes)
local v9 = t.tuple(t.callback, t.integer, EconomyTypes.PurchaseDetail)

return function(p1, p2, p3) -- line: 13
	-- upvalues: ArgCheck (copy), v9 (copy), Url (copy), HttpService (copy)
	ArgCheck.assert(v9(p1, p2, p3))

	return p1(("%sdeveloper-products/v1/developer-products/%i/purchase?requestLocationType=ExperienceDetailPage"):format(Url.APIS_URL, p2), "POST", {
		postBody = HttpService:JSONEncode(p3)
	})
end
