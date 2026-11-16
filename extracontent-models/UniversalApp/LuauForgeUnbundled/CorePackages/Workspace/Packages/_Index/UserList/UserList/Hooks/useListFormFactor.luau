local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/RoactUtils").Hooks.RoactRodux.useSelector
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Enums")

return function()
	return {
		formFactor = useSelector(function(p2)
			return p2.FormFactor
		end)
	}
end
