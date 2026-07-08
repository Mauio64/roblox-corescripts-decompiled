local Parent = script:FindFirstAncestor("Navigation").Parent
local React = require(Parent.React)
local RoactNavigation = require(Parent.RoactNavigation)

local function useNavigation() -- line: 11
	-- upvalues: React (copy), RoactNavigation (copy)
	return React.useContext(RoactNavigation.Context)
end

return useNavigation
