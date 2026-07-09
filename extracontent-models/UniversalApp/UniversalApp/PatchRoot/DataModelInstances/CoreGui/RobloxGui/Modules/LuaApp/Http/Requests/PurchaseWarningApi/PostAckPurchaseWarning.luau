local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)

require(CorePackages.Workspace.Packages.Http)

return function(p1, s1: string) -- line: 8
	-- upvalues: UrlBuilder (copy), HttpService (copy)
	return p1(UrlBuilder.economy.purchaseWarning.ackPurchaseWarning(), "POST", {
		postBody = HttpService:JSONEncode({
			acknowledgement = s1
		})
	})
end
