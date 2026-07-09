local AppStartup = script:FindFirstAncestor("AppStartup")
local AppStartupParent = AppStartup.Parent
local SetLaunchContext = require(AppStartup.Actions.SetLaunchContext)
local Rodux = require(AppStartupParent.Rodux)

require(AppStartup.Enums)

return Rodux.createReducer(nil, {
	[SetLaunchContext.name] = function(_, t1: {[any]: any}) -- line: 8
		return t1.launchContext
	end
})
