local SafetyService = game:GetService("SafetyService")

return {
	reportMenuTabOpen = function() -- line: 8
		-- upvalues: SafetyService (copy)
		SafetyService:ReportMenuTabOpen()
	end,
	reportMenuTabClose = function() -- line: 12
		-- upvalues: SafetyService (copy)
		SafetyService:ReportMenuTabClose()
	end
}
