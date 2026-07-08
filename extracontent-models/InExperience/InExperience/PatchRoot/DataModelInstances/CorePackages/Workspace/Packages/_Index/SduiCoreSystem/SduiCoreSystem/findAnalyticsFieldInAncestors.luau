local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")

require(SduiCoreSystem.SduiBuilderTypes)

local function findAnalyticsFieldInAncestors(s1: string, p1, p2) -- line: 9
	if not p1 then
		return nil
	end

	assert(p1, "analyticsContext must exist")

	if p1.analyticsData and p1.analyticsData[s1] ~= nil then
		return p1.analyticsData[s1]
	end

	if p1.ancestorAnalyticsData and p1.ancestorAnalyticsData[s1] ~= nil then
		return p1.ancestorAnalyticsData[s1]
	end

	if p2 ~= nil then
		return p2
	end

	return nil
end

return findAnalyticsFieldInAncestors
