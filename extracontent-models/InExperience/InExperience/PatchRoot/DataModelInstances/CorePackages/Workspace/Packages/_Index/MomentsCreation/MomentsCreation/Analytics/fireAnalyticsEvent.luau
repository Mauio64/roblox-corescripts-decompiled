local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local MomentsCommon = require(parent.MomentsCommon)

local hostAnalyticsListener = require(MomentsCreation.Analytics.hostAnalyticsListener)

local fireAnalyticsEvent = MomentsCommon.Analytics.fireAnalyticsEvent

return function(p, p2)
	fireAnalyticsEvent(p, p2)

	local v = hostAnalyticsListener.get()

	if v ~= nil then
		v(p, p2)
	end
end
