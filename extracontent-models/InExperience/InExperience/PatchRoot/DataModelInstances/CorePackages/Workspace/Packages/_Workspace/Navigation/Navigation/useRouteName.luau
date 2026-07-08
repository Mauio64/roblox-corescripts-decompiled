local useNavigation = require(script.Parent.useNavigation)

local function useRouteName() -- line: 8
	-- upvalues: useNavigation (copy)
	return useNavigation().state.routeName
end

return useRouteName
