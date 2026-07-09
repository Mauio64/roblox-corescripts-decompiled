local AppStartup = script:FindFirstAncestor("AppStartup")
local AppStartupParent = AppStartup.Parent
local RoactUtils = require(AppStartupParent.RoactUtils)

require(AppStartup.Enums)

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

return function() -- line: 7
	-- upvalues: useSelector (copy)
	return useSelector(function(p1) -- line: 8
		return p1.LaunchContext
	end)
end
