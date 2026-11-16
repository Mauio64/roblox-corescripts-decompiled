local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppNavigation/Navigation").useNavigation

require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppNavigation/RobloxAppNavigation/types")

local function useNavigationProps(callback)
	local v5 = useNavigation()
	return callback(v5.getParam("detail"), v5.getParam("extraProps", {}), v5)
end

return useNavigationProps
