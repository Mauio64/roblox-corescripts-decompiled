game:DefineFastFlag("WebViewServiceHasBackButtonVisibility", false)

return function() -- line: 3
	return game:GetFastFlag("WebViewServiceHasBackButtonVisibility") and game:GetEngineFeature("WebViewHasBackButtonVisible")
end
