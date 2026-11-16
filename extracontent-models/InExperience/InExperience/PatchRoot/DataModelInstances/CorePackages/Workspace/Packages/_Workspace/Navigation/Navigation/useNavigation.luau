local parent = script:FindFirstAncestor("Navigation").Parent

local React = require(parent.React)
local RoactNavigation = require(parent.RoactNavigation)

local function useNavigation()
	return React.useContext(RoactNavigation.Context)
end

return useNavigation
