game:DefineFastFlag("AbuseReportMenuOpenCloseSignal", false)

return function() -- line: 3
	if not game:GetEngineFeature("AbuseReportMenuOpenCloseSignal") then
		return false
	end

	return game:GetFastFlag("AbuseReportMenuOpenCloseSignal")
end
