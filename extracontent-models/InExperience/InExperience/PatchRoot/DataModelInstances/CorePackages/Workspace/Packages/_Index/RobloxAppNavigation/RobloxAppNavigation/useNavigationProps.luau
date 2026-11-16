local parent = script:FindFirstAncestor("RobloxAppNavigation").Parent

local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation

require(script.Parent.types)

local function useNavigationProps(callback)
	local v = useNavigation()
	return callback(v.getParam("detail"), v.getParam("extraProps", {}), v)
end

return useNavigationProps
