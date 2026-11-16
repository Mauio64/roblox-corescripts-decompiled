local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector

return function(p2)
	return useSelector(function(p3)
		if p2 then
			return p3.Users[p2]
		end

		return nil
	end)
end
