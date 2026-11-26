local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

math.randomseed(tick())

return function(p2, p3, p4, p5)
	if p5 < 100 * math.random() then
		return
	end

	RbxAnalyticsService:ReportToDiagByCountryCode(p2, p3, p4)
end
