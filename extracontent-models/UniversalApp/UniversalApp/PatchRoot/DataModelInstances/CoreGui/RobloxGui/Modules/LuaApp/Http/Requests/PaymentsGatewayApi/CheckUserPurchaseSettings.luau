local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)

require(CorePackages.Workspace.Packages.Http)

return function(p1) -- line: 8
	-- upvalues: UrlBuilder (copy), HttpService (copy)
	return p1(UrlBuilder.economy.paymentsGateway.checkUserPurchaseSettings(), "POST", {
		postBody = HttpService:JSONEncode({}),
		headers = {
			["Content-Type"] = "application/json",
			Accept = "application/json"
		}
	})
end
