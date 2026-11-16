local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

math.randomseed(tick())

return function(p, p2, p3, p4)
	if p4 < 100 * math.random() then
		return
	end

	RbxAnalyticsService:ReportToDiagByCountryCode(p, p2, p3)
end
