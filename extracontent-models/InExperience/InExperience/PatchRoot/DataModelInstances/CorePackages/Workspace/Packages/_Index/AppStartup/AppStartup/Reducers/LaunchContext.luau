local AppStartup = script:FindFirstAncestor("AppStartup")
local parent = AppStartup.Parent
local SetLaunchContext = require(AppStartup.Actions.SetLaunchContext)
local Rodux = require(parent.Rodux)
require(AppStartup.Enums)

return Rodux.createReducer(nil, {
	[SetLaunchContext.name] = function(_, p)
		return p.launchContext
	end
})
