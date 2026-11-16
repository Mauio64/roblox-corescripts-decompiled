local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppHooks/RoactUtils").Hooks.RoactRodux.useSelector

return function()
	return useSelector(function(p2)
		if not p2.TopBar then
			return 0
		end

		if p2.TopBar.statusBarHeight then
			return p2.TopBar.statusBarHeight
		end

		return 0
	end)
end
