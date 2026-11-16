local parent = script:FindFirstAncestor("Moments").Parent

local MomentsCommon = require(parent.MomentsCommon)
require(parent.MomentsTypes)

local makeMomentViewBeganFields = require(script.Parent.makeMomentViewBeganFields)

local Analytics = MomentsCommon.Analytics
local EventNames = Analytics.EventNames

local function logMomentViewBegan(p, p2: string, p3: string?, flag: boolean?)
	Analytics.reportMomentsViewBegan(p2)

	local momentViewBeganFields = makeMomentViewBeganFields(p, p2, p3, flag)

	if momentViewBeganFields ~= nil then
		Analytics.fireAnalyticsEvent(EventNames.MomentViewBegan, momentViewBeganFields)
	end
end

return logMomentViewBegan
