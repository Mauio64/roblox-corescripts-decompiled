local AppStartup = script:FindFirstAncestor("AppStartup")
local AppStartupParent = AppStartup.Parent
local makeActionCreator = require(AppStartupParent.Rodux).makeActionCreator

require(AppStartup.Enums)

return makeActionCreator(script.Name, function(p1) -- line: 6
	return {
		launchContext = p1
	}
end)
