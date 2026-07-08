local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local ParentParent = script.Parent.Parent.Parent
local getPlatformTarget = require(ParentParent.Analytics).getPlatformTarget
local Cryo = require(ParentParent.Cryo)

return function(p1) -- line: 8
	-- upvalues: RbxAnalyticsService (copy), Cryo (copy), getPlatformTarget (copy)
	local PlaySessionId = RbxAnalyticsService:GetPlaySessionId()

	return function(s1: string, s2: string, t1: {[any]: any}?) -- line: 11
		-- upvalues: Cryo (copy), PlaySessionId (copy), p1 (copy), getPlatformTarget (copy)
		local v10 = Cryo.Dictionary.join(t1 or {}, {
			playSessionId = PlaySessionId
		})

		p1:SendEventDeferred(getPlatformTarget(), s1, s2, v10)
	end
end
