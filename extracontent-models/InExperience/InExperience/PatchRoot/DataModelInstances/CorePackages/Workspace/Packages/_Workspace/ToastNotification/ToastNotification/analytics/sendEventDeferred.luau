local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local parent = script.Parent.Parent.Parent
local Analytics = require(parent.Analytics)
local getPlatformTarget = Analytics.getPlatformTarget
local Cryo = require(parent.Cryo)

return function(object)
	local playSessionId = RbxAnalyticsService:GetPlaySessionId()

	return function(p: string, p2: string, options)
		local joined = Cryo.Dictionary.join(options or {}, { playSessionId = playSessionId })

		object:SendEventDeferred(getPlatformTarget(), p, p2, joined)
	end
end
