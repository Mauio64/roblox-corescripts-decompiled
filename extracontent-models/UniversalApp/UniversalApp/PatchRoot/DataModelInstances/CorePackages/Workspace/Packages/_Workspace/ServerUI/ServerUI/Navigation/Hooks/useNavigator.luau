local ServerUI = script:FindFirstAncestor("ServerUI")
local ServerUIParent = ServerUI.Parent
local React = require(ServerUIParent.React)
local NavigationContext = require(ServerUI.Navigation.NavigationContext)

local function useNavigator() -- line: 7
	-- upvalues: React (copy), NavigationContext (copy)
	return React.useContext(NavigationContext)
end

return useNavigator
