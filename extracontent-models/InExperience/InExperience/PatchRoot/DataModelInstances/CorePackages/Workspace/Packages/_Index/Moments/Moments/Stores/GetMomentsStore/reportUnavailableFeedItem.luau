local parent = script:FindFirstAncestor("Moments").Parent

local MomentsCommon = require(parent.MomentsCommon)
local MomentsTypes = require(parent.MomentsTypes)

local Analytics = MomentsCommon.Analytics
local MomentStatus = MomentsTypes.Enums.MomentStatus

local function reportUnavailableFeedItem(p, p2: string)
	if p.status == MomentStatus.Deleted then
		Analytics.reportMomentsFeedItemFiltered("deleted", p2)
	elseif p.isModerated == true then
		Analytics.reportMomentsFeedItemFiltered("moderated", p2)
	end
end

return reportUnavailableFeedItem
