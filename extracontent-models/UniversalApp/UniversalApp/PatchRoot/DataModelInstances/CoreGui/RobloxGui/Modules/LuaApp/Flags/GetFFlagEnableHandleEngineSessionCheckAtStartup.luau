game:DefineFastFlag("EnableHandleEngineSessionCheckAtStartup", false)

return function() -- line: 3
	return game:GetFastFlag("EnableHandleEngineSessionCheckAtStartup") and game:GetEngineFeature("SessionCheckInEngineEnabled")
end
