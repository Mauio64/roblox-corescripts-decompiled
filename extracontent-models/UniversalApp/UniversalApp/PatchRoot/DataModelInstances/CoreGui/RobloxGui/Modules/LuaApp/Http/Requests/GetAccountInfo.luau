local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules

require(CorePackages.Workspace.Packages.Http)

local Url = require(Modules.LuaApp.Http.Url)

return function(p1) -- line: 14
	-- upvalues: Url (copy)
	return p1(string.format("%susers/account-info", Url.API_URL), "GET", {
		maxRetryCount = 0
	})
end
