local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

math.randomseed(tick())

return function(p1, p2, p3, p4) -- line: 5
	-- upvalues: RbxAnalyticsService (copy)
	if p4 < 100 * math.random() then
		return
	end

	RbxAnalyticsService:ReportToDiagByCountryCode(p1, p2, p3)
end
