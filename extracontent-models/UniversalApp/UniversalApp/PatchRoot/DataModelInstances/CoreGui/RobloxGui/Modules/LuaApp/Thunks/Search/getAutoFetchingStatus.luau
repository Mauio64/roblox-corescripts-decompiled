local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local getAutoFetchName = require(Modules.LuaApp.Thunks.Search.getAutoFetchName)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch

return function(p1, p2) -- line: 6
	-- upvalues: PerformFetch (copy), getAutoFetchName (copy)
	return PerformFetch.GetStatus(p1, getAutoFetchName(p2))
end
