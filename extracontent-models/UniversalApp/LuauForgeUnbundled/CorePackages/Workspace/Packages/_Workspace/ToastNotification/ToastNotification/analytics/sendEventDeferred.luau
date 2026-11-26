local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local getPlatformTarget = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/Analytics").getPlatformTarget
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/Cryo")

return function(object)
	local playSessionId = RbxAnalyticsService:GetPlaySessionId()

	return function(p2, p3, options)
		local joined = Cryo.Dictionary.join(options or {}, {
			playSessionId = playSessionId
		})

		object:SendEventDeferred(getPlatformTarget(), p2, p3, joined)
	end
end
