local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Events = Modules.LuaApp.Analytics.Events
local appStageLoaded = require(Events.appStageLoaded)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)

return {
	get = function(p1) -- line: 14
		-- upvalues: RoactAnalytics (copy), appStageLoaded (copy)
		local v6 = RoactAnalytics.get(p1)

		return {
			reportAppReady = function(p2) -- line: 19
				-- upvalues: appStageLoaded (copy), v6 (copy)
				appStageLoaded(v6.EventStream, p2, "appReady")
			end
		}
	end
}
