local Parent = script:FindFirstAncestor("RobloxAppNavigation").Parent
local useNavigation = require(Parent.Navigation).useNavigation

require(script.Parent.types)

local function useNavigationProps(p1) -- line: 8
	-- upvalues: useNavigation (copy)
	local v5 = useNavigation()

	return p1(v5.getParam("detail"), v5.getParam("extraProps", {}), v5)
end

return useNavigationProps
