local parent = script:FindFirstAncestor("AppChat").Parent

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

return function(p: string?)
	return useSelector(function(p2)
		if p then
			return p2.Users[p]
		end

		return nil
	end)
end
