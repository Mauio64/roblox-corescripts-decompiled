local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local pageHeartbeat = require(CorePackages.Workspace.Packages.Analytics).Events.pageHeartbeat
local userInteractions = require(CorePackages.Workspace.Packages.Analytics).Events.userInteractions
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)

return {
	get = function(p1) -- line: 15
		-- upvalues: RoactAnalytics (copy), pageHeartbeat (copy), userInteractions (copy)
		local v7 = RoactAnalytics.get(p1)

		return {
			reportPageHeartbeat = function(p2, p3) -- line: 20
				-- upvalues: pageHeartbeat (copy), v7 (copy)
				pageHeartbeat(v7.EventStream, p2, p3)
			end,
			reportPageChanged = function() -- line: 24
				-- upvalues: userInteractions (copy), v7 (copy)
				userInteractions(v7.EventStream, "luaPage")
			end
		}
	end
}
