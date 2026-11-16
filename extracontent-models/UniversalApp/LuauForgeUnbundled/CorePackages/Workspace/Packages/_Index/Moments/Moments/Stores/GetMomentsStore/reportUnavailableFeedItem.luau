local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local MomentsTypes = require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")

local analytics = MomentsCommon.Analytics
local momentStatus = MomentsTypes.Enums.MomentStatus

local function reportUnavailableFeedItem(p2, p3)
	if p2.status == momentStatus.Deleted then
		analytics.reportMomentsFeedItemFiltered("deleted", p3)
	elseif p2.isModerated == true then
		analytics.reportMomentsFeedItemFiltered("moderated", p3)
	end
end

return reportUnavailableFeedItem
