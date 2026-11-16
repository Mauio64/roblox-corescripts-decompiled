local defineFastFlag = game:DefineFastFlag("EnableInAppBugReporting", false)

return function()
	return defineFastFlag and game:GetEngineFeature("BugReporterProtocol")
end
