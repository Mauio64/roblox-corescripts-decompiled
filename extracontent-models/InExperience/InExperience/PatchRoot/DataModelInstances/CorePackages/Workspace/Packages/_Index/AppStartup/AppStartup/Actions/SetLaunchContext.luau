local AppStartup = script:FindFirstAncestor("AppStartup")
local parent = AppStartup.Parent
local Rodux = require(parent.Rodux)
local makeActionCreator = Rodux.makeActionCreator
require(AppStartup.Enums)

return makeActionCreator(script.Name, function(launchContext)
	return { launchContext = launchContext }
end)
