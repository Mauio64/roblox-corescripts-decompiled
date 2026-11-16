local parent = script:FindFirstAncestor("RobloxAppHooks").Parent

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

return function()
	return useSelector(function(p)
		if not p.TopBar then
			return 0
		end

		if p.TopBar.statusBarHeight then
			return p.TopBar.statusBarHeight
		end

		return 0
	end)
end
