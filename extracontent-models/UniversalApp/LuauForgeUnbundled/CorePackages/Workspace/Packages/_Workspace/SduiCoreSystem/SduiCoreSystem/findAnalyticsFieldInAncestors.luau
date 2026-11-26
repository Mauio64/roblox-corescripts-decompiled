require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")

local function findAnalyticsFieldInAncestors(p2, p3, p4)
	if not p3 then
		return nil
	end

	assert(p3, "analyticsContext must exist")

	if p3.analyticsData and p3.analyticsData[p2] ~= nil then
		return p3.analyticsData[p2]
	end

	if p3.ancestorAnalyticsData and p3.ancestorAnalyticsData[p2] ~= nil then
		return p3.ancestorAnalyticsData[p2]
	end

	if p4 == nil then
		return nil
	end

	return p4
end

return findAnalyticsFieldInAncestors
