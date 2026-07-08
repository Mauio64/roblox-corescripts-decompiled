local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)
local NavigationContext = require(script.Parent.NavigationContext)

local function useNavigation() -- line: 8
	-- upvalues: React (copy), NavigationContext (copy)
	return React.useContext(NavigationContext)
end

return useNavigation
