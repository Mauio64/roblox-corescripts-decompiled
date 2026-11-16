local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")

require(SduiCoreSystem.SduiBuilderTypes)

local function findAnalyticsFieldInAncestors(p: string, p2, p3)
	if not p2 then
		return nil
	end

	assert(p2, "analyticsContext must exist")

	if p2.analyticsData and p2.analyticsData[p] ~= nil then
		return p2.analyticsData[p]
	end

	if p2.ancestorAnalyticsData and p2.ancestorAnalyticsData[p] ~= nil then
		return p2.ancestorAnalyticsData[p]
	end

	return if p3 ~= nil then p3 else nil
end

return findAnalyticsFieldInAncestors
