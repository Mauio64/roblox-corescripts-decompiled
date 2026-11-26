local UnifiedEventLogConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/UnifiedEventLogConstants")

local function applyClickStampFieldOverrides(p2, p3)
	if p3[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "selectedItemIndex"] ~= nil then
		p2.selectedItemIndex = nil
	end

	if p3[UnifiedEventLogConstants.ATTRIBUTE_PREFIX .. "keyword"] ~= nil then
		p2.keyword = nil
	end

	return p2
end

return applyClickStampFieldOverrides
