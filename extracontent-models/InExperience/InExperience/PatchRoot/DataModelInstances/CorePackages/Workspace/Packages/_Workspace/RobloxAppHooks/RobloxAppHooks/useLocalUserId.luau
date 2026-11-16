local parent = script:FindFirstAncestor("RobloxAppHooks").Parent
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

return function()
	return useSelector(function(p)
		return p.LocalUserId
	end)
end
