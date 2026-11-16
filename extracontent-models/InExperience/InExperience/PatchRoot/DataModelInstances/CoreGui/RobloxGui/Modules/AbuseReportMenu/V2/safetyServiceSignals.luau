local SafetyService = game:GetService("SafetyService")
local SafetyServiceSignals = {}

function SafetyServiceSignals.reportMenuTabOpen()
	SafetyService:ReportMenuTabOpen()
end

function SafetyServiceSignals.reportMenuTabClose()
	SafetyService:ReportMenuTabClose()
end

return SafetyServiceSignals
