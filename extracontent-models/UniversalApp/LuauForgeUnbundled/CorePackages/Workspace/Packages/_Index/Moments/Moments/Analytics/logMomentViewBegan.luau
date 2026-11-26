local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")

local makeMomentViewBeganFields = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Analytics/makeMomentViewBeganFields")

local analytics = MomentsCommon.Analytics
local eventNames = analytics.EventNames

local function logMomentViewBegan(p2, p3, p4, p5)
	analytics.reportMomentsViewBegan(p3)

	local v5 = makeMomentViewBeganFields(p2, p3, p4, p5)

	if v5 ~= nil then
		analytics.fireAnalyticsEvent(eventNames.MomentViewBegan, v5)
	end
end

return logMomentViewBegan
