local AppStartup = script:FindFirstAncestor("AppStartup")
local parent = AppStartup.Parent
local RoactUtils = require(parent.RoactUtils)
require(AppStartup.Enums)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

return function()
	return useSelector(function(p)
		return p.LaunchContext
	end)
end
