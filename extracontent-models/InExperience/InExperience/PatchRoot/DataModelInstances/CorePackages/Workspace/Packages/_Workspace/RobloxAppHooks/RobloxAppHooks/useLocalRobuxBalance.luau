local parent = script:FindFirstAncestor("RobloxAppHooks").Parent
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useLocalUserId = require(script.Parent.useLocalUserId)

return function()
	local v = useLocalUserId()
	return useSelector(function(p)
		return p.UserRobux[v]
	end)
end
