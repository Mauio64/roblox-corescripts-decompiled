local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)

require(CorePackages.Workspace.Packages.Http)

return function(p1) -- line: 7
	-- upvalues: UrlBuilder (copy)
	return p1(UrlBuilder.economy.vngPayments.getVngShopUrl(), "GET")
end
