local parent = script.Parent.Parent.Parent
local React = require(parent.React)
local NavigationContext = require(script.Parent.NavigationContext)

local function useNavigation()
	return React.useContext(NavigationContext)
end

return useNavigation
