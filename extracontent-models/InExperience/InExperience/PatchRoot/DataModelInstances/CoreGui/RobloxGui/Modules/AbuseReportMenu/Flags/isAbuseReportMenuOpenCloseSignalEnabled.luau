game:DefineFastFlag("AbuseReportMenuOpenCloseSignal", false)

return function()
	if game:GetEngineFeature("AbuseReportMenuOpenCloseSignal") then
		return game:GetFastFlag("AbuseReportMenuOpenCloseSignal")
	end

	return false
end
