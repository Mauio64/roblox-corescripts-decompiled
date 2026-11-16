local parent = script:FindFirstAncestor("AppChat").Parent

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

return function()
	return useSelector(function(p)
		return p.Users
	end)
end
