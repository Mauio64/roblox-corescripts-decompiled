local v1 = game:DefineFastFlag("EnableInAppBugReporting", false)

return function() -- line: 3
	-- upvalues: v1 (copy)
	return v1 and game:GetEngineFeature("BugReporterProtocol")
end
