local AvatarWorkshop = script:FindFirstAncestor("AvatarWorkshop")
local parent = AvatarWorkshop.Parent

local React = require(parent.React)
local RoactNavigation = require(parent.RoactNavigation)

require(AvatarWorkshop.Navigation.NavigationTypes)

local function useNavigation()
	return React.useContext(RoactNavigation.Context)
end

return useNavigation
